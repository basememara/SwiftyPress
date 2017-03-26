# SwiftyPress

[![CI Status](http://img.shields.io/travis/ZamzamInc/SwiftyPress.svg?style=flat)](https://travis-ci.org/ZamzamInc/SwiftyPress)
[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## Usage

To run the project, clone the repo, and run the example app.

## Requirements

## Installation
* `carthage update --platform iOS --no-build`
* `(cd Carthage/Checkouts/Stencil && swift package generate-xcodeproj)`
* Open Stencil.proj and add iOS 10
* `carthage build --platform iOS`
* add carthage frameworks dependencies to project settings
* embed Realm/ReamSwift frameworks
* add ATS exception to plist
* add LSApplicationQueriesSchemes to plist
* for App Store submissions:
    - add carthage script in build phases for each dependency
    - add bundle version in -> Carthage/Build/iOS/{Pathkit, Spectre, and Stencil}.framwork/Info.plist

#### Carthage
You can use [Carthage](https://github.com/Carthage/Carthage) to install `SwiftyPress` by adding it to your `Cartfile`:
```
github "ZamzamInc/SwiftyPress"
```

## Author

Zamzam Inc., contact@zamzam.io

## License

SwiftyPress is available under the MIT license. See the LICENSE file for more info.
