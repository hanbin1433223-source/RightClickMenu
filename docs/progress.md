# 即建项目进度记录

## 当前阶段

v1 第一轮已完成：项目从空目录推进到可构建的 SwiftUI 主 App + FinderSync Extension 骨架，并已推送到 GitHub。

GitHub 仓库：<https://github.com/hanbin1433223-source/RightClickMenu>

## 已确认决策

- App 名称：即建
- App 定位：macOS Finder 右键新建文件工具
- 第一版发布方式：GitHub 源码发布
- 主要语言：中文优先
- 开源协议：MIT
- UI 风格：原生清爽风，浅灰白背景，青蓝强调色
- 图标方向：文档 + 加号
- 右键菜单：Finder 中显示“即建”二级菜单
- 第一版文件类型：`txt`、`md`、`rtf`、`docx`、`xlsx`、`pptx`
- 命名方式：自动命名，重名自动追加编号
- 技术策略：v1 稳定兼容优先，不强依赖 macOS beta 或 Liquid Glass；v1.1 再做新系统视觉增强

## 已完成工作

- 创建产品规格文档：`docs/specs/2026-07-08-jijian-product-spec.md`
- 创建视觉展示稿：`docs/design/jijian-style-preview.html`
- 创建 Xcode 工程：`RightClickMenu.xcodeproj`
- 创建 SwiftUI 主 App 基础界面
- 创建 FinderSync Extension 基础入口
- 实现文件类型模型：`FileType`
- 实现共享配置：`AppConfig` / `ExtensionConfig`
- 实现文件创建服务：`FileCreator`
- 实现基础模板管理：`TemplateManager`
- 添加 README、LICENSE、AGENTS.md、.gitignore
- 添加工程生成脚本：`generate_pbxproj.py`
- 初始化 Git 仓库
- 配置 GitHub SSH key
- 推送 `main` 分支到 GitHub

## 已验证

- `python3 generate_pbxproj.py` 可生成 `project.pbxproj`
- `xcodebuild -list -project RightClickMenu.xcodeproj` 可识别项目、target 和 scheme
- `xcodebuild -project RightClickMenu.xcodeproj -scheme RightClickMenu -configuration Debug -derivedDataPath ./DerivedData build CODE_SIGNING_ALLOWED=NO` 构建通过
- GitHub SSH 认证成功
- 本地 `main` 已推送到远程 `origin/main`

## 当前风险

- 还没有在真实 Finder 中启用扩展并手动验证右键菜单。
- App Groups capability 仍需要在 Xcode 中手动确认。
- 当前 App 图标是 SwiftUI 内部视觉标记，还没有完整 `.appiconset` 图标资源。
- Office 模板是最小 Open XML 骨架，需要后续用真实 Office/iWork 打开验证。
- 第一版还没有自动化测试。

## 下一步建议

1. 在 Xcode 中打开工程，确认主 App 和 Extension 的 Signing & Capabilities。
2. 手动添加或确认 App Groups：`group.com.rightclickmenu`。
3. 构建运行 App，并在系统设置中启用 Finder 扩展。
4. 在 Finder 中手动验证“即建”右键菜单和六种文件创建。
5. 补正式 App 图标资源。
6. 根据手动验证结果修复 FinderSync 和文件创建细节。
7. v1.1 再评估 Liquid Glass、Glass Button、Background Extension Effect 等新 SwiftUI 视觉能力，并通过系统版本判断做渐进增强。

## 最近一次记录

- 日期：2026-07-08
- 状态：v1 第一轮工程骨架完成，已构建通过并推送 GitHub。已确认 v1 稳定兼容优先，v1.1 再适配最新系统视觉能力。
