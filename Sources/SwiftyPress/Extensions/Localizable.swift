//
//  Localizable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-09-07.
//  Copyright © 2019 Zamzam Inc. All rights reserved.
//

import Foundation.NSBundle
import ZamzamCore

// System Errors
public extension Localizable {
    static let duplicateFailureErrorMessage = Localizable(NSLocalizedString("duplicate.failure.error.message", bundle: .swiftyPress, comment: "General error for duplicate data"))
    static let nonExistentErrorMessage = Localizable(NSLocalizedString("non.existent.error.message", bundle: .swiftyPress, comment: "General error for non-existent data"))
    static let unauthorizedErrorTitle = Localizable(NSLocalizedString("unauthorized.error.title", bundle: .swiftyPress, comment: "Unauthorized alert error title"))
    static let unauthorizedErrorMessage = Localizable(NSLocalizedString("unauthorized.error.message", bundle: .swiftyPress, comment: "Unauthorized alert error message"))
    static let noInternetErrorMessage = Localizable(NSLocalizedString("no.internet.error.message", bundle: .swiftyPress, comment: "General error for no internet availability"))
    static let serverTimeoutErrorMessage = Localizable(NSLocalizedString("server.timeout.error.message", bundle: .swiftyPress, comment: "General error for server availability"))
    
    static let parseFailureErrorMessage = Localizable(NSLocalizedString("parse.failure.error.message", bundle: .swiftyPress, comment: "General parse error for data"))
    static let databaseFailureErrorMessage = Localizable(NSLocalizedString("database.failure.error.message", bundle: .swiftyPress, comment: "General database error"))
    static let cacheFailureErrorMessage = Localizable(NSLocalizedString("cache.failure.error.message", bundle: .swiftyPress, comment: "Cache storage failure even though remote succeeded"))
    static let serverFailureErrorMessage = Localizable(NSLocalizedString("server.failure.error.message", bundle: .swiftyPress, comment: "General error for server request"))
    static let badRequestErrorMessage = Localizable(NSLocalizedString("bad.request.error.message", bundle: .swiftyPress, comment: "General error for bad request"))
    static let unknownReasonErrorMessage = Localizable(NSLocalizedString("unknown.reason.error.message", bundle: .swiftyPress, comment: "General error for unknown reason"))
    
    static let genericIncompleteFormErrorMessage = Localizable(NSLocalizedString("generic.incomplete.form.error.message", bundle: .swiftyPress, comment: "Generic alert error message for incomplete form"))
}

// Specific Errors
public extension Localizable {
    static let latestPostsErrorTitle = Localizable(NSLocalizedString("latest.posts.error.title", bundle: .swiftyPress, comment: "Latest posts alert error title"))
    static let popularPostsErrorTitle = Localizable(NSLocalizedString("popular.posts.error.title", bundle: .swiftyPress, comment: "Popular posts alert error title"))
    static let topPickPostsErrorTitle = Localizable(NSLocalizedString("top.pick.posts.error.title", bundle: .swiftyPress, comment: "Top pick posts alert error title"))
    static let postsByTermsErrorTitle = Localizable(NSLocalizedString("posts.by.terms.error.title", bundle: .swiftyPress, comment: "Posts by terms alert error title"))
    static let termsErrorTitle = Localizable(NSLocalizedString("terms.error.title", bundle: .swiftyPress, comment: "Terms alert error title"))
    static let blogPostErrorTitle = Localizable(NSLocalizedString("blog.post.error.title", bundle: .swiftyPress, comment: "Blog post alert error title"))
    static let browserNotAvailableErrorTitle = Localizable(NSLocalizedString("browser.not.available.error.title", bundle: .swiftyPress, comment: "Browser unavailable alert error title"))
    static let commentsNotAvailableErrorTitle = Localizable(NSLocalizedString("comments.not.available.error.title", bundle: .swiftyPress, comment: "Comments unavailable alert error title"))
    static let notConnectedToInternetErrorMessage = Localizable(NSLocalizedString("not.connected.to.internet.error.message", bundle: .swiftyPress, comment: "Internet unavailable alert error message"))
    static let noPostInHistoryErrorMessage = Localizable(NSLocalizedString("no.post.in.history.error.message", bundle: .swiftyPress, comment: "No post in history alert error message"))
    static let couldNotSendEmail = Localizable(NSLocalizedString("could.not.send.email", bundle: .swiftyPress, comment: "The title of the dialog alerting the user an email could not be composed"))
    static let couldNotSendEmailMessage = Localizable(NSLocalizedString("could.not.send.email.message", bundle: .swiftyPress, comment: "The message of the dialog alerting the user an email could not be composed"))
    static let disclaimerNotAvailableErrorTitle = Localizable(NSLocalizedString("disclaimer.not.available.error.title", bundle: .swiftyPress, comment: "The title of the dialog alerting the user no disclaimer info is available"))
    static let disclaimerNotAvailableErrorMessage = Localizable(NSLocalizedString("disclaimer.not.available.error.message", bundle: .swiftyPress, comment: "The message of the dialog alerting the user no disclaimer info is available"))
}

public extension Localizable {
    static let categorySection = Localizable(NSLocalizedString("category.section", bundle: .swiftyPress, comment: "Table section header for categories"))
    static let tagSection = Localizable(NSLocalizedString("tag.section", bundle: .swiftyPress, comment: "Table section header for tags"))
    
    static func taxonomy(for name: String) -> Localizable {
        let key = "taxonomy.section.\(name.lowercased())"
        
        // Determine if localization exists
        guard let bundle: Bundle = (Bundle.main.localizedString(forKey: key, value: nil, table: nil) != key ? .main
            : Bundle.swiftyPress.localizedString(forKey: key, value: nil, table: nil) != key ? .swiftyPress
            : nil) else {
                // Fallback to original name capitalized
                return Localizable(name.capitalized)
        }
        
        return Localizable(NSLocalizedString(key, bundle: bundle, comment: "Table section header for custom taxonomy"))
    }
}

// Misc
public extension Localizable {
    static let seeAllButton = Localizable(NSLocalizedString("see.all.button", bundle: bundle(forKey: "see.all.button", fallback: .swiftyPress), comment: "Button title for seeing all results"))
    static let favoritesTitle = Localizable(NSLocalizedString("favorites.title", bundle: bundle(forKey: "favorites.title", fallback: .swiftyPress), comment: "Navigation title of favorites"))
    static let emptyFavoritesMessage = Localizable(NSLocalizedString("empty.favorites.message", bundle: bundle(forKey: "empty.favorites.message", fallback: .swiftyPress), comment: "Table message for no favorites"))
    static let emptySearchMessage = Localizable(NSLocalizedString("empty.search.message", bundle: bundle(forKey: "empty.search.message", fallback: .swiftyPress), comment: "Table message for no search results"))
    static let listTermsTitle = Localizable(NSLocalizedString("list.terms.title", bundle: bundle(forKey: "list.terms.title", fallback: .swiftyPress), comment: "Navigation title of categories and tags"))
    static let unfavorTitle = Localizable(NSLocalizedString("unfavor.title", bundle: bundle(forKey: "unfavor.title", fallback: .swiftyPress), comment: "Unfavor title for buttons and dialogs"))
    static let unfavoriteTitle = Localizable(NSLocalizedString("unfavorite.title", bundle: bundle(forKey: "unfavorite.title", fallback: .swiftyPress), comment: "Unfavorite title for buttons and dialogs"))
    static let favoriteTitle = Localizable(NSLocalizedString("favorite.title", bundle: bundle(forKey: "favorite.title", fallback: .swiftyPress), comment: "Favorite title for buttons and dialogs"))
    static let commentsTitle = Localizable(NSLocalizedString("comments.title", bundle: bundle(forKey: "comments.title", fallback: .swiftyPress), comment: "Comments title for buttons and dialogs"))
    static let emailFeedbackSubject = Localizable(NSLocalizedString("email.feedback.subject", bundle: bundle(forKey: "email.feedback.subject", fallback: .swiftyPress), comment: "Email subject for sending feedback"))
    static let shareAppMessage = Localizable(NSLocalizedString("share.app.message", bundle: bundle(forKey: "share.app.message", fallback: .swiftyPress), comment: "Message for sharing the app"))
    static let disclaimerButtonTitle = Localizable(NSLocalizedString("disclaimer.button.title", bundle: bundle(forKey: "disclaimer.button.title", fallback: .swiftyPress), comment: "Button title for the disclaimer page"))
    static let privacyButtonTitle = Localizable(NSLocalizedString("privacy.button.title", bundle: bundle(forKey: "privacy.button.title", fallback: .swiftyPress), comment: "Button title for the privacy page"))
    static let contactButtonTitle = Localizable(NSLocalizedString("contact.button.title", bundle: bundle(forKey: "contact.button.title", fallback: .swiftyPress), comment: "Button title for the contact"))
}

// Posts
public extension Localizable {
    static let latestPostsTitle = Localizable(NSLocalizedString("latest.posts.title", bundle: bundle(forKey: "latest.posts.title", fallback: .swiftyPress), comment: "Latest posts title"))
    static let popularPostsTitle = Localizable(NSLocalizedString("popular.posts.title", bundle: bundle(forKey: "popular.posts.title", fallback: .swiftyPress), comment: "Popular posts title"))
    static let topPicksTitle = Localizable(NSLocalizedString("top.picks.title", bundle: bundle(forKey: "top.picks.title", fallback: .swiftyPress), comment: "Top pick posts title"))
    static let postsByTermsTitle = Localizable(NSLocalizedString("posts.by.terms.title", bundle: bundle(forKey: "posts.by.terms.title", fallback: .swiftyPress), comment: "Posts by terms title"))
}

// Search
public extension Localizable {
    static let searchPlaceholder = Localizable(NSLocalizedString("search.placeholder", bundle: bundle(forKey: "search.placeholder", fallback: .swiftyPress), comment: "Search placeholder for text field"))
    static let searchAllScope = Localizable(NSLocalizedString("search.all.scope", bundle: bundle(forKey: "search.all.scope", fallback: .swiftyPress), comment: "All label for search scope"))
    static let searchTitleScope = Localizable(NSLocalizedString("search.title.scope", bundle: bundle(forKey: "search.title.scope", fallback: .swiftyPress), comment: "Title label for search scope"))
    static let searchContentScope = Localizable(NSLocalizedString("search.content.scope", bundle: bundle(forKey: "search.content.scope", fallback: .swiftyPress), comment: "Content label for search scope"))
    static let searchKeywordsScope = Localizable(NSLocalizedString("search.keywords.scope", bundle: bundle(forKey: "search.keywords.scope", fallback: .swiftyPress), comment: "Keywords label for search scope"))
    static let searchErrorTitle = Localizable(NSLocalizedString("search.error.title", bundle: bundle(forKey: "search.error.title", fallback: .swiftyPress), comment: "Search alert error title"))
}

// Main
public extension Localizable {
    static let tabHomeTitle = Localizable(NSLocalizedString("tab.home.title", bundle: bundle(forKey: "tab.home.title", fallback: .swiftyPress), comment: "The title of the home tab"))
    static let tabBlogTitle = Localizable(NSLocalizedString("tab.blog.title", bundle: bundle(forKey: "tab.blog.title", fallback: .swiftyPress), comment: "The title of the blog tab"))
    static let tabFavoritesTitle = Localizable(NSLocalizedString("tab.favorites.title", bundle: bundle(forKey: "tab.favorites.title", fallback: .swiftyPress), comment: "The title of the favorites tab"))
    static let tabSearchTitle = Localizable(NSLocalizedString("tab.search.title", bundle: bundle(forKey: "tab.search.title", fallback: .swiftyPress), comment: "The title of the search tab"))
    static let tabMoreTitle = Localizable(NSLocalizedString("tab.more.title", bundle: bundle(forKey: "tab.more.title", fallback: .swiftyPress), comment: "The title of the more tab"))
}

// Social
public extension Localizable {
    static let githubSocialTitle = Localizable(NSLocalizedString("github.social.title", bundle: bundle(forKey: "github.social.title", fallback: .swiftyPress), comment: "The title of GitHub social network"))
    static let linkedInSocialTitle = Localizable(NSLocalizedString("linkedIn.social.title", bundle: bundle(forKey: "linkedIn.social.title", fallback: .swiftyPress), comment: "The title of LinkedIn social network"))
    static let twitterSocialTitle = Localizable(NSLocalizedString("twitter.social.title", bundle: bundle(forKey: "twitter.social.title", fallback: .swiftyPress), comment: "The title of Twitter social network"))
    static let pinterestSocialTitle = Localizable(NSLocalizedString("pinterest.social.title", bundle: bundle(forKey: "pinterest.social.title", fallback: .swiftyPress), comment: "The title of Pinterest social network"))
    static let instagramSocialTitle = Localizable(NSLocalizedString("instagram.social.title", bundle: bundle(forKey: "instagram.social.title", fallback: .swiftyPress), comment: "The title of Instagram social network"))
    static let emailSocialTitle = Localizable(NSLocalizedString("email.social.title", bundle: bundle(forKey: "email.social.title", fallback: .swiftyPress), comment: "The title of the email service"))
}

// More
public extension Localizable {
    static let moreMenuSubscribeTitle = Localizable(NSLocalizedString("more.menu.subscribe.title", bundle: bundle(forKey: "more.menu.subscribe.title", fallback: .swiftyPress), comment: "The title of the subscribe menu item on the more scene"))
    static let moreMenuFeedbackTitle = Localizable(NSLocalizedString("more.menu.feedback.title", bundle: bundle(forKey: "more.menu.feedback.title", fallback: .swiftyPress), comment: "The title of the feedback menu item on the more scene"))
    static let moreMenuWorkTitle = Localizable(NSLocalizedString("more.menu.work.title", bundle: bundle(forKey: "more.menu.work.title", fallback: .swiftyPress), comment: "The title of the work with us menu item on the more scene"))
    static let moreMenuRateTitle = Localizable(NSLocalizedString("more.menu.rate.title", bundle: bundle(forKey: "more.menu.rate.title", fallback: .swiftyPress), comment: "The title of the rate our app menu item on the more scene"))
    static let moreMenuShareTitle = Localizable(NSLocalizedString("more.menu.share.title", bundle: bundle(forKey: "more.menu.share.title", fallback: .swiftyPress), comment: "The title of the share menu item on the more scene"))
    static let moreMenuSocialSectionTitle = Localizable(NSLocalizedString("more.social.section.title", bundle: bundle(forKey: "more.social.section.title", fallback: .swiftyPress), comment: "The title of the social section on the more scene"))
    static let moreMenuOtherSectionTitle = Localizable(NSLocalizedString("more.other.section.title", bundle: bundle(forKey: "more.other.section.title", fallback: .swiftyPress), comment: "The title of the other section item on the more scene"))
    static let moreMenuDevelopedByTitle = Localizable(NSLocalizedString("more.menu.developed.by.title", bundle: bundle(forKey: "more.menu.developed.by.title", fallback: .swiftyPress), comment: "The title of the developed by menu item on the more scene"))
}

// Settings
public extension Localizable {
    static let settingsMenuThemeTitle = Localizable(NSLocalizedString("settings.menu.theme.title", bundle: bundle(forKey: "settings.menu.theme.title", fallback: .swiftyPress), comment: "The title of the theme menu item on the settings scene"))
    static let settingsMenuNotificationsTitle = Localizable(NSLocalizedString("settings.menu.notifications.title", bundle: bundle(forKey: "settings.menu.notifications.title", fallback: .swiftyPress), comment: "The title of the notifications menu item on the settings scene"))
    static let settingsMenuPhoneSettingsTitle = Localizable(NSLocalizedString("settings.menu.phone.settings.title", bundle: bundle(forKey: "settings.menu.phone.settings.title", fallback: .swiftyPress), comment: "The title of the iOS settings menu item on the settings scene"))
}
