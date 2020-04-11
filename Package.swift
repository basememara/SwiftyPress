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
        .package(name: "Realm", url: "git@github.com:realm/realm-cocoa.git", .upToNextMinor(from: "4.4.0")),
        .package(url: "git@github.com:ZamzamInc/ZamzamKit.git", .upToNextMinor(from: "5.3.3")),
        .package(url: "git@github.com:ZamzamInc/Stencil.git", .upToNextMinor(from: "0.13.2")),
        .package(url: "git@github.com:onevcat/Kingfisher.git", .upToNextMinor(from: "5.13.4"))
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
                "Kingfisher"
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
