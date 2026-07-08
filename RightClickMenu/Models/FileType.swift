import Foundation

enum FileKind: String, CaseIterable, Codable {
    case plainText
    case markdown
    case richText
    case word
    case excel
    case powerpoint
}

enum FileType: String, CaseIterable, Codable, Identifiable {
    case text
    case markdown
    case richText
    case word
    case excel
    case powerpoint

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .text: "TXT"
        case .markdown: "MD"
        case .richText: "RTF"
        case .word: "DOCX"
        case .excel: "XLSX"
        case .powerpoint: "PPTX"
        }
    }

    var menuTitle: String {
        switch self {
        case .text: "新建文本文档"
        case .markdown: "新建 Markdown"
        case .richText: "新建富文本文档"
        case .word: "新建 Word 文档"
        case .excel: "新建 Excel 表格"
        case .powerpoint: "新建 PowerPoint 演示文稿"
        }
    }

    var baseFileName: String {
        switch self {
        case .text: "新建文本文档"
        case .markdown: "新建 Markdown"
        case .richText: "新建富文本文档"
        case .word: "新建 Word 文档"
        case .excel: "新建 Excel 表格"
        case .powerpoint: "新建 PowerPoint 演示文稿"
        }
    }

    var fileExtension: String {
        switch self {
        case .text: "txt"
        case .markdown: "md"
        case .richText: "rtf"
        case .word: "docx"
        case .excel: "xlsx"
        case .powerpoint: "pptx"
        }
    }

    var kind: FileKind {
        switch self {
        case .text: .plainText
        case .markdown: .markdown
        case .richText: .richText
        case .word: .word
        case .excel: .excel
        case .powerpoint: .powerpoint
        }
    }
}
