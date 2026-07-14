import AppKit
import SwiftUI

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

    init(ext: String, label: String, symbol: String, category: FileCategory, appBundleID: String? = nil) {
        self.id = ext
        self.ext = ext
        self.label = label
        self.symbol = symbol
        self.category = category
        self.appBundleID = appBundleID
    }

    var isInstalled: Bool {
        guard let bundleID = appBundleID else { return true }
        return NSWorkspace.shared.urlForApplication(withBundleIdentifier: bundleID) != nil
    }

    var badgeText: String {
        switch ext {
        case "txt": return "TXT"
        case "md": return "MD"
        case "rtf": return "RTF"
        case "docx": return "W"
        case "xlsx": return "X"
        case "pptx": return "P"
        case "pages": return "Pg"
        case "numbers": return "N"
        case "key": return "K"
        case "html": return "5"
        case "css": return "3"
        case "js": return "JS"
        case "ts": return "TS"
        case "py": return "Py"
        case "swift": return "Sw"
        case "json": return "{ }"
        case "xml": return "</>"
        case "yaml": return "Y"
        case "sh": return "$_"
        case "csv": return "CSV"
        case "plist": return "PL"
        default: return ext.uppercased()
        }
    }

    var brandColor: Color {
        switch ext {
        case "txt", "md", "rtf": return Color(red: 0.35, green: 0.78, blue: 0.98)
        case "docx": return Color(red: 0.17, green: 0.34, blue: 0.60)
        case "xlsx": return Color(red: 0.13, green: 0.45, blue: 0.27)
        case "pptx": return Color(red: 0.82, green: 0.28, blue: 0.15)
        case "pages": return Color(red: 1.0, green: 0.42, blue: 0.21)
        case "numbers": return Color(red: 0.11, green: 0.73, blue: 0.33)
        case "key": return Color(red: 0.0, green: 0.44, blue: 0.79)
        case "html": return Color(red: 0.89, green: 0.30, blue: 0.15)
        case "css": return Color(red: 0.08, green: 0.45, blue: 0.71)
        case "js": return Color(red: 0.97, green: 0.87, blue: 0.12)
        case "ts": return Color(red: 0.19, green: 0.47, blue: 0.78)
        case "py": return Color(red: 0.22, green: 0.46, blue: 0.67)
        case "swift": return Color(red: 0.94, green: 0.32, blue: 0.22)
        case "sh": return Color(red: 0.31, green: 0.36, blue: 0.42)
        case "json", "xml", "yaml", "csv", "plist": return Color(red: 0.42, green: 0.45, blue: 0.50)
        default: return .gray
        }
    }
}

enum FileTypeManager {
    static let all: [FileTypeDef] = [
        .init(ext: "txt", label: "文本文档", symbol: "doc.text", category: .common),
        .init(ext: "md", label: "Markdown", symbol: "doc.richtext", category: .common),
        .init(ext: "rtf", label: "富文本文档", symbol: "doc.plaintext", category: .common),
        .init(ext: "docx", label: "Word 文档", symbol: "doc.word", category: .office, appBundleID: "com.microsoft.Word"),
        .init(ext: "xlsx", label: "Excel 表格", symbol: "doc.grid", category: .office, appBundleID: "com.microsoft.Excel"),
        .init(ext: "pptx", label: "PowerPoint 演示文稿", symbol: "doc.chart", category: .office, appBundleID: "com.microsoft.PowerPoint"),
        .init(ext: "pages", label: "Pages 文稿", symbol: "doc.text", category: .iwork, appBundleID: "com.apple.iWork.Pages"),
        .init(ext: "numbers", label: "Numbers 表格", symbol: "doc.grid", category: .iwork, appBundleID: "com.apple.iWork.Numbers"),
        .init(ext: "key", label: "Keynote 演示", symbol: "doc.chart", category: .iwork, appBundleID: "com.apple.iWork.Keynote"),
        .init(ext: "html", label: "HTML", symbol: "chevron.left.forwardslash.chevron.right", category: .code),
        .init(ext: "css", label: "CSS", symbol: "number", category: .code),
        .init(ext: "js", label: "JavaScript", symbol: "curlybraces", category: .code),
        .init(ext: "ts", label: "TypeScript", symbol: "curlybraces", category: .code),
        .init(ext: "py", label: "Python", symbol: "terminal", category: .code),
        .init(ext: "swift", label: "Swift", symbol: "swift", category: .code),
        .init(ext: "json", label: "JSON", symbol: "ellipsis.curlybraces", category: .code),
        .init(ext: "xml", label: "XML", symbol: "tag", category: .code),
        .init(ext: "yaml", label: "YAML", symbol: "number", category: .code),
        .init(ext: "sh", label: "Shell 脚本", symbol: "terminal", category: .code),
        .init(ext: "csv", label: "CSV", symbol: "tablecells", category: .other),
        .init(ext: "plist", label: "Property List", symbol: "list.bullet", category: .other),
    ]

}
