import { Context, Hono, Next } from "hono";
import { NewEntry } from "../types";
import { jwtMiddleware } from "../middlewares/jwt.middleware";
import { accountantAuthMiddleware } from "../middlewares/auth.middleware";
import { createEntry, deleteEntry } from "../repositories/EntryRepository";

const controller = new Hono();

controller.use("/*", jwtMiddleware, accountantAuthMiddleware)

controller.post("/", async (c: Context) => {
    const body = await c.req.json()

    const newEntry: NewEntry = {
        description: body['description'] as string,
        amount: body['amount'] as number,
        debtor_id: body['debtor_id'] as number,
        creditor_id: body['creditor_id'] as number
    }

    const result = await createEntry(c, newEntry)

    return c.json(result)
})

controller.delete('/:id', async (c: Context) => {
    const id = c.req.param('id')

    const entry = await deleteEntry(c, parseInt(id))

    if (!entry) return c.json({
        message: 'entry not found'
    }, 400)

    return c.json(entry)
})

export default controller;