//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-09-16.
//

import Foundation

let jsonString: String = """
    {
        "posts": [
            {
                "id": 41276,
                "title": "Swifty Protocol-Oriented Dependency Injection",
                "slug": "swift-protocol-oriented-dependency-injection",
                "type": "post",
                "excerpt": "The key to dependency injection is protocols. From there sprouts many variations, flavours, and techniques. Although this is yet another dependency injection™ blog post, I would like to share a pure Swift, battle-tested DI implementation with no outside dependencies or magic. It combines protocol extension and type erasure to give you a solid, flexible dependency injection.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/swift-protocol-oriented-dependency-injection/",
                "comment_count": 10,
                "author": 2,
                "featured_media": 41287,
                "terms": [
                    80,
                    62,
                    50,
                    55
                ],
                "meta": {
                    "_series_part": "2"
                },
                "created": "2018-04-11T21:34:11",
                "modified": "2019-05-13T11:44:11"
            },
            {
                "id": 41373,
                "title": "Protocol-Oriented Themes for iOS Apps",
                "slug": "protocol-oriented-themes-for-ios-apps",
                "type": "post",
                "excerpt": "Themes are usually downplayed as an after-thought instead of being an integral part of the development process. How many times have you inherited a codebase where the design team wants to tweak it, or business wants you to clone the app with a whole different theme. In this post, I'm going to show you the native way of theming an iOS app as intended by Apple that is often overlooked.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/protocol-oriented-themes-for-ios-apps/",
                "comment_count": 2,
                "author": 2,
                "featured_media": 41397,
                "terms": [
                    80,
                    53,
                    62,
                    55,
                    81
                ],
                "meta": {
                    "_series_part": "7"
                },
                "created": "2018-09-29T17:12:15",
                "modified": "2019-03-18T02:25:53"
            },
            {
                "id": 20633,
                "title": "Swifty Localization with Xcode Support",
                "slug": "swifty-localization-xcode-support",
                "type": "post",
                "excerpt": "Localization in Xcode is handled with NSLocalizedString, but it is such a verbose and legacy-like API. There's a Swiftier way that still respects Xcode .xliff exports and comments.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/swifty-localization-xcode-support/",
                "comment_count": 4,
                "author": 2,
                "featured_media": 20745,
                "terms": [
                    80,
                    77,
                    50,
                    55,
                    47
                ],
                "meta": {
                    "_series_part": "4"
                },
                "created": "2017-07-11T19:00:59",
                "modified": "2019-01-17T14:48:00"
            },
            {
                "id": 41256,
                "title": "Thin AppDelegate with Pluggable Services",
                "slug": "pluggable-appdelegate-services",
                "type": "post",
                "excerpt": "Many techniques have been tried to tame the AppDelegate beast, usually ending up in moving code into private functions or extensions. However, the AppDelegate is much more complex than just moving code around. In this post, let's examine a pluggable service technique with a few bonuses at the end.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/pluggable-appdelegate-services/",
                "comment_count": 0,
                "author": 2,
                "featured_media": 41258,
                "terms": [
                    56,
                    80,
                    53,
                    50,
                    55
                ],
                "meta": {
                    "_series_part": "8"
                },
                "created": "2018-02-16T18:24:43",
                "modified": "2019-01-05T05:31:57"
            },
            {
                "id": 652,
                "title": "Creating Cross-Platform Swift Frameworks for iOS, watchOS, and tvOS via Carthage and CocoaPods",
                "slug": "creating-cross-platform-swift-frameworks-ios-watchos-tvos-via-carthage-cocoapods",
                "type": "post",
                "excerpt": "In this post, I'd like to show you how to create a Swift framework for iOS, watchOS, and tvOS and get them distributed via Carthage and CocoaPods. It's a technique I use to share frameworks across all my apps and with the community.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/creating-cross-platform-swift-frameworks-ios-watchos-tvos-via-carthage-cocoapods/",
                "comment_count": 22,
                "author": 2,
                "featured_media": 675,
                "terms": [
                    80,
                    61,
                    52,
                    64,
                    50,
                    55,
                    47
                ],
                "meta": {
                    "_series_part": "6"
                },
                "created": "2016-03-22T17:32:30",
                "modified": "2019-01-05T03:50:02"
            },
            {
                "id": 1714,
                "title": "Full Stack iOS and WordPress in Swift",
                "slug": "full-stack-ios-and-wordpress-in-swift",
                "type": "post",
                "excerpt": "",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/full-stack-ios-and-wordpress-in-swift/",
                "comment_count": 11,
                "author": 2,
                "featured_media": 1739,
                "terms": [
                    53,
                    50,
                    55,
                    72
                ],
                "meta": {
                    "_series_part": ""
                },
                "created": "2017-01-25T19:54:17",
                "modified": "2018-10-21T03:47:58"
            },
            {
                "id": 26200,
                "title": "Protocol-Oriented Routing in Swift",
                "slug": "protocol-oriented-router-in-swift",
                "type": "post",
                "excerpt": "There are hundreds of complex routing frameworks and libraries in iOS. Usually they're overly complex to retrofit into an existing app or they completely bypass Storyboards. In this post, I'd like to offer a simple, native-like routing mechanism that leverages Storyboards like a boss to handle navigation.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/protocol-oriented-router-in-swift/",
                "comment_count": 8,
                "author": 2,
                "featured_media": 26240,
                "terms": [
                    80,
                    62,
                    78,
                    50,
                    55
                ],
                "meta": {
                    "_series_part": "3"
                },
                "created": "2017-10-01T11:00:54",
                "modified": "2018-10-13T03:37:33"
            },
            {
                "id": 5568,
                "title": "Delegates to Swift Closure Pattern",
                "slug": "swift-delegates-closure-pattern",
                "type": "post",
                "excerpt": "Delegation is a simple and powerful pattern. However, closures are more Swifty and scales better. Let's convert delegates to closures!",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/swift-delegates-closure-pattern/",
                "comment_count": 6,
                "author": 2,
                "featured_media": 5576,
                "terms": [
                    74,
                    50,
                    55,
                    76,
                    73
                ],
                "meta": {
                    "_series_part": "1"
                },
                "created": "2017-03-03T16:35:14",
                "modified": "2018-10-10T22:01:25"
            },
            {
                "id": 791,
                "title": "What's New in iOS 10 and Beyond",
                "slug": "whats-new-ios-beyond",
                "type": "post",
                "excerpt": "It is clear from this year's WWDC that Apple envisions a new era beyond the traditional apps-in-a-grid-on-your-home-screen model. iOS 10 is more of a revolutionary iteration to the Apple ecosystem and vision. There were many initiatives uncovered that gives us clues to the future of Apple.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/whats-new-ios-beyond/",
                "comment_count": 0,
                "author": 2,
                "featured_media": 792,
                "terms": [
                    68,
                    53,
                    67,
                    4
                ],
                "meta": {
                    "_series_part": ""
                },
                "created": "2016-06-27T11:17:01",
                "modified": "2018-10-06T14:38:50"
            },
            {
                "id": 771,
                "title": "Memory Leaks and Resource Management in Swift and iOS",
                "slug": "memory-leaks-resource-management-swift-ios",
                "type": "post",
                "excerpt": "Less code and less memory while performing the same task at hand is truly where the art comes in. In this post, I'd like to highlight some of the various pitfalls that lead to memory leaks, which inevitably result in crashes. I will also cover some tools and remedies to resolve these issues.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/memory-leaks-resource-management-swift-ios/",
                "comment_count": 5,
                "author": 2,
                "featured_media": 777,
                "terms": [
                    80,
                    53,
                    66,
                    50,
                    55,
                    47
                ],
                "meta": {
                    "_series_part": "5"
                },
                "created": "2016-05-24T10:19:06",
                "modified": "2018-09-30T11:49:10"
            },
            {
                "id": 41294,
                "title": "So Swift, So Clean Architecture for iOS",
                "slug": "swift-clean-architecture",
                "type": "post",
                "excerpt": "The topic of iOS app architecture has evolved a long way from MVC. Unfortunately, the conversation becomes a frameworks and patterns war. The reality is: Rx is a framework; MVVM is a presentation pattern; and so on. Frameworks and patterns always come and go, but architectures are timeless. In this post, we will examine the Clean Architecture for building scalable apps in iOS.",
                "content": "This is a test content 123.",
                "link": "https://staging1.basememara.com/swift-clean-architecture/",
                "comment_count": 10,
                "author": 2,
                "featured_media": 41346,
                "terms": [
                    80,
                    79,
                    53,
                    14,
                    62,
                    50,
                    55
                ],
                "meta": {
                    "_series_part": "1"
                },
                "created": "2018-04-22T22:03:20",
                "modified": "2018-09-30T11:47:51"
            }
        ],
        "authors": [
            {
                "id": 2,
                "name": "Basem Emara",
                "link": "https://staging1.basememara.com",
                "avatar": "https://secure.gravatar.com/avatar/8def0d36f56d3e6720a44e41bf6f9a71?s=96&d=mm&r=g",
                "description": "Basem is a mobile and software IT professional with over 12 years of experience as an architect, developer, and consultant for dozens of projects that span over various industries for Fortune 500 enterprises, government agencies, and startups. In 2014, Basem brought his vast knowledge and experiences to Swift and helped pioneer the language to build scalable enterprise iOS &amp; watchOS apps, later providing mentorship courses.",
                "created": "2015-02-02T03:39:52",
                "modified": "2018-10-06T14:43:53"
            }
        ],
        "media": [
            {
                "id": 41287,
                "link": "https://staging1.basememara.com/wp-content/uploads/2018/04/swift-dependency-injection.jpg",
                "width": 3569,
                "height": 2899,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2018/04/swift-dependency-injection-500x406.jpg",
                "thumbnail_width": 500,
                "thumbnail_height": 406
            },
            {
                "id": 41397,
                "link": "https://staging1.basememara.com/wp-content/uploads/2018/09/Theme-Screenshot.png",
                "width": 2194,
                "height": 1554,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2018/09/Theme-Screenshot-500x354.png",
                "thumbnail_width": 500,
                "thumbnail_height": 354
            },
            {
                "id": 20745,
                "link": "https://staging1.basememara.com/wp-content/uploads/2017/07/localization.jpg",
                "width": 300,
                "height": 284,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2017/07/localization.jpg",
                "thumbnail_width": 300,
                "thumbnail_height": 284
            },
            {
                "id": 41258,
                "link": "https://staging1.basememara.com/wp-content/uploads/2018/04/AppDelegate-Responsibilties.png",
                "width": 414,
                "height": 306,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2018/04/AppDelegate-Responsibilties.png",
                "thumbnail_width": 414,
                "thumbnail_height": 306
            },
            {
                "id": 675,
                "link": "https://staging1.basememara.com/wp-content/uploads/2016/03/CapturFiles_330.png",
                "width": 1218,
                "height": 512,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2016/03/CapturFiles_330-500x210.png",
                "thumbnail_width": 500,
                "thumbnail_height": 210
            },
            {
                "id": 166,
                "link": "https://staging1.basememara.com/wp-content/uploads/2015/03/CapturFiles_35.png",
                "width": 438,
                "height": 162,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2015/03/CapturFiles_35-300x111.png",
                "thumbnail_width": 300,
                "thumbnail_height": 111
            },
            {
                "id": 161,
                "link": "https://staging1.basememara.com/wp-content/uploads/2015/03/kendo-mobile-geo-170x300.png",
                "width": 170,
                "height": 300,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2015/03/kendo-mobile-geo-170x300-170x300.png",
                "thumbnail_width": 170,
                "thumbnail_height": 300
            },
            {
                "id": 141,
                "link": "https://staging1.basememara.com/wp-content/uploads/2015/03/kendo-media-player-169x300.png",
                "width": 169,
                "height": 300,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2015/03/kendo-media-player-169x300-169x300.png",
                "thumbnail_width": 169,
                "thumbnail_height": 300
            },
            {
                "id": 123,
                "link": "https://staging1.basememara.com/wp-content/uploads/2015/03/JS6_Logo-2.png",
                "width": 200,
                "height": 200,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2015/03/JS6_Logo-2.png",
                "thumbnail_width": 200,
                "thumbnail_height": 200
            },
            {
                "id": 277,
                "link": "https://staging1.basememara.com/wp-content/uploads/2015/03/maxresdefault.jpg",
                "width": 1280,
                "height": 800,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2015/03/maxresdefault-300x188.jpg",
                "thumbnail_width": 300,
                "thumbnail_height": 188
            },
            {
                "id": 1739,
                "link": "https://staging1.basememara.com/wp-content/uploads/2017/01/CapturFiles_125.png",
                "width": 391,
                "height": 508,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2017/01/CapturFiles_125.png",
                "thumbnail_width": 391,
                "thumbnail_height": 508
            },
            {
                "id": 26240,
                "link": "https://staging1.basememara.com/wp-content/uploads/2017/07/Xcode-Storyboard-Feature-Based.png",
                "width": 442,
                "height": 564,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2017/07/Xcode-Storyboard-Feature-Based.png",
                "thumbnail_width": 442,
                "thumbnail_height": 564
            },
            {
                "id": 5576,
                "link": "https://staging1.basememara.com/wp-content/uploads/2017/03/delegation1.jpg",
                "width": 573,
                "height": 239,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2017/03/delegation1-500x209.jpg",
                "thumbnail_width": 500,
                "thumbnail_height": 209
            },
            {
                "id": 792,
                "link": "https://staging1.basememara.com/wp-content/uploads/2016/06/ios-10-home-app.jpg",
                "width": 800,
                "height": 534,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2016/06/ios-10-home-app-500x334.jpg",
                "thumbnail_width": 500,
                "thumbnail_height": 334
            },
            {
                "id": 777,
                "link": "https://staging1.basememara.com/wp-content/uploads/2016/05/CapturFiles_349.png",
                "width": 1428,
                "height": 1060,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2016/05/CapturFiles_349-500x371.png",
                "thumbnail_width": 500,
                "thumbnail_height": 371
            },
            {
                "id": 41346,
                "link": "https://staging1.basememara.com/wp-content/uploads/2018/04/Clean-Architecture-Cycle-2.png",
                "width": 500,
                "height": 518,
                "thumbnail_link": "https://staging1.basememara.com/wp-content/uploads/2018/04/Clean-Architecture-Cycle-2-500x518.png",
                "thumbnail_width": 500,
                "thumbnail_height": 518
            }
        ],
        "terms": [
            {
                "id": 80,
                "parent": 0,
                "name": "Building a Scalable App",
                "slug": "build-scalable-app",
                "taxonomy": "series",
                "count": 8
            },
            {
                "id": 62,
                "parent": 0,
                "name": "protocol-oriented-programming",
                "slug": "protocol-oriented-programming",
                "taxonomy": "post_tag",
                "count": 9
            },
            {
                "id": 50,
                "parent": 0,
                "name": "swift",
                "slug": "swift",
                "taxonomy": "post_tag",
                "count": 37
            },
            {
                "id": 55,
                "parent": 0,
                "name": "Swift",
                "slug": "swift",
                "taxonomy": "category",
                "count": 29
            },
            {
                "id": 53,
                "parent": 0,
                "name": "ios",
                "slug": "ios",
                "taxonomy": "post_tag",
                "count": 19
            },
            {
                "id": 81,
                "parent": 0,
                "name": "uikit",
                "slug": "uikit",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 77,
                "parent": 0,
                "name": "localization",
                "slug": "localization",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 47,
                "parent": 0,
                "name": "xcode",
                "slug": "xcode",
                "taxonomy": "post_tag",
                "count": 18
            },
            {
                "id": 56,
                "parent": 0,
                "name": "android",
                "slug": "android",
                "taxonomy": "post_tag",
                "count": 5
            },
            {
                "id": 61,
                "parent": 0,
                "name": "carthage",
                "slug": "carthage",
                "taxonomy": "post_tag",
                "count": 4
            },
            {
                "id": 52,
                "parent": 0,
                "name": "cocoapods",
                "slug": "cocoapods",
                "taxonomy": "post_tag",
                "count": 4
            },
            {
                "id": 64,
                "parent": 0,
                "name": "Featured",
                "slug": "featured",
                "taxonomy": "category",
                "count": 6
            },
            {
                "id": 2,
                "parent": 0,
                "name": ".NET",
                "slug": "net",
                "taxonomy": "category",
                "count": 11
            },
            {
                "id": 41,
                "parent": 0,
                "name": "c#",
                "slug": "c",
                "taxonomy": "post_tag",
                "count": 2
            },
            {
                "id": 10,
                "parent": 0,
                "name": "sitefinity",
                "slug": "sitefinity",
                "taxonomy": "post_tag",
                "count": 4
            },
            {
                "id": 7,
                "parent": 0,
                "name": "Web",
                "slug": "web",
                "taxonomy": "category",
                "count": 17
            },
            {
                "id": 37,
                "parent": 0,
                "name": "web-api",
                "slug": "web-api",
                "taxonomy": "post_tag",
                "count": 2
            },
            {
                "id": 11,
                "parent": 0,
                "name": "aspnet-mvc",
                "slug": "aspnet-mvc",
                "taxonomy": "post_tag",
                "count": 6
            },
            {
                "id": 38,
                "parent": 0,
                "name": "entity-framework",
                "slug": "entity-framework",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 32,
                "parent": 0,
                "name": "css",
                "slug": "css",
                "taxonomy": "post_tag",
                "count": 2
            },
            {
                "id": 3,
                "parent": 0,
                "name": "JavaScript",
                "slug": "javascript",
                "taxonomy": "category",
                "count": 37
            },
            {
                "id": 8,
                "parent": 0,
                "name": "kendo-ui",
                "slug": "kendo-ui",
                "taxonomy": "post_tag",
                "count": 16
            },
            {
                "id": 27,
                "parent": 0,
                "name": "node.js",
                "slug": "node-js",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 26,
                "parent": 0,
                "name": "geolocation",
                "slug": "geolocation",
                "taxonomy": "post_tag",
                "count": 4
            },
            {
                "id": 12,
                "parent": 0,
                "name": "google-map",
                "slug": "google-map",
                "taxonomy": "post_tag",
                "count": 3
            },
            {
                "id": 4,
                "parent": 0,
                "name": "Mobile",
                "slug": "mobile",
                "taxonomy": "category",
                "count": 33
            },
            {
                "id": 9,
                "parent": 0,
                "name": "requirejs",
                "slug": "requirejs",
                "taxonomy": "post_tag",
                "count": 9
            },
            {
                "id": 15,
                "parent": 0,
                "name": "responsive-design",
                "slug": "responsive-design",
                "taxonomy": "post_tag",
                "count": 2
            },
            {
                "id": 14,
                "parent": 0,
                "name": "mvvm",
                "slug": "mvvm",
                "taxonomy": "post_tag",
                "count": 7
            },
            {
                "id": 19,
                "parent": 0,
                "name": "ecmascript-6",
                "slug": "ecmascript-6",
                "taxonomy": "post_tag",
                "count": 4
            },
            {
                "id": 22,
                "parent": 0,
                "name": "angularjs",
                "slug": "angularjs",
                "taxonomy": "post_tag",
                "count": 3
            },
            {
                "id": 44,
                "parent": 0,
                "name": "typescript",
                "slug": "typescript",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 72,
                "parent": 0,
                "name": "wordpress",
                "slug": "wordpress",
                "taxonomy": "post_tag",
                "count": 2
            },
            {
                "id": 78,
                "parent": 0,
                "name": "router",
                "slug": "router",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 74,
                "parent": 0,
                "name": "delegates",
                "slug": "delegates",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 76,
                "parent": 0,
                "name": "Swifty Delegates",
                "slug": "swifty-delegates",
                "taxonomy": "series",
                "count": 2
            },
            {
                "id": 73,
                "parent": 0,
                "name": "threads",
                "slug": "threads",
                "taxonomy": "post_tag",
                "count": 4
            },
            {
                "id": 68,
                "parent": 0,
                "name": "ai",
                "slug": "ai",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 67,
                "parent": 0,
                "name": "iot",
                "slug": "iot",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 66,
                "parent": 0,
                "name": "memory",
                "slug": "memory",
                "taxonomy": "post_tag",
                "count": 1
            },
            {
                "id": 79,
                "parent": 0,
                "name": "clean-architecture",
                "slug": "clean-architecture",
                "taxonomy": "post_tag",
                "count": 2
            }
        ]
    }
    """