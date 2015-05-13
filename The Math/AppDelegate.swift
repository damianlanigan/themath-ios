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

let DEBUG = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window?.backgroundColor = UIColor.whiteColor()

        setupFabric()
        setupAnalytics()
        
        let applicationId = DEBUG ?
            "31f60218d62033240d67424aaac4a9e87d8e6ca74a42dd04509447627151c300" :
//            "02841f8d59cee62615fd7566ef75df5d5b62b02e68f5c31eb977621a9d588244" :
            "0a5589d35f67d7aa81a3d2224a7db91433029ad9ccee7af7c1fac9da3e13b98d"
        Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = [
            "Content-Type": "application/json",
            "X-Application-Id" : applicationId
        ]

        return true
    }

    private func setupFabric() {
        Fabric.with([Crashlytics()])
    }

    private func setupAnalytics() {
    }
}

