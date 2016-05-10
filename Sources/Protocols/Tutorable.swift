//
//  Tutorable.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/9/16.
//
//

import UIKit
import AlertOnboarding_iOS

protocol Tutorable: class, AlertOnboardingDelegate {
    
}

extension Tutorable where Self: UIViewController {
    
    func showTutorial(displayMultipleTimes: Bool = true) {
        // Start tutorial if applicable
        if displayMultipleTimes || !AppGlobal.userDefaults[.isTutorialFinished] {
            let alertView = AlertOnboarding(
                arrayOfImage: AppGlobal.userDefaults[.tutorial].flatMap { $0["image"] as? String },
                arrayOfTitle: AppGlobal.userDefaults[.tutorial].flatMap { $0["title"] as? String },
                arrayOfDescription: AppGlobal.userDefaults[.tutorial].flatMap { $0["desc"] as? String })

            alertView.delegate = self
    
            alertView.percentageRatioHeight = 0.9
            alertView.percentageRatioWidth = 0.9
            alertView.colorButtonBottomBackground = UIColor(rgb: AppGlobal.userDefaults[.tintColor])
            alertView.colorButtonText = UIColor(rgb: AppGlobal.userDefaults[.titleColor])

            alertView.show()
        }
    }
    
    // Optional functions for delegate
    func alertOnboardingCompleted() {
        AppGlobal.userDefaults[.isTutorialFinished] = true
    }
    
    func alertOnboardingNext(nextStep: Int) {
    
    }
    
    func alertOnboardingSkipped(currentStep: Int, maxStep: Int) {
        alertOnboardingCompleted()
    }
}