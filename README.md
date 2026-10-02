
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
Run `yarn watch` in a separate terminal when editing Calcit. `yarn dev` compiles
once before starting Vite; production builds also compile once. No extra process
manager is needed.

CI keeps canonical formatting, strict entry/public contract checks and the
actual frontend build. Main uploads frontend assets to
`https://cos-sh.tiye.me/worktools/mudder/` using COS action v1.2.0's built-in
public verification. Pull requests only build; server sync retains the
original `dist/*` source and destination. No separate upload checker is needed.
Queued production runs check the current main revision once before publishing;
stale revisions skip both COS upload and server sync.

### License

MIT
