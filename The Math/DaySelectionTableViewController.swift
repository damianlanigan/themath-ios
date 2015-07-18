
//  DaySelectionTableViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 7/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class DaySelectionTableViewController: UITableViewController {
    
    private let CellIdentifier = "DayDetailPreviewCellIdentifier"
    
    var day: ChartDay?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerNib(UINib(nibName: "DayDetailPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: CellIdentifier)
        tableView.rowHeight = 60.0
        tableView.estimatedRowHeight = 60.0
        
        if let day = day {
            navigationItem.title = day.formattedDescription()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
    }
    
    func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let day = day {
            return day.entries.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! DayDetailPreviewTableViewCell

        if let day = day {
            let entry = day.entries[indexPath.row]
            
            cell.timestampLabel.text = entry.formattedTimestamp
            cell.score = day.score
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let day = day {
            let viewController = ChartDetailViewController()
            viewController.entry = day.entries[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
