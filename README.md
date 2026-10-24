
Mudder
----

> what if we can fix JSON from Swagger API in a more visual way?

Demo https://r.tiye.me/worktools/mudder/ .

Named "mudder" since it sounds a bit like s**wagger**.

### 本轮使用者影响

继续配对正式 Calcit / procs 0.30.1，升级精确正式依赖后需要重新安装、重启开发服务并完整刷新。
Swagger 文档、命名片段、内部 Copy/Paste、未知扩展字段和 `workflow` 存档格式保持；
不清空或迁移用户存档，不修改自动保存保护与实际 `hud!` 提示。
UI 升级可能带来样式差异，不承诺逐像素相同。本轮不授权合并、部署或发版。

六处 Map merge 改用 `.merge`，十六处静态 CSS 叶子改为等价 String，
两份静态样式类型从 Map Tag Dynamic 收紧为 Map Tag String。
Load/Save 两处事件按真实 Respo EventHandler 声明 dispatch，两个 Prompt 文本回调明确 String→Unit；
修复新依赖图下原先两处完整 strict 失败，不使用伪 Enum 参数或强转。
Swagger 与 Respo 状态仍保留真实异构边界，原六项业务测试和断言不变；
不增加强转、质量预算、防御测试、重复 COS 校验或过程管理器。

### Workflow

https://github.com/calcit-lang/respo-calcit-workflow

Use paired formal Calcit/procs 0.30.1, Node.js 24 and Yarn 4.18.0 with the canonical
`calcit.cirru` and `deps.cirru`. Run `caps --strict --ci`, `yarn install --immutable`,
then `yarn dev` or `yarn build`.
Run `yarn watch` in a separate terminal when editing Calcit. `yarn dev` compiles
once before starting Vite; production builds also compile once. No extra process
manager is needed.

Respo 0.16.126, Reel 0.6.42, UI 0.8.1, Alerts 0.10.58 and js-ffi 0.2.6
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
Before any document is loaded, the UI shows an import hint instead of warning
about an unknown schema. Imported documents still go through the original renderer
and invalid-schema warnings; this does not treat invalid data as an empty document.

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
Credential-bearing COS/rsync actions retain their original full commit pins with
release labels. Calcit modules still use exact formal version tags.

### License

MIT
