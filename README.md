
Mudder
----

> what if we can fix JSON from Swagger API in a more visual way?

Demo https://r.tiye.me/worktools/mudder/ .

Named "mudder" since it sounds a bit like s**wagger**.

### 0.32.1 迁移候选对使用者的影响

CLI 与 `@calcit/procs` 配对正式 `0.32.1`，需重新生成 JS 并刷新页面。
Respo `0.17.0`、Reel `0.7.0`、UI `0.9.0`、Alerts `0.11.0` 当前用本地候选图验收，
JS-FFI 使用正式 `0.2.8`；候选依赖的正式发布整图与 PR CI 尚待验证，不能据此部署。

官方工具转换 15 处类型写法，28 个定义 schema 不变；原测试中一处函数类型标注同步转换，
六项测试的业务断言保持。239 个定义、完整 strict、原六项测试、不可变安装和构建通过。
实际浏览器导入合成 schema、渲染必填字段和嵌套数组、选中字段包装数组、修改布尔类型及
刷新恢复通过，控制台无警告或错误。未新增系统剪贴板、命名片段或坏存档验收。
保留 `hud!`、存档合同、原门禁及部署条件。COS/rsync 使用已核对的精确正式 action tag，
npm 包年龄门禁为一小时，无白名单；不增加校验脚本，不放宽类型合同。

0.32.1 补丁复核已通过原门禁与构建；页面验收沿用此前 0.32.0 的记录。
官方 patch 未改运行时源码，本轮未重复浏览器交互，不将静态复核表述为新页面验收。

### 历史：0.31.0 使用者影响

配对升级到正式 Calcit / procs 0.31.0，需重新安装依赖并完整刷新页面。
Respo、Reel、UI 和 Alerts 当前配套 tag 仍为已发布的精确 alpha 版本，
不将它们称作正式稳定版。Swagger 文档、命名片段、存档格式与实际 `hud!` 保留；
此次不修改生产部署路径或自动保存保护。

路径读取按新版 Result 合同处理，仍将缺失或 nil 的选中值视为无内容，结构错误明确报错；
原测试仅同步三处路径读取结果的构造器，业务断言不变。dispatch 类型槽绑定
受现有 Enum 检查和操作解码约束的入口，导入和保存提示事件执行后明确返回 Unit。
不增加验证脚本，不放宽原类型门禁。Prompt 上游的开放返回合同由
[Alerts #104](https://github.com/Respo/alerts.calcit/issues/104) 跟踪。

### 既有 0.30.1 迁移记录（历史）

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

Use paired formal Calcit/procs 0.32.1, Node.js 24 and Yarn 4.18.0 with the canonical
`calcit.cirru` and `deps.cirru`. Run `caps --strict --ci`, `yarn install --immutable`,
then `yarn dev` or `yarn build`.
Run `yarn watch` in a separate terminal when editing Calcit. `yarn dev` compiles
once before starting Vite; production builds also compile once. No extra process
manager is needed.

The previous 0.31.0 migration used Respo 0.17.0-alpha.4, Reel 0.7.0-alpha.4,
UI 0.9.0-alpha.4, Alerts 0.11.0-alpha.3 and js-ffi 0.2.7. That published graph
does not validate the current 0.32.0 candidates listed above.
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
COS/rsync actions use exact verified release tags. Calcit candidate module tags are
listed above; local validation does not prove that the published dependency graph is available.

### License

MIT
