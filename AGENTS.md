# 即建开发规范

## 项目概要

即建是一款 macOS Finder 新建文件工具，用 SwiftUI MenuBarExtra 主 App + CLI 工具实现。

## 技术约定

- 语言：Swift 6。
- UI：SwiftUI。
- 目标系统：macOS 14.0+。
- Bundle ID：`com.rightclickmenu.app`。
- 不使用私有 API。
- 不注入 Finder。
- 不修改系统文件。

## 开发流程

1. 修改源码（`Sources/` 目录）。
2. 运行 `sh build_app.sh` 构建并安装到 `/Applications`。
3. 点击菜单栏图标验证，或按 `⌥⌘N` 快捷键测试。

## 产品基调

- App 名称：即建。
- Slogan：在 Finder 右键，即刻新建文件。
- 风格：原生、轻量、可靠、中文友好。

## 架构说明

```
Sources/
  RightClickMenuApp/
    App.swift           — @main 入口，MenuBarExtra 场景，全局快捷键 (Carbon RegisterEventHotKey)
    ContentView.swift   — 设置/使用说明窗口
  rclick/
    main.swift          — CLI: rclick create <ext>，AppleScript 获取 Finder 路径，创建文件
```

- 快捷键 `⌥⌘N` 使用 Carbon `RegisterEventHotKey` 注册，不依赖辅助功能权限。
- 文件创建委托给内嵌 CLI 工具 `rclick`，通过 `Process` 调用。
- `rclick` 用 AppleScript 获取 Finder 选中目录，自动编号避免重名，创建后选中文件。
