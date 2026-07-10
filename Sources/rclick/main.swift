import Foundation

// 即建 - CLI 工具
// rclick create <ext>
// 创建文件并选中

let templates: [String: String] = [
    "txt": "",
    "md": "",
    "rtf": "{\\rtf1\\ansi\\deff0\n}\n",
    "docx": "",
    "xlsx": "",
    "pptx": "",
    "pages": "",
    "numbers": "",
    "key": "",
    "html": "<!DOCTYPE html>\n<html>\n<head><meta charset=\"utf-8\"><title></title></head>\n<body>\n\n</body>\n</html>\n",
    "css": "/* style */\n",
    "js": "// script\n",
    "ts": "// TypeScript\n",
    "py": "#!/usr/bin/env python3\n# -*- coding: utf-8 -*-\n\n\ndef main():\n    pass\n\n\nif __name__ == \"__main__\":\n    main()\n",
    "swift": "import Foundation\n\n",
    "json": "{}\n",
    "xml": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<root>\n\n</root>\n",
    "yaml": "# YAML\n",
    "sh": "#!/bin/bash\n\n",
    "csv": "",
    "plist": "",
]

func getDirectory() -> String? {
    let script = """
    tell application "Finder"
        if selection is {} then
            set targetFolder to (insertion location) as text
        else
            set sel to item 1 of (selection as list)
            if class of sel is folder then
                set targetFolder to sel as text
            else
                set targetFolder to (container of sel) as text
            end if
        end if
        set posixPath to POSIX path of targetFolder
        return posixPath
    end tell
    """
    var error: NSDictionary?
    guard let result = NSAppleScript(source: script)?.executeAndReturnError(&error) else {
        if let err = error {
            fputs("AppleScript error: \(err)\n", stderr)
        }
        return nil
    }
    return result.stringValue
}

func selectFile(_ path: String) {
    let script = """
    tell application "Finder"
        set filePath to "\(path)" as POSIX file
        select filePath
        activate
    end tell
    """
    NSAppleScript(source: script)?.executeAndReturnError(nil)
}

func createFile(at dir: String, ext: String) -> String? {
    let fm = FileManager.default
    let baseName = "新建文档"

    var fileName = "\(baseName).\(ext)"
    var counter = 1
    let url = URL(fileURLWithPath: dir)

    while fm.fileExists(atPath: url.appendingPathComponent(fileName).path) {
        counter += 1
        fileName = "\(baseName) \(counter).\(ext)"
    }

    let fileURL = url.appendingPathComponent(fileName)
    let template = templates[ext] ?? ""

    if template.isEmpty && ext != "txt" {
        // 创建空文件
        fm.createFile(atPath: fileURL.path, contents: Data())
    } else {
        fm.createFile(atPath: fileURL.path, contents: template.data(using: .utf8))
    }

    return fileURL.path
}

// MARK: - Main

let args = CommandLine.arguments
guard args.count >= 3, args[1] == "create" else {
    print("Usage: rclick create <ext>")
    exit(1)
}

let ext = args[2]
guard templates.keys.contains(ext) else {
    fputs("Unknown type: \(ext)\n", stderr)
    exit(1)
}

guard let dir = getDirectory() else {
    fputs("Failed to get Finder path\n", stderr)
    exit(1)
}

guard let path = createFile(at: dir, ext: ext) else {
    fputs("Failed to create file\n", stderr)
    exit(1)
}

selectFile(path)
