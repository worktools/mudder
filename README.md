
Mudder
----

> what if we can fix JSON from Swagger API in a more visual way?

Demo https://r.tiye.me/worktools/mudder/ .

Named "mudder" since it sounds a bit like s**wagger**.

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

Use paired formal Calcit/procs 0.30.1, Node.js 24 and Yarn 4.18.0 with the canonical
`calcit.cirru` and `deps.cirru`. Run `caps --strict --ci`, `yarn install --immutable`,
then `yarn dev` or `yarn build`.
Run `yarn watch` in a separate terminal when editing Calcit. `yarn dev` compiles
once before starting Vite; production builds also compile once. No extra process
manager is needed.

Respo 0.16.124, Reel 0.6.41, UI 0.8.0, Alerts 0.10.57 and js-ffi 0.2.5
use exact formal releases in `deps.cirru`, with a consistent strict Caps graph.
The 16 old source Option calls and two calls inside an original test use public
methods; the six original business regressions and archive format are retained.

### Existing saved data

The `workflow` localStorage key and flat Map archive format are unchanged.
Restoration validates the known fields and retains unknown root fields,
Swagger extensions and named fragment values. A malformed archive pauses
automatic saving and displays an error instead of overwriting the old data.
Swagger JSON and heterogeneous Respo cursor state remain explicit open
boundaries; application operations and the root store have concrete types.

Run `calcit --check-only --all-defs`, `calcit fix --workflow strict --verify`
and `calcit test --require-match` before building. Regression assertions live
with the Store and updater definitions; no extra upload checker is required.

CI keeps canonical formatting, strict entry/public contract checks and the
actual frontend build. Main uploads frontend assets to
`https://cos-sh.tiye.me/worktools/mudder/` using COS action v1.2.0's built-in
public verification. Pull requests only build and retain a relative-URL artifact
for interaction acceptance, without assuming an unuploaded PR CDN prefix exists;
server sync retains the
original `dist/*` source and destination. No separate upload checker is needed.
Queued production runs check the current main revision once before publishing;
stale revisions skip both COS upload and server sync.

### License

MIT
