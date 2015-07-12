//
//  User.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/25/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class User: NSObject {
    func getLatestMood(completion: () -> Void) {
        request(Router.LatestJournalEntry()).responseJSON { (request, response, data, error) in
            completion()
//            if let data = data as? [String: AnyObject] {
//                let entry = JournalEntry.fromJSONRequest(data)
//                let lastMood = "Last mood\n"
//                let timestamp = "\(entry.timestamp.relativeTimeToString())"
//                var string = NSMutableAttributedString(string: "\(lastMood) \(timestamp)")
//                let color = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: CGFloat(entry.score) / 100.0)
//                let range = NSMakeRange(count(lastMood), count(" \(timestamp)"))
//                string.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
////                self.latestMoodLabel.attributedText = string
//            } else {
////                self.latestMoodLabel.text = ""
//            }
        }
    }
}
