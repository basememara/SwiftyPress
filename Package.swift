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
        .package(name: "Realm", url: "git@github.com:realm/realm-cocoa.git", .branch("master")),
        .package(url: "git@github.com:ZamzamInc/ZamzamKit.git", .branch("master")),
        .package(url: "git@github.com:ZamzamInc/Stencil.git", .branch("lite")),
        .package(url: "git@github.com:onevcat/Kingfisher.git", .branch("master"))
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
