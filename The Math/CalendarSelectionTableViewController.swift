//
//  CalendarSelectionTableViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import EventKit

class CalendarSelectionTableViewController: UITableViewController {
    
    private let CellIdentifier = "CalendarSelectionCell"
    
    var calendars: [String: [EKCalendar]] {
        return CalendarCoordinator.allCalendars().groupBy(groupingFunction: { $0.source.title })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CalendarCoordinator.authorizationNotDetermined() {
            CalendarCoordinator.sharedCoordinator.requestAuthorization({ (granted: Bool) -> Void in
                if granted {
                    self.tableView.reloadData()
                }
            })
        }
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(calendars.keys)[section]
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Array(calendars.keys).count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(calendars.keys)[section]
        return calendars[key]!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        let key = Array(calendars.keys)[indexPath.section]
        cell.textLabel?.text = calendars[key]![indexPath.row].title

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let key = Array(calendars.keys)[indexPath.section]
        let calendar = calendars[key]![indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        println(calendar.title)
    }
}
