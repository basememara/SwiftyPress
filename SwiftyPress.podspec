Pod::Spec.new do |s|
    s.name             = "SwiftyPress"
    s.version          = "0.1.0"
    s.summary          = "A Swift framework for rapidly developing iOS, watchOS, and tvOS apps for WordPress."
    s.description      = <<-DESC
                            SwiftyPress is a Swift framework for iOS, watchOS, and tvOS to allow
                            developers to code rapidly for building data-driven mobile applications.
                            Focus on solutions by using our API that sits as an
                            abstraction layer on top of iOS, watchOS, tvOS, and WordPress.
                            SwiftyPress provides you the latest patterns, techniques,
                            and libraries so you can begin building for the future.
                        DESC
    s.homepage          = "https://github.com/ZamzamInc/SwiftyPress"
    # s.screenshots     = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
    s.license          = { :type => "MIT", :file => "LICENSE" }
    s.author           = { "Zamzam Inc." => "contact@zamzam.io" }
    s.source           = { :git => "https://github.com/ZamzamInc/SwiftyPress.git", :tag => s.version }
    s.social_media_url = 'https://twitter.com/zamzaminc'

    s.ios.deployment_target = "9.0"
    s.watchos.deployment_target = "2.0"
    s.tvos.deployment_target = "9.0"

    s.requires_arc = true

    s.source_files = "Sources/**/*.{h,swift}"

    s.dependency 'ZamzamKit'
    s.dependency 'Alamofire'
    s.dependency 'Timepiece'
    //TODO
end