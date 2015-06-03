//
//  LocationCoordinator.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationCoordinatorDelegate: class {
    func locationCoordinator(coordinator: LocationCoordinator, didReceiveLocation location: CLLocation)
}

let UserLocationEnabledKey = "UserLocationEnabledKey"

class LocationCoordinator: NSObject,
    CLLocationManagerDelegate {
    
    private let AccuracyThreshold = 100.0
    
    weak var delegate: LocationCoordinatorDelegate?
    
    static let sharedCoordinator = LocationCoordinator()
   
    lazy var manager: CLLocationManager = {
        let l = CLLocationManager()
        l.delegate = self
        l.desiredAccuracy = kCLLocationAccuracyBest
        l.activityType = .Other
        l.distanceFilter = 0.0
        return l
    }()
    
    func start() {
        let status = LocationCoordinator.status()
        if status == .AuthorizedWhenInUse || status == .NotDetermined {
          manager.startUpdatingLocation()
        }
    }
    
    func stop() {
        manager.stopUpdatingLocation()
    }
    
    // MARK: <CLLocationManagerDelegate>
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let location = locations[0] as? CLLocation {
            if location.horizontalAccuracy <= AccuracyThreshold {
                delegate?.locationCoordinator(self, didReceiveLocation: location)
            }
        }
    }
    
    // MARK: Helpers
    
    func requestAuthorization() {
        if LocationCoordinator.status() != .AuthorizedWhenInUse {
            if manager.respondsToSelector("requestWhenInUseAuthorization") {
                manager.requestWhenInUseAuthorization()
            }
        } else {
            println("we're already getting location")
        }
    }
    
    class func authorizationGranted() -> Bool {
        return status() == .AuthorizedWhenInUse
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
    
    class func status() -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
}
