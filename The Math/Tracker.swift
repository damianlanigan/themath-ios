//
//  Tracker.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/10/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class Tracker: NSObject {
    
    class func trackCategoryDeselected(type: CategoryType) {
        track("category", action: "delected", label: type.rawValue)
    }
    
    class func trackCategorySelected(type: CategoryType) {
        track("category", action: "selected", label: type.rawValue)
    }
    
    class func trackNumberOfCategoriesSelected(count: Int) {
        track("categories", action: "selected", label: "\(count)")
    }
    
    class func trackMoodSet(percentage: Double) {
        track("mood", action: "set", label: "\(percentage)%")
    }
    
    class func trackCategoryRated(name: String, feeling: String) {
        track("category rated", action: name, label: feeling)
    }
    
    class func trackAddNoteButtonTapped() {
        track("add a note", action: "presented", label: "")
    }
    
    class func trackAddNoteAttachImageTapped() {
        track("add a note", action: "image", label: "tapped")
    }
    
    class func trackAddNoteSaveButtonTapped() {
        track("add a note", action: "save", label: "tapped")
    }
    
    class func trackReplayOnboarding() {
        track("onboarding", action: "replayed", label: "")
    }
    
    class func trackTappedSendFeedbackButton() {
        track("send feedback", action: "tapped", label: "")
    }
    
    class func track(category: String, action: String, label: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        let dictionary = GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: nil).build()
        tracker.send(dictionary)
    }
}
