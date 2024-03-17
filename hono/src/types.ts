import { ColumnType, Generated, Insertable, Selectable, Updateable } from "kysely";

export interface Database {
    account: AccountTable
    entry: EntryTable
}

export interface AccountTable {
    id: Generated<number>
    name: string
    username: string
    password: string
    role: 'accountant' | 'user'
}

export type Account = Selectable<AccountTable>
export type NewAccount = Insertable<AccountTable>
export type AccountUpdate = Updateable<AccountTable>

export interface EntryTable {
    id: Generated<number>
    description: string
    amount: number
    debtor_id: number
    creditor_id: number
    created_at: ColumnType<Date, string | undefined, never>
}

export type Entry = Selectable<EntryTable>
export type NewEntry = Insertable<EntryTable>
export type EntryUpdate = Updateable<EntryTable>