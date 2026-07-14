import Foundation
import ServiceManagement
import SwiftUI

extension Notification.Name {
    static let hotKeyConfigChanged = Notification.Name("hotKeyConfigChanged")
}

@MainActor
final class SettingsManager: ObservableObject {
    static let shared = SettingsManager()
    @Published var settings: AppSettings

    private let defaults = UserDefaults.standard
    private let key = "app_settings"

    private init() {
        if let data = defaults.data(forKey: key),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        } else {
            settings = AppSettings()
        }
    }

    var enabledTypes: [FileTypeDef] {
        FileTypeManager.all.filter { settings.enabledTypeIDs.contains($0.id) }
    }

    func save() {
        if let data = try? JSONEncoder().encode(settings) {
            defaults.set(data, forKey: key)
        }
    }

    func toggleType(_ id: String) {
        if settings.enabledTypeIDs.contains(id) {
            settings.enabledTypeIDs.removeAll { $0 == id }
        } else {
            settings.enabledTypeIDs.append(id)
        }
        save()
    }

    func isEnabled(_ id: String) -> Bool {
        settings.enabledTypeIDs.contains(id)
    }

    func setDefaultType(_ id: String) {
        settings.defaultTypeID = id
        save()
    }

    func setQuickCreate(_ enabled: Bool) {
        settings.quickCreateMode = enabled
        save()
    }

    func setLaunchOnLogin(_ enabled: Bool) {
        settings.launchOnLogin = enabled
        save()
        if #available(macOS 14.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                NSLog("即建: SMAppService 错误 - \(error.localizedDescription)")
            }
        }
    }

    func setHotKey(_ config: HotKeyConfig) {
        settings.hotKeyConfig = config
        save()
        NotificationCenter.default.post(name: .hotKeyConfigChanged, object: nil)
    }

    func setAccentColor(_ color: String) {
        settings.accentColor = color
        save()
    }

    var currentAccentColor: Color {
        switch settings.accentColor {
        case "blue": return .blue
        case "purple": return .purple
        case "orange": return .orange
        case "green": return .green
        case "red": return .red
        default: return .indigo
        }
    }

    func completeOnboarding(typeIDs: [String]) {
        settings.enabledTypeIDs = typeIDs
        settings.hasLaunchedBefore = true
        save()
    }
}
