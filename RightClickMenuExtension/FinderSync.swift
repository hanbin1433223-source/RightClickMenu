import Cocoa
import FinderSync

final class FinderSync: FIFinderSync {
    private let fileCreator = FileCreator()

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = monitoredDirectoryURLs()
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        let menu = NSMenu(title: "即建")
        let rootItem = NSMenuItem(title: "即建", action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: "即建")

        for fileType in ExtensionConfig.enabledFileTypes() {
            let item = NSMenuItem(title: fileType.menuTitle, action: #selector(createFile(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = fileType.rawValue
            submenu.addItem(item)
        }

        if submenu.items.isEmpty {
            let item = NSMenuItem(title: "没有启用的文件类型", action: nil, keyEquivalent: "")
            item.isEnabled = false
            submenu.addItem(item)
        }

        rootItem.submenu = submenu
        menu.addItem(rootItem)
        return menu
    }

    @objc private func createFile(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let fileType = FileType(rawValue: rawValue),
              let directoryURL = targetDirectoryURL() else {
            return
        }

        do {
            _ = try fileCreator.createFile(type: fileType, in: directoryURL)
        } catch {
            NSLog("即建创建文件失败: %@", error.localizedDescription)
        }
    }

    private func targetDirectoryURL() -> URL? {
        let controller = FIFinderSyncController.default()

        if let selectedURL = controller.selectedItemURLs()?.first {
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: selectedURL.path, isDirectory: &isDirectory), isDirectory.boolValue {
                return selectedURL
            }

            return selectedURL.deletingLastPathComponent()
        }

        return controller.targetedURL()
    }

    private func monitoredDirectoryURLs() -> Set<URL> {
        let homeURL = FileManager.default.homeDirectoryForCurrentUser
        return [homeURL]
    }
}
