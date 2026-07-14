import SwiftUI

@main
struct RightClickMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup("即建") {
            SettingsView()
        }
        .windowResizability(.contentSize)
    }
}
