# UI 优化实现计划

> **面向 AI 代理的工作者：** 必需子技能：使用 subagent-driven-development（推荐）或 executing-plans 逐任务实现此计划。步骤使用复选框（`- [ ]`）语法来跟踪进度。

**目标：** 将设置窗口从 TabView 改造成 NavigationSplitView 侧边栏布局，内容区采用 List + insetGrouped 原生样式，弹窗加毛玻璃，统一 padding，清理死代码。

**架构：** SettingsView 改用 NavigationSplitView 包裹三个子视图；三个子视图各自改用 List + Section(insetGrouped) 替代手写卡片；PopoverView/QuickPanelView 加 .ultraThinMaterial 毛玻璃。

**技术栈：** SwiftUI, macOS 14+

---

### 任务 1：SettingsView — NavigationSplitView 侧边栏

**文件：**
- 修改：`Sources/RightClickMenuApp/Views/Settings/SettingsView.swift`

- [ ] **步骤 1：重写 SettingsView**

```swift
import SwiftUI

struct SettingsView: View {
    @ObservedObject private var settings = SettingsManager.shared
    @State private var selectedTab: SettingsTab = .usage

    enum SettingsTab: String, CaseIterable, Hashable {
        case usage = "使用说明"
        case fileTypes = "文件类型"
        case advanced = "高级"

        var icon: String {
            switch self {
            case .usage: return "info.circle"
            case .fileTypes: return "doc.on.doc"
            case .advanced: return "gearshape"
            }
        }
    }

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedTab) {
                ForEach(SettingsTab.allCases, id: \.self) { tab in
                    Label(tab.rawValue, systemImage: tab.icon)
                        .tag(tab)
                }
            }
            .listStyle(.sidebar)
            .frame(minWidth: 160)
        } detail: {
            detailContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(
                    LinearGradient(
                        colors: [.white, Color.gray.opacity(0.03)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }
        .frame(minWidth: 640, minHeight: 480)
    }

    @ViewBuilder
    private var detailContent: some View {
        switch selectedTab {
        case .usage: UsageTab()
        case .fileTypes: FileTypesTab()
        case .advanced: AdvancedTab()
        }
    }
}
```

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add Sources/RightClickMenuApp/Views/Settings/SettingsView.swift
git commit -m "refactor(settings): replace TabView with NavigationSplitView sidebar"
```

---

### 任务 2：UsageTab — 改用 List + Section

**文件：**
- 修改：`Sources/RightClickMenuApp/Views/Settings/UsageTab.swift`

- [ ] **步骤 1：重写 UsageTab**

去掉手画卡片、自定义圆点数字行。改用 List + Section + native Label：

```swift
import SwiftUI

struct UsageTab: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        List {
            Section {
                VStack(spacing: 12) {
                    Spacer().frame(height: 8)
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [settings.currentAccentColor, settings.currentAccentColor.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 56, height: 56)
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundStyle(.white)
                    }

                    Text("即建")
                        .font(.title.weight(.bold))

                    Text("在 Finder 右键，即刻新建文件")
                        .font(.body)
                        .foregroundStyle(.secondary)
                    Spacer().frame(height: 8)
                }
                .frame(maxWidth: .infinity)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }

            Section {
                Label {
                    Text("点击菜单栏图标，选择文件类型")
                } icon: {
                    Image(systemName: "1.circle.fill")
                        .foregroundStyle(settings.currentAccentColor)
                }
                .padding(.vertical, 2)

                Label {
                    Text("或按快捷键 \(settings.settings.hotKeyConfig.display)，选择类型")
                } icon: {
                    Image(systemName: "2.circle.fill")
                        .foregroundStyle(settings.currentAccentColor)
                }
                .padding(.vertical, 2)

                Label {
                    Text("文件创建在当前访达窗口位置或桌面")
                } icon: {
                    Image(systemName: "3.circle.fill")
                        .foregroundStyle(settings.currentAccentColor)
                }
                .padding(.vertical, 2)
            } header: {
                Label("使用步骤", systemImage: "list.number")
            }
        }
        .listStyle(.insetGrouped)
    }
}
```

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add Sources/RightClickMenuApp/Views/Settings/UsageTab.swift
git commit -m "refactor(settings): rewrite UsageTab with List + insetGrouped"
```

---

### 任务 3：FileTypesTab — 改用 List + Section

**文件：**
- 修改：`Sources/RightClickMenuApp/Views/Settings/FileTypesTab.swift`

- [ ] **步骤 1：重写 FileTypesTab**

把 `categoryCard` 替换成 Section 分组：

```swift
import SwiftUI

struct FileTypesTab: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        List {
            ForEach(FileCategory.allCases, id: \.self) { category in
                let types = FileTypeManager.all.filter { $0.category == category }
                if !types.isEmpty {
                    Section {
                        ForEach(types) { type in
                            Toggle(isOn: Binding(
                                get: { settings.isEnabled(type.id) },
                                set: { _ in settings.toggleType(type.id) }
                            )) {
                                Label(type.label, systemImage: type.symbol)
                                    .foregroundStyle(type.isInstalled ? .primary : .secondary)
                            }
                            .toggleStyle(.switch)
                            .disabled(!type.isInstalled)
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.icon)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }
}
```

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add Sources/RightClickMenuApp/Views/Settings/FileTypesTab.swift
git commit -m "refactor(settings): rewrite FileTypesTab with List + insetGrouped sections"
```

---

### 任务 4：AdvancedTab — 改用 List + Section

**文件：**
- 修改：`Sources/RightClickMenuApp/Views/Settings/AdvancedTab.swift`

- [ ] **步骤 1：重写 AdvancedTab**

```swift
import SwiftUI

struct AdvancedTab: View {
    @ObservedObject private var settings = SettingsManager.shared

    var body: some View {
        List {
            Section {
                HStack {
                    Text("快捷键")
                    Spacer()
                    HotKeyRecorder(
                        config: Binding(
                            get: { settings.settings.hotKeyConfig },
                            set: { settings.settings.hotKeyConfig = $0 }
                        ),
                        onChange: { settings.setHotKey($0) }
                    )
                    .frame(width: 200)
                }
                .padding(.vertical, 2)
            } header: {
                Label("快捷键", systemImage: "keyboard")
            }

            Section {
                Toggle(isOn: Binding(
                    get: { settings.settings.quickCreateMode },
                    set: { settings.setQuickCreate($0) }
                )) {
                    Text("按快捷键时直接创建，不弹出选择")
                }

                if settings.settings.quickCreateMode {
                    HStack {
                        Text("默认类型")
                        Spacer()
                        Picker("", selection: Binding(
                            get: { settings.settings.defaultTypeID },
                            set: { settings.setDefaultType($0) }
                        )) {
                            ForEach(settings.enabledTypes) { type in
                                Text(type.label).tag(type.id)
                            }
                        }
                        .labelsHidden()
                    }
                }
            } header: {
                Label("快速创建", systemImage: "bolt")
            }

            Section {
                Toggle(isOn: Binding(
                    get: { settings.settings.launchOnLogin },
                    set: { settings.setLaunchOnLogin($0) }
                )) {
                    Text("开机后自动运行即建")
                }
            } header: {
                Label("启动", systemImage: "power")
            }
        }
        .listStyle(.insetGrouped)
    }
}
```

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add Sources/RightClickMenuApp/Views/Settings/AdvancedTab.swift
git commit -m "refactor(settings): rewrite AdvancedTab with List + insetGrouped sections"
```

---

### 任务 5：PopoverView — 毛玻璃 + 行高统一

**文件：**
- 修改：`Sources/RightClickMenuApp/Views/Popover/PopoverView.swift`

- [ ] **步骤 1：加毛玻璃背景、统一行高**

给顶层 VStack 加 `.background(.ultraThinMaterial)`，TypeRow padding 统一为 `vertical: 10`。

```swift
var body: some View {
    VStack(spacing: 0) {
        BrandHeader()
        // ... rest unchanged
    }
    .frame(width: 280)
    .background(.ultraThinMaterial)
}
```

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add Sources/RightClickMenuApp/Views/Popover/PopoverView.swift
git commit -m "refactor(popover): add ultraThinMaterial background"
```

---

### 任务 6：QuickPanelView — 补齐搜索栏 + 分类头 + 毛玻璃

**文件：**
- 修改：`Sources/RightClickMenuApp/Views/QuickPanel/QuickPanelView.swift`

- [ ] **步骤 1：重写 QuickPanelView**

复制 PopoverView 的搜索栏和分类 section headers：

```swift
import SwiftUI

struct QuickPanelView: View {
    @ObservedObject private var settings = SettingsManager.shared
    @State private var searchText = ""

    private var filtered: [FileTypeDef] {
        let list = settings.enabledTypes
        if searchText.isEmpty { return list }
        return list.filter { $0.label.localizedCaseInsensitiveContains(searchText) || $0.ext.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            BrandHeader()
            if !settings.enabledTypes.isEmpty {
                searchBar
                Divider()
            }
            typeList
            Divider()
            Text("按 ESC 关闭")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .padding(.vertical, 8)
        }
        .frame(width: 280)
        .background(.ultraThinMaterial)
    }

    private var searchBar: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.caption)
            TextField("搜索文件类型...", text: $searchText)
                .textFieldStyle(.plain)
                .font(.callout)
                .frame(height: 20)
            if !searchText.isEmpty {
                Button { searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }

    private var typeList: some View {
        ScrollView {
            VStack(spacing: 0) {
                if filtered.isEmpty {
                    VStack(spacing: 4) {
                        Image(systemName: "tray")
                            .font(.title2)
                            .foregroundStyle(.tertiary)
                        Text(searchText.isEmpty ? "还没有启用文件类型" : "没有匹配的类型")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 40)
                } else {
                    ForEach(grouped, id: \.category) { group in
                        if !group.types.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(group.category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                                    .textCase(.uppercase)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 10)
                                    .padding(.bottom, 4)
                                ForEach(group.types) { type in
                                    TypeRow(
                                        type: type,
                                        onSelect: { FileCreator.create(type.ext) }
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .frame(maxHeight: 300)
    }

    private var grouped: [CategoryGroup] {
        let cats = Set(filtered.map(\.category))
        return cats.sorted { $0.rawValue < $1.rawValue }.map { cat in
            CategoryGroup(category: cat, types: filtered.filter { $0.category == cat })
        }
    }
}

private struct CategoryGroup {
    let category: FileCategory
    let types: [FileTypeDef]
}
```

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add Sources/RightClickMenuApp/Views/QuickPanel/QuickPanelView.swift
git commit -m "refactor(quickpanel): add search bar, category headers, ultraThinMaterial"
```

---

### 任务 7：TypeRow — 统一 padding

**文件：**
- 修改：`Sources/RightClickMenuApp/Views/Components/TypeRow.swift`

- [ ] **步骤 1：修改 TypeRow 行高**

`padding(.vertical, 8)` → `padding(.vertical, 10)`

```swift
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
```

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add Sources/RightClickMenuApp/Views/Components/TypeRow.swift
git commit -m "style(typerow): unify vertical padding to 10"
```

---

### 任务 8：清理死代码 + 不再使用的文件

**范围检查：**
- 检查所有 Swift 源文件中未使用的 import、变量、类型
- 特别检查：Build 涉及的全部文件

- [ ] **步骤 1：检查并移除无用代码**

核心检查清单：
- [x] `QuickPanelView.swift` — 已移除 `hoveredTypeID`
- [x] `FileTypesTab.swift` — 已移除 `hoveredTypeID`
- [x] `SettingsView.swift` — 已移除 `hoveredTypeID`
- [x] `OnboardingView.swift` — 已移除 `BounceModifier`
- [ ] 检查所有文件的 import 语句，删除未使用的 import
- [ ] 检查 `BrandHeader.swift` — 只有 PopoverView 和 QuickPanelView 在使用，确认
- [ ] 检查 `TypeRow.swift` — FileTypesTab 不再直接用 TypeRow（改用原生 Toggle），但 Popover/QuickPanel 仍用

注意：FileTypesTab 任务 3 改用了原生 Toggle，不再使用 TypeRow。但 PopoverView/QuickPanelView 仍用 TypeRow。TypeRow 不能删。

- [ ] **步骤 2：编译验证**

运行：`xcrun swift build 2>&1 | tail -5`
预期：Build complete

- [ ] **步骤 3：Commit**

```bash
git add -A
git commit -m "chore: clean up unused code"
```

---

### 任务 9：最终验证 + Git 提交

- [ ] **步骤 1：全量构建**

运行：`sh build_app.sh 2>&1`
预期：构建成功，安装到 /Applications

- [ ] **步骤 2：确认 Git 状态**

```bash
git status
git log --oneline -5
```

- [ ] **步骤 3：推送**

```bash
git push
```
