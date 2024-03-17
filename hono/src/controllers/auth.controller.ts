import { Context, Hono } from "hono";
import { verifyPassword } from "../lib/password";
import { findAccountByUsername, findAccountByUsernameWithPassword } from "../repositories/AccountRepository";
import { sign } from "hono/jwt";
import { jwtMiddleware } from "../middlewares/jwt.middleware";
import { accountantAuthMiddleware } from "../middlewares/auth.middleware";

const controller = new Hono();

controller.get('/auth_test/accountant', jwtMiddleware, accountantAuthMiddleware, async (c: Context) => {
    const payload = c.get('jwtPayload')

    return c.json({ type: 'accountant', payload })
})

controller.get('/auth_test/user', jwtMiddleware, async (c: Context) => {
    const payload = c.get('jwtPayload')

    return c.json({ type: 'user', payload})
})

controller.post("/login", async (c: Context) => {
    const body = await c.req.json()

    const credential = {
        username: body["username"] as string,
        password: body["password"] as string
    }

    const account = await findAccountByUsernameWithPassword(c, credential.username)

    if (!account) return c.json({
        message: 'username not found'
    }, 400)

    const result = await verifyPassword(account.password, credential.password)

    if (!result) return c.json({
        message: 'incorrect password'
    }, 400)

    const token = await sign({
        ...account,
        password: undefined
    }, c.env['JWT_SECRET'])

    return c.json({
        token
    })
})

export default controller;