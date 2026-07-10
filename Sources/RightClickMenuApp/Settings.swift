import Foundation
import AppKit
import ServiceManagement
import SwiftUI

enum InteractionMode: String, Codable, CaseIterable {
    case hotkey = "快捷键优先"
    case menubar = "菜单栏优先"
    case both = "两种都要"

    var description: String {
        switch self {
        case .hotkey: return "按快捷键直接创建文件"
        case .menubar: return "点击菜单栏图标选择类型"
        case .both: return "两种方式都可以"
        }
    }

    var icon: String {
        switch self {
        case .hotkey: return "keyboard"
        case .menubar: return "menubar.dock.rectangle"
        case .both: return "checkmark.circle"
        }
    }
}

struct HotKeyConfig: Codable, Equatable {
    var keyCode: Int = 3
    var modifiers: Int = 0x1000

    var display: String {
        let mods = modifierStrings
        let key = keyStrings[keyCode] ?? "F\(keyCode)"
        return mods + key
    }

    private var modifierStrings: String {
        var result = ""
        if modifiers & 0x1000 != 0 { result += "⌃" }
        if modifiers & 0x0800 != 0 { result += "⌥" }
        if modifiers & 0x0200 != 0 { result += "⇧" }
        if modifiers & 0x0100 != 0 { result += "⌘" }
        return result
    }

    private static let presetList: [(String, Int, Int)] = [
        ("⌃F", 3, 0x1000),
        ("⌃N", 45, 0x1000),
        ("⌃B", 11, 0x1000),
        ("⌃D", 2, 0x1000),
        ("⌃T", 17, 0x1000),
        ("⌃G", 5, 0x1000),
        ("⌃E", 14, 0x1000),
        ("⌃R", 15, 0x1000),
        ("⌃Y", 16, 0x1000),
        ("⌃U", 32, 0x1000),
        ("⌃I", 34, 0x1000),
        ("⌃O", 31, 0x1000),
        ("⌃P", 35, 0x1000),
        ("⌃⌘F", 3, 0x1000 | 0x0100),
        ("⌃⌘N", 45, 0x1000 | 0x0100),
    ]

    static var presets: [(String, Int, Int)] { presetList }

    static func preset(at index: Int) -> (String, Int, Int) {
        presetList[index]
    }
}

private let keyStrings: [Int: String] = [
    0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G",
    6: "Z", 7: "X", 8: "C", 9: "V", 11: "B", 12: "Q",
    13: "W", 14: "E", 15: "R", 16: "Y", 17: "T",
    31: "O", 32: "U", 34: "I", 35: "P",
    45: "N", 46: "M",
]

struct AppSettings: Codable {
    var interactionMode: InteractionMode = .both
    var enabledTypeIDs: [String] = ["txt", "md", "rtf"]
    var hotKeyConfig: HotKeyConfig = .init()
    var quickCreateMode: Bool = false
    var defaultTypeID: String = "txt"
    var launchOnLogin: Bool = false
    var hasLaunchedBefore: Bool = false
    var accentColor: String = "indigo"
}

enum FileCategory: String, Codable, CaseIterable {
    case common = "常用文档"
    case office = "Office"
    case iwork = "iWork"
    case code = "代码文件"
    case other = "其他"

    var icon: String {
        switch self {
        case .common: return "doc.text"
        case .office: return "briefcase"
        case .iwork: return "pencil.and.outline"
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .other: return "ellipsis.circle"
        }
    }
}

struct FileTypeDef: Identifiable {
    let id: String
    let ext: String
    let label: String
    let symbol: String
    let category: FileCategory
    let appBundleID: String?
    let template: String

    init(ext: String, label: String, symbol: String, category: FileCategory, appBundleID: String? = nil, template: String = "") {
        self.id = ext
        self.ext = ext
        self.label = label
        self.symbol = symbol
        self.category = category
        self.appBundleID = appBundleID
        self.template = template
    }

    var isInstalled: Bool {
        guard let bundleID = appBundleID else { return true }
        return NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) != nil
    }
}

enum FileTypeManager {
    static let all: [FileTypeDef] = [
        .init(ext: "txt", label: "文本文档", symbol: "doc.text", category: .common),
        .init(ext: "md", label: "Markdown", symbol: "doc.richtext", category: .common),
        .init(ext: "rtf", label: "富文本文档", symbol: "doc.plaintext", category: .common, template: "{\\rtf1\\ansi\\deff0\n}\n"),
        .init(ext: "docx", label: "Word 文档", symbol: "doc.word", category: .office, appBundleID: "com.microsoft.Word"),
        .init(ext: "xlsx", label: "Excel 表格", symbol: "doc.grid", category: .office, appBundleID: "com.microsoft.Excel"),
        .init(ext: "pptx", label: "PowerPoint 演示文稿", symbol: "doc.chart", category: .office, appBundleID: "com.microsoft.PowerPoint"),
        .init(ext: "pages", label: "Pages 文稿", symbol: "doc.text", category: .iwork, appBundleID: "com.apple.iWork.Pages"),
        .init(ext: "numbers", label: "Numbers 表格", symbol: "doc.grid", category: .iwork, appBundleID: "com.apple.iWork.Numbers"),
        .init(ext: "key", label: "Keynote 演示", symbol: "doc.chart", category: .iwork, appBundleID: "com.apple.iWork.Keynote"),
        .init(ext: "html", label: "HTML", symbol: "chevron.left.forwardslash.chevron.right", category: .code, template: "<!DOCTYPE html>\n<html>\n<head><meta charset=\"utf-8\"><title></title></head>\n<body>\n\n</body>\n</html>\n"),
        .init(ext: "css", label: "CSS", symbol: "number", category: .code, template: "/* style */\n"),
        .init(ext: "js", label: "JavaScript", symbol: "curlybraces", category: .code, template: "// script\n"),
        .init(ext: "ts", label: "TypeScript", symbol: "curlybraces", category: .code, template: "// TypeScript\n"),
        .init(ext: "py", label: "Python", symbol: "terminal", category: .code, template: "#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\n\n\ndef main():\n    pass\n\n\nif __name__ == \"__main__\":\n    main()\n"),
        .init(ext: "swift", label: "Swift", symbol: "swift", category: .code, template: "import Foundation\n\n"),
        .init(ext: "json", label: "JSON", symbol: "ellipsis.curlybraces", category: .code, template: "{}\n"),
        .init(ext: "xml", label: "XML", symbol: "tag", category: .code, template: "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\n</root>\n"),
        .init(ext: "yaml", label: "YAML", symbol: "number", category: .code, template: "# YAML\n"),
        .init(ext: "sh", label: "Shell 脚本", symbol: "terminal", category: .code, template: "#!/bin/bash\n\n"),
        .init(ext: "csv", label: "CSV", symbol: "tablecells", category: .other),
        .init(ext: "plist", label: "Property List", symbol: "list.bullet", category: .other),
    ]

    static var commonIDs: [String] { ["txt", "md", "rtf"] }

    static func `default`(for id: String) -> FileTypeDef? {
        all.first { $0.id == id }
    }
}

@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    @Published var settings: AppSettings

    private let defaults = UserDefaults.standard
    private let key = "app_settings"

    private init() {
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        } else {
            settings = AppSettings()
        }
    }

    var enabledTypes: [FileTypeDef] {
        FileTypeManager.all.filter { settings.enabledTypeIDs.contains($0.id) }
    }

    var defaultType: FileTypeDef {
        FileTypeManager.all.first { $0.id == settings.defaultTypeID } ?? FileTypeManager.all[0]
    }

    func save() {
        if let data = try? JSONEncoder().encode(settings) {
            defaults.set(data, forKey: key)
        }
    }

    func toggleType(_ id: String) {
        if settings.enabledTypeIDs.contains(id) {
            settings.enabledTypeIDs.removeAll { $0 == id }
        } else {
            settings.enabledTypeIDs.append(id)
        }
        save()
    }

    func isEnabled(_ id: String) -> Bool {
        settings.enabledTypeIDs.contains(id)
    }

    func setDefaultType(_ id: String) {
        settings.defaultTypeID = id
        save()
    }

    func setQuickCreate(_ enabled: Bool) {
        settings.quickCreateMode = enabled
        save()
    }

    func setLaunchOnLogin(_ enabled: Bool) {
        settings.launchOnLogin = enabled
        save()
        if #available(macOS 14.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                NSLog("即建: SMAppService 错误 - \(error.localizedDescription)")
            }
        }
    }

    func setHotKey(_ config: HotKeyConfig) {
        settings.hotKeyConfig = config
        save()
        HotKeyManager.shared.unregister()
        HotKeyManager.shared.register()
    }

    func setAccentColor(_ color: String) {
        settings.accentColor = color
        save()
    }

    var currentAccentColor: Color {
        switch settings.accentColor {
        case "blue": return .blue
        case "purple": return .purple
        case "orange": return .orange
        case "green": return .green
        case "red": return .red
        default: return .indigo
        }
    }

    func completeOnboarding(mode: InteractionMode, typeIDs: [String]) {
        settings.interactionMode = mode
        settings.enabledTypeIDs = typeIDs
        settings.hasLaunchedBefore = true
        save()
    }
}
