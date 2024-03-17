import { Kysely } from "kysely";

export async function up(db: Kysely<any>): Promise<void> {
    await db.schema
        .createIndex('account_username_index')
        .on('account')
        .column('username')
        .execute()
}

export async function down(db: Kysely<any>): Promise<void> {
    await db.schema.dropIndex('account_username_index').execute()
}