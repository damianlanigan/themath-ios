//
//  SettingsTableViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/24/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import CoreLocation

protocol SettingsTableViewControllerDelegate: class {
    func didLogout()
}

class SettingsTableViewController: UITableViewController, UIAlertViewDelegate {
    
    @IBOutlet weak var locationSwitch: UISwitch!
    var previousLocationAuthorizationStatus: CLAuthorizationStatus = .NotDetermined
    
    weak var delegate: SettingsTableViewControllerDelegate?
    
    var selectedIdx: Int?
    let titles = ["About", "Privacy Policy", "Terms of Service"]
    let urls = ["http://damianlanigan.github.io/about", "http://damianlanigan.github.io/privacy", "http://damianlanigan.github.io/terms"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        navigationItem.leftBarButtonItem = button
        
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
    
    @objc private func applicationDidBecomeActive() {
        if LocationCoordinator.authorizationGranted() {
            LocationCoordinator.activate()
        } else {
            LocationCoordinator.deactivate()
        }
        
        locationSwitch.setOn(LocationCoordinator.isActive(), animated: true)
    }
    
    private func setInitialValues() {
        locationSwitch.on = LocationCoordinator.isActive()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let idx = selectedIdx {
            if let viewController = segue.destinationViewController as? WebViewController {
                print(idx)
                viewController.navigationTitle = titles[idx]
                viewController.url = NSURL(string: urls[idx])
            }
        }
    }
    
    @IBAction func locationSwitchToggled(sender: UISwitch) {
        if sender.on {
            if LocationCoordinator.needsRequestAuthorization() {
                LocationCoordinator.sharedCoordinator.requestAuthorization()
            } else {
                if LocationCoordinator.authorizationDenied() {
                    let alert = UIAlertView(title: "Open Settings", message: "Tap Location and turn on 'While Using the App'", delegate: self, cancelButtonTitle: "Dismiss", otherButtonTitles:"Settings")
                    alert.tag = 1
                    alert.show()
                } else {
                    LocationCoordinator.activate()
                }
            }
        } else {
            LocationCoordinator.deactivate()
        }
    }
    
    // MARK: UITableView delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 1 {
            selectedIdx = indexPath.row
            performSegueWithIdentifier("ShowWebController", sender: self)
        }
        
        if indexPath.section == 2 {
            let alert = UIAlertView(title: "Log out", message: "Are you sure?", delegate: self, cancelButtonTitle: "No", otherButtonTitles: "Log out")
            alert.tag = 2
            alert.show()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // UIAlertView deleget
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 1 {
            if buttonIndex == 1 {
                let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
                delegate.navigateToSettings()
            }
        } else if alertView.tag == 2 {
            if buttonIndex == 1 {
                Account.sharedAccount().logout({
                    print("logged out")
                    self.delegate?.didLogout()
                })
            }
        }
        
        applicationDidBecomeActive()
    }
    
}
