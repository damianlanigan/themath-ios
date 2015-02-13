//
//  👨
// 
//  AppDelegate.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        setupFabric()
        setupAnalytics()
        
        return true
    }
    
    private func setupFabric() {
        Fabric.with([Crashlytics()])
    }
    
    private func setupAnalytics() {
        GAI.sharedInstance().trackUncaughtExceptions = true
        GAI.sharedInstance().dispatchInterval = 20
        GAI.sharedInstance().logger.logLevel = .None
        
        GAI.sharedInstance().trackerWithTrackingId("UA-55460587-3")
    }
}

