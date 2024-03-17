import { Database } from './types'
import { NeonDialect } from 'kysely-neon'
import { Kysely } from 'kysely'
import { Context, Env } from 'hono'
import { Bindings } from '.'

const dialect = (connectionString: string) => new NeonDialect({
    connectionString: connectionString
})

export const db = (context: Context<Env, '/', any>) => {
    const c = (context.env as unknown as Bindings)

    return new Kysely<Database>({
        dialect: dialect(c.NEON_CONNECTION_STRING)
    })
}
