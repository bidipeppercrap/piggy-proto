import { Context } from "hono";
import { db } from "../db";
import { PaginationParams } from "../params/pagination";
import { NewEntry } from "../types";
import { paginatedResult } from "./PaginatedResult";

export async function findEntries(c: Context, accountId: number, keyword: string, startDate: string, endDate: string, pagination: PaginationParams) {
    let query = db(c).selectFrom('entry')
        .where((eb) => eb.or([
            eb('debtor_id', '=', accountId),
            eb('creditor_id', '=', accountId)
        ]))

    if (keyword) {
        const words = keyword.trim().split(' ')

        words.forEach(word => {
            query = query.where('description', 'ilike', `%${word}%`)
        })
    }

    // if (startDate) {
    //     query = query.where('created_at', '>=', startDate)
    // }

    // if (endDate) {
    //     query = query.where('created_at', '<=', endDate)
    // }

    const dataQuery = query
        .selectAll()
        .orderBy('created_at')

    const result = await paginatedResult(query, dataQuery, pagination)
    
    return result
}

export async function createEntry(c: Context, entry: NewEntry) {
    return await db(c).insertInto('entry')
        .values(entry)
        .returningAll()
        .executeTakeFirstOrThrow()
}

export async function deleteEntry(c: Context, id: number) {
    return await db(c).deleteFrom('entry').where('id', '=', id).returningAll().executeTakeFirst()
}