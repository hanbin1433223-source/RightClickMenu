# 即建

> 在 Finder 右键，即刻新建文件。

即建是一款 macOS 菜单栏工具，解决 Mac 无法在访达中直接新建文本文档、Markdown、Word、Excel、PPT 文件的痛点。点击菜单栏图标或按快捷键，即可在当前访达窗口位置创建文件。

## 使用方式

| 方式 | 操作 |
|------|------|
| 🖱 菜单栏 | 点击菜单栏 `📄` 图标 → 选择文件类型 |
| ⌨️ 快捷键 | 按 `⌥⌘N` → 弹出窗口选择类型 |

文件自动创建在当前最前面的访达窗口目录，如果未打开访达则创建到桌面。重名自动追加编号（如 `新建文本文档 2.txt`）。

## 系统要求

- macOS 14.0+

## 技术架构

```
Sources/
├── RightClickMenuApp/   主 App (SwiftUI MenuBarExtra)
│   ├── App.swift         入口 + 快捷键处理
│   └── ContentView.swift 设置/使用说明窗口
└── rclick/               CLI 工具，负责创建文件
    └── main.swift        接收 create <扩展名> 参数
```

- **即建.app** — 主程序，MenuBarExtra 常驻菜单栏，按 `⌥⌘N` 弹出文件类型选择器
- **rclick** — 内嵌 CLI 工具，被主 App 调用，通过 AppleScript 获取当前 Finder 路径，创建文件并高亮显示

## 构建

```bash
git clone <repo-url>
cd RightClickMenu
sh build_app.sh
```

构建产物自动安装到 `/Applications/即建.app`。

## 已知限制

macOS 27 beta 移除了访达的「服务」菜单，且免费 Apple ID 无法注册 FinderSync 扩展，因此暂无右键菜单方式。菜单栏 + 快捷键是当前最稳定的方案。

## 开源协议

MIT License
