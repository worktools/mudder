# Mudder

用于可视化调整 Swagger API 的 JSON。名称来自 Swagger，Demo：<https://r.tiye.me/worktools/mudder/>。

## 对使用者的影响

本项目使用 Calcit 和 `@calcit/procs` 0.42.1。升级后请重新安装依赖并编译前端。

组件状态更新接受由 Tag、字符串和数字组成的混合路径。旧存档的顶层 UI 状态键按同一个 Tag、String、Number union 校验，Swagger 扩展字段和命名片段继续保留。非法状态键沿用原坏存档保护。必填字段星号、内部剪贴板类型标签和开发面板按各自原有条件显示。

Swagger 根节点和递归节点在进入渲染器前检查为 String 键 Map。空节点沿用空 Map 的展示。开发面板的控制与应用操作在事件校验后使用不同的类型分支，旧 Alerts 弹窗仍可发送匿名状态事件。

Respo 0.19.5、UI 0.15.2、Reel 0.11.0、Alerts 0.14.3 和 JS FFI 0.2.13 均使用正式版本。

## 开发

使用 Node.js 24、Yarn 4.18.0、Calcit 0.42.1，项目文件为 `calcit.cirru`、`deps.cirru`。

```sh
caps --strict --ci
yarn install --immutable
caps verify --toolchain
calcit --check-only --all-defs
calcit fix --workflow strict --verify
calcit test --require-match
yarn build
yarn dev
```

`yarn dev` 编译一次并启动 Vite；编辑时可另开终端运行 `yarn watch`，不增加过程管理器。
工作流参考 <https://github.com/calcit-lang/respo-calcit-workflow>。

## 存档和部署

恢复时检查已知字段，保留未知根字段、Swagger 扩展和命名片段值。
坏存档会暂停自动保存并显示错误，避免覆盖原文；未加载文档时显示导入提示，实际导入仍由原渲染器检查，非法 schema 不视为空文档。

CI 保留 canonical、完整 strict、原测试及前端构建。PR 仅保存使用相对 URL 的构建 artifact，不上传 COS 或执行 rsync。
Main 发布前检查当前提交，旧提交跳过 COS 和 rsync；只上传 `dist`，原服务器路径不变。
COS 使用 action v1.3.0 自身的公开访问校验，不复制额外校验脚本。
Actions 使用精确正式 tag；npm 年龄门禁为一小时，无单包豁免。

## License

MIT
