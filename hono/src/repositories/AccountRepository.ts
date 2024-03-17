import { Context } from "hono";
import { db } from "../db";
import { PaginationParams } from "../params/pagination";
import { Account, AccountUpdate, NewAccount } from "../types";
import { paginatedResult } from "./PaginatedResult";
import { sql } from "kysely";

export async function findAccountById(c: Context, id: number) {
    return await db(c).selectFrom('account')
        .where('id', '=', id)
        .select(['id', 'name', 'username', 'role'])
        .executeTakeFirst()
}

export async function findAccountDetailById(c: Context, id: number, keyword: string, startDate: string, endDate: string, pagination: PaginationParams) {
    const accountDetail = await db(c).transaction().execute(async (trx) => {
        const account = await trx.selectFrom('account')
            .where('id', '=', id)
            .select([
                'id',
                'name',
                'username',
                'role'
            ])
            .executeTakeFirst()
        
        const { total_debit } = await trx.selectFrom('entry')
            .where('debtor_id', '=', id)
            .select([
                sql<number>`coalesce(sum(amount), 0)`.as('total_debit')
            ]).executeTakeFirstOrThrow()
        
        const { total_credit } = await trx.selectFrom('entry')
            .where('creditor_id', '=', id)
            .select([
                sql<number>`coalesce(sum(amount), 0)`.as('total_credit')
            ]).executeTakeFirstOrThrow()
        
        let entryQuery = trx.selectFrom('entry')

        if (keyword) {
            const words = keyword.trim().split(' ')

            words.forEach(word => entryQuery = entryQuery.where('description', 'ilike', `%${word}%`))
        }

        if (startDate) {
            entryQuery = entryQuery.where('created_at', '>=', sql<Date>`${startDate}`)
        }
    
        if (endDate) {
            entryQuery = entryQuery.where('created_at', '<=', sql<Date>`${endDate}`)
        }

        const entries = await entryQuery
            .selectAll()
            .orderBy('created_at')
            .execute()

        const { total_query_debit } = await entryQuery
            .where('debtor_id', '=', id)
            .select([
                sql<number>`coalesce(sum(amount), 0)`.as('total_query_debit')
            ]).executeTakeFirstOrThrow()
        
        const { total_query_credit } = await entryQuery
            .where('creditor_id', '=', id)
            .select([
                sql<number>`coalesce(sum(amount), 0)`.as('total_query_credit')
            ]).executeTakeFirstOrThrow()

        return {
            account: {
                ...account,
                total_debit: Number(total_debit),
                total_credit: Number(total_credit),
                total_query_debit: Number(total_query_debit),
                total_query_credit: Number(total_query_credit),
                entries
            }
        }
    })

    return accountDetail
}

export async function findAccountByUsername(c: Context, username: string) {
    return await db(c).selectFrom('account')
        .where('username', '=', username)
        .select(['id', 'name', 'username', 'role'])
        .executeTakeFirst()
}

export async function findAccountByUsernameWithPassword(c: Context, username: string) {
    return await db(c).selectFrom('account')
        .where('username', '=', username)
        .selectAll()
        .executeTakeFirst()
}

export async function findAccounts(c: Context, criteria: Partial<Account>, pagination: PaginationParams) {
    let query = db(c).selectFrom('account')

    if (criteria.name) {
        const words = criteria.name.trim().split(' ')

        words.forEach(word => {
            query = query.where('name', 'ilike', `%${word}%`)
        })
    }

    if (criteria.username) {
        query = query.where('username', 'ilike', `%${criteria.username}%`)
    }

    const dataQuery = query
        .select(({ selectFrom }) => [
            'id',
            'name',
            'username',
            'role',
            selectFrom('entry')
                .whereRef('entry.debtor_id', '=', 'account.id')
                .select([
                    sql<number>`coalesce(sum(entry.amount), 0)`.as('total_debit')
                ])
                .as('total_debit'),
            selectFrom('entry')
                .whereRef('entry.creditor_id', '=', 'account.id')
                .select([
                    sql<number>`coalesce(sum(entry.amount), 0)`.as('total_credit')
                ])
                .as('total_credit')
        ])
        .orderBy('username')

    const result = await paginatedResult(query, dataQuery, pagination)
    
    return result
}

export async function createAccount(c: Context, account: NewAccount) {
    return await db(c).insertInto('account')
        .values(account)
        .returningAll()
        .executeTakeFirstOrThrow()
}

export async function updateAccount(c: Context, id: number, updateWith: AccountUpdate) {
    await db(c).updateTable('account').set(updateWith).where('id', '=', id).execute()
}

export async function deleteAccount(c: Context, id: number) {
    return await db(c).deleteFrom('account').where('id', '=', id).returningAll().executeTakeFirst()
}