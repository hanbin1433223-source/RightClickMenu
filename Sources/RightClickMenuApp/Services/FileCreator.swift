import Foundation

enum FileCreator {
    static func create(_ ext: String) {
        let path = Bundle.main.path(forResource: "rclick", ofType: nil, inDirectory: "Resources")
            ?? "/Applications/即建.app/Contents/Resources/rclick"
        guard FileManager.default.fileExists(atPath: path) else { return }
        let task = Process()
        task.launchPath = path
        task.arguments = ["create", ext]
        try? task.run()
        task.waitUntilExit()
    }
}
