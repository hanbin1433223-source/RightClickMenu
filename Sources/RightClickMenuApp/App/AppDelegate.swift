import SwiftUI
import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    static weak var shared: AppDelegate?
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var settingsWindow: NSWindow?
    private var quickPanel: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        Self.shared = self
        setupStatusItem()
        setupPopover()
        HotKeyManager.shared.register()
        if !SettingsManager.shared.settings.hasLaunchedBefore {
            showOnboarding()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        HotKeyManager.shared.unregister()
    }

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: "即建")
            button.image?.isTemplate = true
            button.action = #selector(togglePopover)
            button.target = self
        }
    }

    private func setupPopover() {
        popover = NSPopover()
        popover.contentSize = NSSize(width: 260, height: 400)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: PopoverView())
    }

    func showSettings() {
        if let win = settingsWindow {
            win.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
            return
        }
        let vc = NSHostingController(rootView: SettingsView())
        let win = NSWindow(contentViewController: vc)
        win.title = "即建"
        win.styleMask = [.titled, .closable, .miniaturizable, .fullSizeContentView]
        win.setContentSize(NSSize(width: 480, height: 520))
        win.minSize = NSSize(width: 460, height: 400)
        win.center()
        win.delegate = self
        settingsWindow = win
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    func closePopover() {
        popover?.performClose(nil)
    }

    func handleHotKey() {
        let s = SettingsManager.shared.settings
        closeQuickPanel()
        if s.quickCreateMode {
            closePopover()
            FileCreator.create(s.defaultTypeID)
        } else {
            showQuickPanel()
        }
    }

    func showQuickPanel() {
        if let panel = quickPanel {
            panel.makeKeyAndOrderFront(nil)
            return
        }
        let vc = NSHostingController(rootView: QuickPanelView())
        let panel = NSPanel(contentViewController: vc)
        panel.title = "即建"
        panel.styleMask = [.titled, .closable, .fullSizeContentView, .nonactivatingPanel]
        panel.isMovableByWindowBackground = true
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.hidesOnDeactivate = false
        panel.setContentSize(NSSize(width: 280, height: 380))
        panel.center()
        panel.delegate = self
        quickPanel = panel
        panel.makeKeyAndOrderFront(nil)
    }

    func closeQuickPanel() {
        quickPanel?.close()
        quickPanel = nil
    }

    func showOnboarding() {
        let vc = NSHostingController(rootView: OnboardingView())
        let win = NSWindow(contentViewController: vc)
        win.title = "欢迎使用即建"
        win.styleMask = [.titled, .closable, .fullSizeContentView]
        win.isMovableByWindowBackground = true
        win.center()
        NSApp.activate(ignoringOtherApps: true)
        win.makeKeyAndOrderFront(nil)
        win.delegate = self
    }
}

extension AppDelegate: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        guard let win = notification.object as? NSWindow else { return }
        if win == settingsWindow { settingsWindow = nil }
        if win == quickPanel { quickPanel = nil }
        if !SettingsManager.shared.settings.hasLaunchedBefore {
            NSApp.terminate(nil)
        }
    }
}
