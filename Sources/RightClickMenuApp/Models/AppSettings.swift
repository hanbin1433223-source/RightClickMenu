import Foundation

private let keyStrings: [Int: String] = [
    0: "A", 1: "S", 2: "D", 3: "F", 4: "H", 5: "G",
    6: "Z", 7: "X", 8: "C", 9: "V", 11: "B", 12: "Q",
    13: "W", 14: "E", 15: "R", 16: "Y", 17: "T",
    31: "O", 32: "U", 34: "I", 35: "P",
    45: "N", 46: "M",
]

struct HotKeyConfig: Codable, Equatable {
    var keyCode: Int = 3
    var modifiers: Int = 0x1000

    var display: String {
        let mods = modifierStrings
        let key = keyStrings[keyCode] ?? "F\(keyCode)"
        return mods + key
    }

    private var modifierStrings: String {
        var result = ""
        if modifiers & 0x1000 != 0 { result += "⌃" }
        if modifiers & 0x0800 != 0 { result += "⌥" }
        if modifiers & 0x0200 != 0 { result += "⇧" }
        if modifiers & 0x0100 != 0 { result += "⌘" }
        return result
    }


}

struct AppSettings: Codable {
    var enabledTypeIDs: [String] = ["txt", "md", "rtf"]
    var hotKeyConfig: HotKeyConfig = .init()
    var quickCreateMode: Bool = false
    var defaultTypeID: String = "txt"
    var launchOnLogin: Bool = false
    var hasLaunchedBefore: Bool = false
    var accentColor: String = "indigo"
}
