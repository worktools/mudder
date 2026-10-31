# Mudder

用于可视化调整 Swagger API 的 JSON。名称来自 Swagger，Demo：<https://r.tiye.me/worktools/mudder/>。

## 对使用者的影响

迁移到正式 Calcit / `@calcit/procs` **0.32.1**，需重新安装依赖、生成 JS 并完整刷新页面。
Swagger 文档、命名片段、内部 Copy/Paste、未知扩展字段和 `workflow` 存档格式保持，实际 `hud!` 页面提示保留。
Respo UI 依赖升级可能产生样式差异，不承诺逐像素相同。PR 不合并或部署生产。

依赖使用已发布的 Respo 0.17.1、UI 0.9.0、JS FFI 0.2.9，以及已验收的精确 Reel 0.7.0-alpha.5、Alerts 0.11.0-alpha.4。
保留后两项 alpha 标签，不将它们称作稳定版，也不依赖尚未发布的正式版本。

## 迁移和验收

通过官方工具转换 15 处类型写法，28 个定义的 schema 不变；原测试一处函数类型标注同步转换，六项业务断言保持。
此前迁移保留受 Enum 检查和操作解码约束的 dispatch 入口，导入/保存事件返回 Unit，文本回调保持 String→Unit。
路径读取按 Result 合同处理，缺失或 nil 的选中值仍视为无内容，结构错误明确报错。
Swagger JSON 和 Respo 状态保留真实异构边界，不增加伪强转、质量预算或防御测试。

在真实发布依赖图上，Caps 严格安装解析 6 个模块，工具链配对、不可变安装、239 个定义、完整 strict、原六项测试和构建通过。
0.32.1 未改此前已审阅的运行时源码；页面验收沿用 0.32.0 的合成 schema 导入、必填字段/嵌套数组渲染、字段包装数组、布尔类型编辑和刷新恢复记录。
本轮未重复浏览器交互，不将静态复核表述为新页面验收；也未新增系统剪贴板、命名片段或坏存档验收。

## 开发

使用 Node.js 24、Yarn 4.18.0、Calcit 0.32.1，项目文件为 `calcit.cirru`、`deps.cirru`。

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
COS 使用 action v1.2.0 自身的公开访问校验，不复制额外校验脚本。
Actions 使用精确正式 tag；npm 年龄门禁为一小时，无单包豁免。

## License

MIT
