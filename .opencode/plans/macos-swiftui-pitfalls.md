# macOS SwiftUI 常见坑点记录

> 项目：即建 (RightClickMenu)
> 用途：开发前翻阅，避免重复踩坑

---

## NavigationSplitView

### 侧边栏可被拖拽消失
- **现象**：侧边栏分隔条可拖拽至 0 宽度，内容区占据全屏后无法恢复
- **原因**：`NavigationSplitView` 默认允许完全折叠 sidebar
- **解决**：`.navigationSplitViewColumnWidth(min: 160, ideal: 180, max: 220)` 锁定最小宽度

### 列表选中色
- **现象**：`List(.sidebar)` 选中项高亮默认使用系统蓝色
- **原因**：不跟随用户自定义的主色
- **解决**：`.tint(SettingsManager.shared.currentAccentColor)`

---

## 分割线

### 系统 Divider() 在毛玻璃上过硬
- **现象**：`Divider()` 在 `ultraThinMaterial` 背景上颜色太深，边缘生硬
- **原因**：系统 Divider 的样式不可自定义，默认对比度过高
- **解决**：用 `Rectangle().fill(Color.gray.opacity(0.06)).frame(height: 1)` 替代

### 自定义分割线颜色
- BrandHeader 底部分隔线用 0.12 太重，0.06 合适
- 分割线颜色应使用极小透明度，`0.06` 在毛玻璃上刚好

---

## 背景色

### 纯白背景在 macOS 上偏冷
- **现象**：`.white` 背景在 Mac 屏幕上显生硬
- **原因**：macOS 原生界面多用暖灰调
- **解决**：`LinearGradient(colors: [Color.gray.opacity(0.02), Color.gray.opacity(0.06)])`

---

## HotKeyRecorder

### 呼吸动画强度
- **现象**：呼吸动画从 1.0 → 0.4 透明度变化太明显
- **解决**：改为 1.0 → 0.7，更柔和

### 强调色不跟随用户设置
- **现象**：`Color.accentColor` 始终使用系统强调色，忽略用户自定义
- **原因**：`Color.accentColor` 不等于 `SettingsManager.shared.currentAccentColor`
- **解决**：用 `SettingsManager.shared.currentAccentColor` 替换 `Color.accentColor`

---

## List(.bordered)

### macOS 不可用 .insetGrouped
- **现象**：`.listStyle(.insetGrouped)` 编译报错 "unavailable in macOS"
- **原因**：`insetGrouped` 是 iOS/iPadOS 专有
- **解决**：macOS 13+ 使用 `.listStyle(.bordered)`，效果接近

---

## 通用

### 颜色选择器：选中态需要阴影 + 环
- 纯色圆点难以区分选中状态，加阴影 + 白色 stroke 环明显提升可识别性

### TypeRow hover 动效不宜过大
- `.scaleEffect(0.98)` + `.spring(duration: 0.2)` 太弹
- 改为 `.scaleEffect(0.99)` + `.easeInOut(duration: 0.15)` 更克制

---

## 设计前检查清单

> 每次新增 macOS 界面元素前，先过一遍：

- [ ] 这个组件在 macOS 上可用吗？
- [ ] 系统默认行为是否会导致界面/功能异常？
- [ ] HIG 上有没有对应的设计规范？
- [ ] 颜色/透明度在毛玻璃上效果如何？
- [ ] 动画强度是否克制？（macOS 原生偏轻柔）
- [ ] 这个交互在鼠标下是否自然？
