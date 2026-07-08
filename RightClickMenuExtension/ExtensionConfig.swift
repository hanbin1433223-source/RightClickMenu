import Foundation

enum ExtensionConfig {
    static func enabledFileTypes() -> [FileType] {
        AppConfig.enabledFileTypes()
    }
}
