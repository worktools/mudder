
Mudder
----

> what if we can fix JSON from Swagger API in a more visual way?

Demo https://r.tiye.me/worktools/mudder/ .

Named "mudder" since it sounds a bit like s**wagger**.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

Use Calcit/procs 0.27.0, Node.js 24 and Yarn 4.18.0 with the canonical
`calcit.cirru` and `deps.cirru`. Run `caps --strict --ci`, `yarn install --immutable`,
then `yarn dev` or `yarn build`.

CI keeps canonical formatting, strict entry/public contract checks and the
actual frontend build. Main uploads frontend assets to
`https://cos-sh.tiye.me/worktools/mudder/` using COS action v1.1.1's built-in
public verification. Pull requests only build; server sync retains the
original `dist/*` source and destination. No separate upload checker is needed.

### License

MIT
