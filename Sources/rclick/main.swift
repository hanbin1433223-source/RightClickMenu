import Foundation
import AppKit

func printUsage() {
    print("""
用法: rclick create <type>
       rclick list
       rclick --help

命令:
  create 在 Finder 当前目录创建文件
  list   列出所有可用类型
""")
}

func getFrontFinderPath() -> String? {
    let task = Process()
    task.launchPath = "/usr/bin/osascript"
    task.arguments = ["-e", """
    tell application "Finder"
        if (count of Finder windows) > 0 then
            return POSIX path of (target of front Finder window as alias)
        end if
    end tell
    return (POSIX path of (path to desktop folder))
    """]
    let pipe = Pipe()
    task.standardOutput = pipe
    try? task.run()
    task.waitUntilExit()
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
}

func createFile(ext: String, at dirPath: String) {
    let fileName: String
    let content: Data

    switch ext {
    case "txt":
        fileName = "新建文本文档.txt"
        content = Data()
    case "md":
        fileName = "新建 Markdown.md"
        content = Data()
    case "rtf":
        fileName = "新建富文本文档.rtf"
        content = Data("{\\rtf1\\ansi\\deff0\n}\n".utf8)
    case "docx":
        fileName = "新建 Word 文档.docx"
        content = Data()
    case "xlsx":
        fileName = "新建 Excel 表格.xlsx"
        content = Data()
    case "pptx":
        fileName = "新建 PowerPoint 演示文稿.pptx"
        content = Data()
    default:
        print("不支持的类型: \(ext)")
        exit(1)
    }

    let dirURL = URL(fileURLWithPath: dirPath, isDirectory: true)
    var fileURL = dirURL.appendingPathComponent(fileName)
    var index = 2
    while FileManager.default.fileExists(atPath: fileURL.path) {
        let base = (fileName as NSString).deletingPathExtension
        let ext = (fileName as NSString).pathExtension
        fileURL = dirURL.appendingPathComponent("\(base) \(index).\(ext)")
        index += 1
    }

    do {
        try content.write(to: fileURL, options: .atomic)
        print("✅ \(fileURL.lastPathComponent)")
        NSWorkspace.shared.activateFileViewerSelecting([fileURL])
    } catch {
        print("❌ \(error.localizedDescription)")
        exit(1)
    }
}

let args = CommandLine.arguments
if args.count < 2 || args.contains("--help") || args.contains("-h") {
    printUsage()
    exit(0)
}

switch args[1] {
case "create":
    guard args.count >= 3 else {
        print("错误: 缺少文件类型\n")
        printUsage()
        exit(1)
    }
    let targetDir = getFrontFinderPath() ?? NSHomeDirectory() + "/Desktop"
    createFile(ext: args[2], at: targetDir)

case "list":
    for ext in ["txt", "md", "rtf", "docx", "xlsx", "pptx"] {
        print(ext)
    }

default:
    print("未知命令: \(args[1])\n")
    printUsage()
    exit(1)
}
