//
//  👨🏻
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

        window?.backgroundColor = UIColor.whiteColor()

        setupFabric()
        setupAnalytics()
        
        Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "X-Application-Id": "31f60218d62033240d67424aaac4a9e87d8e6ca74a42dd04509447627151c300"
        ]


        return true
    }

    private func setupFabric() {
        Fabric.with([Crashlytics()])
    }

    private func setupAnalytics() {
    }
}

