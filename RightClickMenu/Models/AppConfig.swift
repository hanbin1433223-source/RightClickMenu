import Foundation

final class AppConfig: ObservableObject {
    static let appGroupIdentifier = "group.com.rightclickmenu"
    static let shared = AppConfig()

    private static let enabledFileTypesKey = "enabledFileTypes"
    private let defaults: UserDefaults

    @Published private(set) var enabledFileTypeIDs: Set<String>

    init(defaults: UserDefaults? = UserDefaults(suiteName: appGroupIdentifier)) {
        self.defaults = defaults ?? .standard
        let saved = self.defaults.stringArray(forKey: Self.enabledFileTypesKey)
        self.enabledFileTypeIDs = Set(saved ?? FileType.allCases.map(\.rawValue))
    }

    func isEnabled(_ fileType: FileType) -> Bool {
        enabledFileTypeIDs.contains(fileType.rawValue)
    }

    func setEnabled(_ isEnabled: Bool, for fileType: FileType) {
        if isEnabled {
            enabledFileTypeIDs.insert(fileType.rawValue)
        } else {
            enabledFileTypeIDs.remove(fileType.rawValue)
        }

        defaults.set(Array(enabledFileTypeIDs).sorted(), forKey: Self.enabledFileTypesKey)
    }

    static func enabledFileTypes(defaults: UserDefaults? = UserDefaults(suiteName: appGroupIdentifier)) -> [FileType] {
        let defaults = defaults ?? .standard
        guard let saved = defaults.stringArray(forKey: enabledFileTypesKey) else {
            return FileType.allCases
        }

        let enabledIDs = Set(saved)
        return FileType.allCases.filter { enabledIDs.contains($0.rawValue) }
    }
}
