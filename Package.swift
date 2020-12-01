// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "SwiftyPress",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v10_14),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v4)
    ],
    products: [
        .library(name: "SwiftyPress", type: .dynamic, targets: ["SwiftyPress"])
    ],
    dependencies: [
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", .exact("5.3.4")),
        .package(url: "https://github.com/ZamzamInc/ZamzamKit.git", .exact("7.0.0-beta.1")),
        .package(url: "https://github.com/ZamzamInc/Stencil.git", .exact("0.13.2")),
        .package(url: "https://github.com/kean/Nuke.git", .exact("9.1.1"))
    ],
    targets: [
        .target(
            name: "SwiftyPress",
            dependencies: [
                "Realm",
                .product(name: "RealmSwift", package: "Realm"),
                .product(name: "ZamzamCore", package: "ZamzamKit"),
                .product(name: "ZamzamNotification", package: "ZamzamKit"),
                .product(name: "ZamzamUI", package: "ZamzamKit"),
                "Stencil",
                "Nuke"
            ]
        ),
        .testTarget(
            name: "SwiftyPressTests",
            dependencies: ["SwiftyPress"],
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SwiftyPressModelTests",
            dependencies: ["SwiftyPress"],
            resources: [.process("Resources")]
        )
    ]
)
