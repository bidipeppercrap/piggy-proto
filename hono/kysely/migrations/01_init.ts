import { Kysely, sql } from "kysely";

export async function up(db: Kysely<any>): Promise<void> {
    await db.schema
        .createTable('account')
        .addColumn('id', 'serial', (col) => col.primaryKey())
        .addColumn('name', 'varchar', (col) => col.notNull())
        .addColumn('username', 'varchar', (col) => col.notNull())
        .addColumn('password', 'varchar', (col) => col.notNull())
        .addColumn('role', 'varchar', (col) => col.notNull())
        .execute()

    await db.schema
        .createTable('entry')
        .addColumn('id', 'serial', (col) => col.primaryKey())
        .addColumn('description', 'text', (col) => col.defaultTo(''))
        .addColumn('amount', 'numeric(13, 5)', (col) => col.notNull())
        .addColumn('debtor_id', 'integer', (col) =>
            col.references('account.id').onDelete('set null').notNull()
        )
        .addColumn('creditor_id', 'integer', (col) =>
            col.references('account.id').onDelete('set null').notNull()
        )
        .addColumn('created_at', 'timestamp', (col) =>
            col.defaultTo(sql`now()`).notNull())
        .execute()
}

export async function down(db: Kysely<any>): Promise<void> {
    await db.schema.dropTable('entry').execute()
    await db.schema.dropTable('account').execute()
}