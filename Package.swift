// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyPress",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v10),
        .tvOS(.v10),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "SwiftyPress",
            targets: ["SwiftyPress"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:SwiftyBeaver/SwiftyBeaver.git", .branch("master")),
        .package(url: "git@github.com:Alamofire/Alamofire.git", from: "5.0.0-beta.7"),
        .package(url: "git@github.com:realm/realm-cocoa.git", .branch("master")),
        .package(url: "git@github.com:ZamzamInc/ZamzamUI.git", .branch("develop")),
        .package(url: "git@github.com:ZamzamInc/Stencil.git", .branch("lite")),
        .package(url: "git@github.com:onevcat/Kingfisher.git", .branch("xcode11"))
    ],
    targets: [
        .target(
            name: "SwiftyPress",
            dependencies: [
                "SwiftyBeaver",
                "Alamofire",
                "Realm",
                "RealmSwift",
                "Stencil",
                "ZamzamUI",
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
