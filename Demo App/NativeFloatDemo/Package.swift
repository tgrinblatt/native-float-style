// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "NativeFloatDemo",
    platforms: [.macOS(.v26)],
    targets: [
        .executableTarget(
            name: "NativeFloatDemo",
            path: "Sources/NativeFloatDemo",
            exclude: ["Info.plist"],
            linkerSettings: [
                .unsafeFlags([
                    "-Xlinker", "-sectcreate",
                    "-Xlinker", "__TEXT",
                    "-Xlinker", "__info_plist",
                    "-Xlinker", "Sources/NativeFloatDemo/Info.plist"
                ])
            ]
        )
    ]
)
