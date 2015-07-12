//
//  VendorAccountsTableViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/16/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreLocation

class VendorAccountsTableViewController: UITableViewController {

    @IBOutlet weak var locationSwitch: UISwitch!
    var previousLocationAuthorizationStatus: CLAuthorizationStatus = .NotDetermined
    
    var manager: LocationCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Accounts"
        
        setup()
    }
    
    private func setup() {
        setInitialValues()
        setupNotificationObservers()
    }
    
    private func setupNotificationObservers() {
        // This happens when location permissions are selected
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "applicationDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    private func setInitialValues() {
        locationSwitch.on = LocationCoordinator.isActive()
    }
    
    func applicationDidBecomeActive() {
        if LocationCoordinator.authorizationGranted() {
            LocationCoordinator.activate()
        } else {
            LocationCoordinator.deactivate()
        }
        
        locationSwitch.setOn(LocationCoordinator.isActive(), animated: true)
    }
    
    @IBAction func locationSwitchToggled(sender: UISwitch) {
        if sender.on {
            if LocationCoordinator.needsRequestAuthorization() {
                LocationCoordinator.sharedCoordinator.requestAuthorization()
            } else {
                if LocationCoordinator.authorizationDenied() {
                    goToSettings()
                } else {
                    LocationCoordinator.activate()
                }
            }
        } else {
            LocationCoordinator.deactivate()
        }
    }
    
    private func goToSettings() {
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            let url = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(url!)
        case .OrderedAscending:
            // TODO: capture these people. possibly a little modal. who knows, really?
            return
        }
    }
    
    
    // MARK: <UITableViewControllerDelegate>
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
    }
}
