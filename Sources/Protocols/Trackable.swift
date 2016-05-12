//
//  Trackable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/12/16.
//
//

import Foundation

protocol Trackable {

}

extension Trackable {

    func willTrackableAppear(trackingName: String) {
        trackPage(trackingName)
    }
    
    /**
    Track page hit and send to Google Analytics
    
    :param: pageName name of the page
    */
    func trackPage(pageName: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: pageName)
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    /**
    Track event and send to Google Analytics
    
    :param: action description of the event
    :param: label  label of the event
    :param: value  specific value about the data
    */
    func trackEvent(category: String, action: String, label: String? = nil, value: Int? = nil) {
        let tracker = GAI.sharedInstance().defaultTracker
        let event = GAIDictionaryBuilder.createEventWithCategory(
            category, action: action, label: label?.decodeHTML(), value: value)
        tracker.send(event.build() as [NSObject : AnyObject])
    }
}