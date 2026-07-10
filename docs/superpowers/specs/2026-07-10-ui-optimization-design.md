# UI 优化设计方案

## 目标

解决「界面分散、单调、不够高级」的问题，提升视觉一致性和 macOS 原生感。

## 改动范围

### 1. 设置窗口：TabView → NavigationSplitView 侧边栏

- 用 `NavigationSplitView` + `List(.sidebar)` 替代 `TabView`
- 左侧侧边栏：图标 + 文字列表，「使用说明」「文件类型」「高级」
- 右侧内容区：显示当前选中的 tab 内容
- 窗口尺寸：`minWidth: 640, minHeight: 480`

### 2. 内容区：List + Section(insetGrouped) 替代手写卡片

- 所有 tab 内容改用 `.listStyle(.insetGrouped)`
- 用系统 `Section` header 替代手画渐变圆点 + Label
- 行高统一 `vertical: 10`
- 分割线缩进统一 52（图标 30 + 间距 10 + 水平 padding 12）
- 移除三处重复的 `RoundedRectangle(cornerRadius:12) + fill(.background) + shadow`

#### UsageTab
- 保留欢迎图标 + 标题，改用 Section 分组排版使用步骤
- 步骤行用 `Label` + SF Symbol 替代手画圆 + 数字

#### FileTypesTab
- 用 Section + insetGrouped 替代 `categoryCard`
- 每类文件一个 Section，header 用 `Text(category.rawValue)` + `Image(systemName: cat.icon)`
- TypeRow 保持现有组件，调整 padding

#### AdvancedTab
- 每个功能组一个 Section：「快捷键」「快速创建」「启动」
- 系统原生 `Toggle`、`Picker` 布局在 Section 内

### 3. 窗口背景

- NavigationSplitView detail 加极淡渐变背景 `LinearGradient`（接近白但有一丝冷暖变化）
- 侧边栏保持原生样式

### 4. 弹窗毛玻璃

- PopoverView + QuickPanelView：`.background(.ultraThinMaterial)`

### 5. QuickPanelView 功能补齐

- 加搜索栏（与 PopoverView 一致）
- 加分类 section headers（与 PopoverView 一致）
- 移除未使用的 `hoveredTypeID`

### 6. 去除 BounceModifier

- 已在前一轮删除，确认不重新引入

## 不改动的文件

- `FileType.swift` / `AppSettings.swift`（数据模型）
- `FileCreator.swift` / `SettingsManager.swift`（服务层）
- `AppDelegate.swift` / `AppEntry.swift` / `HotKeyManager.swift`（App 层）
- `rclick/`（CLI 工具）
- `Package.swift` / `build_app.sh`
- `TypeRow.swift` / `BrandHeader.swift`（组件保留，仅微调 padding）

## 验证

1. `xcrun swift build` 编译通过
2. `sh build_app.sh` 构建安装
3. 功能不变：设置/弹窗/快速面板/引导页均可正常操作
