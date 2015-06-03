//
//  SettingsTableViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/24/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol SettingsTableViewControllerDelegate: class {
    func didLogout()
}

class SettingsTableViewController: UITableViewController {
    
    weak var delegate: SettingsTableViewControllerDelegate?
    var selectedIdx: Int?
    let titles = ["About", "Privacy Policy", "Terms of Service"]
    let urls = ["http://damianlanigan.github.io/about", "http://damianlanigan.github.io/privacy", "http://damianlanigan.github.io/terms"]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        let button = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismiss")
        navigationItem.leftBarButtonItem = button
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let idx = selectedIdx {
            if let viewController = segue.destinationViewController as? WebViewController {
                println(idx)
                viewController.navigationTitle = titles[idx]
                viewController.url = NSURL(string: urls[idx])
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 {
            Account.sharedAccount().logout({
                println("logged out")
                self.delegate?.didLogout()
            })
        }
        
        if indexPath.section == 1 {
            selectedIdx = indexPath.row
            performSegueWithIdentifier("ShowWebController", sender: self)
        }
        
    }
    
    func dismiss() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
