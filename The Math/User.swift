//
//  User.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/25/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import Alamofire

class User: NSObject {
    
    var latestEntry: JournalEntry?
    
    func getLatestMood(completion: (entry: JournalEntry?) -> Void) {
        request(Router.LatestJournalEntry()).responseJSON { (request, response, data, error) in
            if let data = data as? [String: AnyObject] {
                self.latestEntry = JournalEntry.fromJSONRequest(data)
                completion(entry: self.latestEntry)
            } else {
                completion(entry: nil)
            }
        }
    }
    
    func requestPasswordReset(email: String) {
        request(Router.ResetPassword(["email" : email])).responseJSON { (request, response, data, error) in
        }
    }
}
