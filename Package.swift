// swift-tools-version:5.1

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
        .library(
            name: "SwiftyPress",
            targets: ["SwiftyPress"]
        )
    ],
    dependencies: [
        .package(url: "git@github.com:SwiftyBeaver/SwiftyBeaver.git", .upToNextMajor(from: "1.7.0")),
        .package(url: "git@github.com:Alamofire/Alamofire.git", from: "5.0.0-rc.2"),
        .package(url: "git@github.com:realm/realm-cocoa.git", .upToNextMajor(from: "3.18.0")),
        .package(url: "git@github.com:ZamzamInc/ZamzamKit.git", .upToNextMajor(from: "5.1.0")),
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
                "ZamzamCore",
                "ZamzamNotification",
                "ZamzamUI",
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
