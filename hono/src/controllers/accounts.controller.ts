import { Context, Hono, Next } from "hono";
import { createAccount, deleteAccount, findAccountById, findAccountByUsername, findAccountDetailById, findAccounts } from "../repositories/AccountRepository";
import { NewAccount } from "../types";
import { hashPassword } from "../lib/password";
import { jwtMiddleware } from "../middlewares/jwt.middleware";
import { accountantAuthMiddleware } from "../middlewares/auth.middleware";

const controller = new Hono();

controller.use("/*", jwtMiddleware)

controller.on(['POST', 'PUT', 'DELETE'], '/*', accountantAuthMiddleware)
controller.on(['GET'], '/:id', accountantAuthMiddleware)

controller.get('/', async (c: Context, next: Next) => {
    const payload = c.get('jwtPayload')
    const role = payload['role']

    if (role === 'accountant') return await accountantGet(c)
    if (role === 'user') return await userGet(c)

    return c.json({ message: 'end of route' }, 400)
})

controller.get('/:id', async (c: Context) => {
    const id = parseInt(c.req.param('id'))
    const pageNumber = parseInt(c.req.query().pageNumber)
    const pageSize = parseInt(c.req.query().pageSize)
    const startDate = c.req.query().startDate
    const endDate = c.req.query().endDate
    const keyword = c.req.query().keyword

    const account = await findAccountDetailById(c, id, keyword, startDate, endDate, { pageNumber, pageSize })

    return c.json(account)
})

const userGet = async (c: Context) => {
    const payload = c.get('jwtPayload')
    const jwtAccountId = payload['id']
    const pageNumber = parseInt(c.req.query().pageNumber)
    const pageSize = parseInt(c.req.query().pageSize)
    const startDate = c.req.query().startDate
    const endDate = c.req.query().endDate
    const keyword = c.req.query().keyword

    const account = await findAccountDetailById(c, jwtAccountId, keyword, startDate, endDate, { pageNumber, pageSize })

    return c.json(account)
}

const accountantGet = async (c: Context) => {
    const name = c.req.query().name
    const pageNumber = c.req.query().pageNumber ? parseInt(c.req.query().pageNumber) : 1
    const pageSize = c.req.query().pageSize ? parseInt(c.req.query().pageSize) : 10

    const result = await findAccounts(c, { name }, { pageNumber, pageSize })

    return c.json(result)
};

controller.post("/", async (c: Context) => {
    const body = await c.req.json()

    const newAccount: NewAccount = {
        name: body["name"] as string,
        username: body["username"] as string,
        password: body["password"] as string,
        role: body["role"] as "accountant" | "user"
    }

    const account = await findAccountByUsername(c, newAccount.username)

    if (account) return c.json({
        message: 'account with the same username already exists'
    }, 400)

    newAccount.password = await hashPassword(newAccount.password)

    const result = await createAccount(c, newAccount)

    return c.json({
        ...result,
        password: undefined
    })
})

controller.delete('/:id', async (c: Context) => {
    const id = c.req.param('id')

    const exists = await findAccountById(c, parseInt(id))

    if (!exists) return c.json({
        message: 'account not found'
    }, 404)

    const account = await deleteAccount(c, parseInt(id))

    return c.json({
        ...account,
        password: undefined
    })
})

export default controller;