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
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window?.backgroundColor = UIColor.whiteColor()
        
        setupGlobalUI()

        return true
    }
    
    private func setupGlobalUI() {
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: CabritoSansFontName, size: 17)!]
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: CabritoSansFontName, size: 17)!], forState: .Normal)
    }
    
    func navigateToSettings() {
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(url!)
        case .OrderedAscending:
            // TODO: capture these people. possibly a little modal. who knows, really?
            return
        }
    }
}

