//
//  CategorySelectionTableViewController.swift
//  The Math
//
//  Created by Mike Kavouras on 12/22/14.
//  Copyright (c) 2014 Mike Kavouras. All rights reserved.
//

import UIKit

let CellIdentifier = "CellIdentifier"

class CategorySelectionTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = "Mike"

        return cell
    }
    
    private func categories() -> [Category] {
        return [
            Category(type: CategoryType.Personal),
            Category(type: CategoryType.Lifestyle),
            Category(type: CategoryType.Money),
            Category(type: CategoryType.Health),
            Category(type: CategoryType.Work),
            Category(type: CategoryType.Love)
        ]
    }

}
