# 即建开发规范

## 项目概要

即建是一款 macOS Finder 右键增强工具，用 SwiftUI 主 App + FinderSync Extension 实现。

## 技术约定

- 语言：Swift 6，保持 Swift 5 兼容写法。
- UI：SwiftUI，不使用 XIB 或 Storyboard。
- 目标系统：macOS 14.0+。
- Bundle ID：`com.rightclickmenu.app` / `com.rightclickmenu.app.finder-extension`。
- App Groups：`group.com.rightclickmenu`。
- 不使用私有 API。
- 不注入 Finder。
- 不修改系统文件。
- 不在代码中写入个人签名或证书信息。

## 开发流程

1. 修改源码。
2. 如果新增或删除文件，运行 `python3 generate_pbxproj.py`。
3. 用 Xcode 或 `xcodebuild` 构建。
4. 在系统设置中启用 Finder 扩展后手动验证。

## 产品基调

- App 名称：即建。
- Slogan：在 Finder 右键，即刻新建文件。
- 风格：原生、轻量、可靠、中文友好。
- 图标方向：文档 + 加号。
