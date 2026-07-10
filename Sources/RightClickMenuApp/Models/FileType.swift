import AppKit

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

}
