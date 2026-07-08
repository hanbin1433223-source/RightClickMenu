import SwiftUI
import AppKit
import Carbon

@MainActor
final class HotKeyManager: @unchecked Sendable {
    static let shared = HotKeyManager()
    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?

    private init() {}

    func register() {
        let keyCode: UInt32 = 45
        let mods: UInt32 = UInt32(cmdKey) | UInt32(optionKey)

        let sig = "JIJN".utf8.reduce(OSType(0)) { ($0 << 8) | OSType($1) }
        let id = EventHotKeyID(signature: sig, id: 1)
        var ref: EventHotKeyRef?
        RegisterEventHotKey(keyCode, mods, id, GetEventMonitorTarget(), 0, &ref)
        hotKeyRef = ref

        var eventType = EventTypeSpec(eventClass: OSType(kEventClassKeyboard), eventKind: UInt32(kEventHotKeyPressed))
        InstallEventHandler(GetEventMonitorTarget(), { _, event, _ -> OSStatus in
            var hkID = EventHotKeyID()
            GetEventParameter(event, EventParamName(kEventParamDirectObject), EventParamType(typeEventHotKeyID), nil, MemoryLayout<EventHotKeyID>.size, nil, &hkID)
            if hkID.id == 1 {
                Task { @MainActor in AppDelegate.shared?.showFilePicker() }
            }
            return noErr
        }, 1, &eventType, nil, &eventHandler)
    }

    func unregister() {
        if let ref = hotKeyRef { UnregisterEventHotKey(ref) }
        if let ref = eventHandler { RemoveEventHandler(ref) }
    }
}

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    static weak var shared: AppDelegate?

    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.shared = self
        HotKeyManager.shared.register()
    }

    func applicationWillTerminate(_ notification: Notification) {
        HotKeyManager.shared.unregister()
    }

    func showFilePicker() {
        let alert = NSAlert()
        alert.messageText = "新建文件"
        alert.informativeText = "选择要创建的文件类型"

        let types = ["txt", "md", "rtf", "docx", "xlsx", "pptx"]
        let labels = ["文本文档", "Markdown", "富文本文档", "Word 文档", "Excel 表格", "PowerPoint 演示文稿"]

        for label in labels {
            alert.addButton(withTitle: label)
        }

        alert.addButton(withTitle: "取消")

        let response = alert.runModal()
        let firstButton = NSApplication.ModalResponse.alertFirstButtonReturn.rawValue
        let idx = Int(response.rawValue - firstButton)
        if idx >= 0, idx < types.count {
            runRclick(types[idx])
        }
    }

    private func runRclick(_ arg: String) {
        let path = Bundle.main.path(forResource: "rclick", ofType: nil, inDirectory: "Resources")
            ?? "/Applications/即建.app/Contents/Resources/rclick"
        guard FileManager.default.fileExists(atPath: path) else { return }
        let task = Process()
        task.launchPath = path
        task.arguments = ["create", arg]
        try? task.run()
        task.waitUntilExit()
    }
}

@main
struct RightClickMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup("即建") {
            ContentView()
        }

        MenuBarExtra {
            Button("新建文本文档") { runRclick("txt") }
            Button("新建 Markdown") { runRclick("md") }
            Button("新建富文本文档") { runRclick("rtf") }
            Button("新建 Word 文档") { runRclick("docx") }
            Button("新建 Excel 表格") { runRclick("xlsx") }
            Button("新建 PowerPoint 演示文稿") { runRclick("pptx") }

            Divider()

            Button("打开设置") {
                NSApp.activate(ignoringOtherApps: true)
                if let window = NSApp.windows.first(where: { $0.isVisible }) {
                    window.makeKeyAndOrderFront(nil)
                }
            }

            Button("退出") { NSApp.terminate(nil) }
        } label: {
            Label("即建", systemImage: "doc.badge.plus")
        }
    }

    private func runRclick(_ arg: String) {
        let path = Bundle.main.path(forResource: "rclick", ofType: nil, inDirectory: "Resources")
            ?? "/Applications/即建.app/Contents/Resources/rclick"
        guard FileManager.default.fileExists(atPath: path) else {
            NSLog("即建: 找不到 rclick")
            return
        }
        let task = Process()
        task.launchPath = path
        task.arguments = ["create", arg]
        try? task.run()
        task.waitUntilExit()
    }
}
