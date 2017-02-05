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
    
    /**
    Track page hit and send to Google Analytics
    
    :param: pageName name of the page
    */
    func trackPage(_ pageName: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: pageName)
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker?.send(builder.build() as [NSObject : AnyObject])
    }
    
    /**
    Track event and send to Google Analytics
    
    :param: action description of the event
    :param: label  label of the event
    :param: value  specific value about the data
    */
    func trackEvent(_ category: String, action: String, label: String? = nil, value: Int? = nil) {
        let tracker = GAI.sharedInstance().defaultTracker
        
        guard let event = GAIDictionaryBuilder.createEvent(
            withCategory: category, action: action, label: label?.htmlDecoded, value: value as NSNumber!)
                else { return }
        
        tracker?.send(event.build() as [NSObject : AnyObject])
    }
}
