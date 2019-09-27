// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyPress",
    platforms: [
        .macOS(.v10_12),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(
            name: "SwiftyPress",
            targets: ["SwiftyPress"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "1.7.0")),
        .package(url: "git@github.com:Alamofire/Alamofire.git", from: "5.0.0-rc.2"),
        .package(url: "git@github.com:realm/realm-cocoa.git", .upToNextMajor(from: "3.18.0")),
        .package(url: "git@github.com:ZamzamInc/ZamzamNotification.git", .branch("master")),
        .package(url: "git@github.com:ZamzamInc/ZamzamUI.git", .branch("develop")),
        .package(url: "git@github.com:ZamzamInc/Stencil.git", .branch("lite")),
        .package(url: "git@github.com:onevcat/Kingfisher.git", .upToNextMajor(from: "5.8.1"))
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
                "ZamzamNotification",
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
