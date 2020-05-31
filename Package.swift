// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "SwiftyPress",
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
        .package(name: "Realm", url: "https://github.com/realm/realm-cocoa.git", .upToNextMinor(from: "4.4.1")),
        .package(url: "https://github.com/ZamzamInc/ZamzamKit.git", .upToNextMinor(from: "6.0.4")),
        .package(url: "https://github.com/ZamzamInc/Stencil.git", .upToNextMinor(from: "0.13.2")),
        .package(url: "https://github.com/kean/Nuke.git", .upToNextMinor(from: "9.0.0"))
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
            dependencies: ["SwiftyPress"]
        ),
        .testTarget(
            name: "SwiftyPressModelTests",
            dependencies: ["SwiftyPress"]
        )
    ]
)
