//
//  CalendarCoordinator.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import EventKit

class CalendarCoordinator: NSObject {
    /*
    static let sharedCoordinator = CalendarCoordinator()
    
    var eventStore = EKEventStore()
   
    // MARK: Helpers
    
    func requestAuthorization(callback: ((Bool) -> Void)?) {
        if EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent) != EKAuthorizationStatus.Authorized {
            CalendarCoordinator.sharedCoordinator.eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted: Bool, error: NSError!) -> Void in
                
                // something about reseting this allows permissions to update
                self.eventStore = EKEventStore()
                
                if let callback = callback {
                    callback(granted)
                }
           })
        } else {
            println("we're already getting calendars")
        }
    }
    
    class func allCalendars() -> [EKCalendar] {
        return CalendarCoordinator.sharedCoordinator.eventStore.calendarsForEntityType(EKEntityTypeEvent) as! [EKCalendar]
    }
    
    class func authorizationGranted() -> Bool {
        return status() == .Authorized
    }
    
    class func authorizationNotDetermined() -> Bool {
        return status() == .NotDetermined
    }
    
    class func authorizationDenied() -> Bool {
        return status() == .Restricted || status() == .Denied
    }
    
    class func needsRequestAuthorization() -> Bool {
        return authorizationNotDetermined()
    }
    
    class func activate() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: UserLocationEnabledKey)
    }
    
    class func deactivate() {
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: UserLocationEnabledKey)
    }
    
    class func isActive() -> Bool {
        let active = NSUserDefaults.standardUserDefaults().boolForKey(UserLocationEnabledKey) == true
        return authorizationGranted() && active
    }
    
    class func status() -> EKAuthorizationStatus {
        return EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)
    }
    */
}
