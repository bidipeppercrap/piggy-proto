import { Context, Hono } from "hono";

const controller = new Hono();

const about = {
    author: {
        name: "bidipeppercrap",
        phone: "+62 851 7171 9191",
        email: "bidipeppercrap@proton.me"
    }
};

controller.get("/", (c: Context) => c.json(about));

export default controller;