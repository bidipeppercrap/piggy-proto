import { Context, Next } from "hono";

export const accountantAuthMiddleware = async (c: Context, next: Next) => {
    const payload = c.get('jwtPayload')

    if (!payload['role']) return c.json({
        message: 'missing role/invalid'
    }, 401)

    const role = payload['role']

    if (role !== 'accountant') return c.json({
        message: 'only accountant can do it'
    }, 401)

    await next()
}