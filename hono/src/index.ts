import { Hono } from "hono";

import { indexController, accountsController, authController, entriesController } from "./controllers/index";

export type Bindings = {
    NEON_CONNECTION_STRING: string,
    JWT_SECRET: string
}

const app = new Hono<{ Bindings: Bindings}>();

app.route("/", indexController)
app.route("/", authController)
app.route('/accounts', accountsController)
app.route('/entries', entriesController)

export default app;