//
//  Tracker.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 2/10/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class Tracker: NSObject {

    class func track(category: String, action: String, label: String) {
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.send(GAIDictionaryBuilder.createEventWithCategory(category, action: action, label: label, value: nil).build() as [NSObject:AnyObject])
    }

}
