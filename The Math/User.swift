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
        request(Router.LatestJournalEntry()).responseJSON { (_, _, result: Result<AnyObject>) -> Void in
            if result.isSuccess {
                if let _ = result.value as? [String : AnyObject] {
                    self.latestEntry = JournalEntry.fromJSONRequest(result.value as! [String : AnyObject])
                    completion(entry: self.latestEntry)
                } else {
                    completion(entry: nil)
                }

            } else {
                completion(entry: nil)
            }
        }
    }
    
    func requestPasswordReset(email: String, completion: (success: Bool) -> Void) {
        request(Router.ResetPassword(["email" : email])).responseJSON { (_, _, result: Result<AnyObject>) -> Void in
            completion(success: result.isSuccess)
        }
    }
}
