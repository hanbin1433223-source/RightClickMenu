import Foundation

enum FileCreatorError: LocalizedError {
    case targetIsNotDirectory
    case templateCreationFailed

    var errorDescription: String? {
        switch self {
        case .targetIsNotDirectory: "目标位置不是文件夹。"
        case .templateCreationFailed: "模板文件创建失败。"
        }
    }
}

struct FileCreator {
    private let fileManager: FileManager
    private let templateManager: TemplateManager

    init(fileManager: FileManager = .default, templateManager: TemplateManager = TemplateManager()) {
        self.fileManager = fileManager
        self.templateManager = templateManager
    }

    @discardableResult
    func createFile(type fileType: FileType, in directoryURL: URL) throws -> URL {
        var isDirectory: ObjCBool = false
        guard fileManager.fileExists(atPath: directoryURL.path, isDirectory: &isDirectory), isDirectory.boolValue else {
            throw FileCreatorError.targetIsNotDirectory
        }

        let destinationURL = uniqueDestinationURL(for: fileType, in: directoryURL)
        try templateManager.writeTemplate(for: fileType, to: destinationURL)
        return destinationURL
    }

    private func uniqueDestinationURL(for fileType: FileType, in directoryURL: URL) -> URL {
        let baseName = fileType.baseFileName
        let fileExtension = fileType.fileExtension
        var candidate = directoryURL.appendingPathComponent(baseName).appendingPathExtension(fileExtension)

        guard fileManager.fileExists(atPath: candidate.path) else {
            return candidate
        }

        var index = 2
        repeat {
            candidate = directoryURL.appendingPathComponent("\(baseName) \(index)").appendingPathExtension(fileExtension)
            index += 1
        } while fileManager.fileExists(atPath: candidate.path)

        return candidate
    }
}
