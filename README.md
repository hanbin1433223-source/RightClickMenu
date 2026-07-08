# 即建

即建是一款 macOS Finder 右键增强工具，用来解决 Mac 新建文本、Markdown、Word、Excel、PPT 文件不方便的问题。

第一版目标是源码开源发布。你可以下载本项目，用 Xcode 构建后在自己的 Mac 上使用。

## 功能

- 在 Finder 右键菜单中显示“即建”。
- 支持新建 `txt`、`md`、`rtf`、`docx`、`xlsx`、`pptx`。
- 自动命名文件，不覆盖已有文件。
- 在 App 中开关不同文件类型。
- 中文优先，面向普通 Mac 用户。

## 系统要求

- macOS 14.0 或更高版本
- Xcode 16 或更高版本

## 使用步骤

1. 用 Xcode 打开 `RightClickMenu.xcodeproj`。
2. 选择 `RightClickMenu` target 构建并运行。
3. 在 Xcode 的 Signing & Capabilities 中为主 App 和 Extension 添加 App Groups：`group.com.rightclickmenu`。
4. 打开系统设置。
5. 进入“隐私与安全性”或“扩展”相关设置。
6. 找到 Finder 扩展，启用“即建 Finder 扩展”。
7. 打开 Finder，在桌面、文稿或下载目录右键，选择“即建”。

## 常见问题

### 右键菜单没有出现

先确认 Finder 扩展已经在系统设置中启用。如果刚启用后还看不到，可以重启 Finder 或重新运行 App。

### 构建时报 App Groups 错误

需要在 Xcode 里手动给主 App 和 FinderSync Extension 添加同一个 App Groups：`group.com.rightclickmenu`。

### 下载后能不能直接双击使用

第一版是源码发布，不提供签名公证安装包。普通用户需要用 Xcode 构建运行。

## 设计预览

视觉风格预览保存在 `docs/design/jijian-style-preview.html`。

## 开源协议

MIT License
