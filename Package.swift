// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "RightClickMenu",
    platforms: [.macOS(.v14)],
    targets: [
        .executableTarget(
            name: "RightClickMenuApp",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("SwiftUI"),
                .linkedFramework("ServiceManagement"),
            ]
        ),
        .executableTarget(
            name: "rclick",
            dependencies: [],
            linkerSettings: [
                .linkedFramework("AppKit"),
            ]
        ),
    ]
)
