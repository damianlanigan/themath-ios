//
//  CategorySelectionTableViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 2/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class CategorySelectionTableViewController: UITableViewController {
    
    private let cellIdentifier = "CategoryCellIdentifier"
    private let categories = CategoryConstants.allCategories


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CategorySelectionTableViewCell

        cell.categoryNameLabel.text = categories[indexPath.row]

        return cell
    }
}
