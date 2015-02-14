//
//  CategorySelectionTableViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 2/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol CategorySelectionTableViewControllerDelegate: class {
    func categorySelectionTableViewDidSelectCategory(viewController: CategorySelectionTableViewController, type: CategoryType)
}

class CategorySelectionTableViewController: UITableViewController {
    
    private let cellIdentifier = "CategoryCellIdentifier"
    private let categories = CategoryConstants.allCategoriesTypes
    
    var selected = [Int]()
    
    weak var delegate: CategorySelectionTableViewControllerDelegate?

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as CategorySelectionTableViewCell

        if let categoryIndex = CategoryIndex(rawValue: indexPath.row) {
            cell.categoryNameLabel.text = categoryIndex.categoryName()
            cell.categoryImageView.image = categoryIndex.categoryImage()
        }
        
        if let idx = find(selected, indexPath.row) {
            cell.checkmarkImageView.hidden = false
            cell.categoryImageView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.4).CGColor
        } else {
            cell.checkmarkImageView.hidden = true
            cell.categoryImageView.layer.borderColor = UIColor.blackColor().colorWithAlphaComponent(0.1).CGColor
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let categoryIndex = CategoryIndex(rawValue: indexPath.row) {
            let categoryType: CategoryType = categoryIndex.categoryType()
            delegate?.categorySelectionTableViewDidSelectCategory(self, type: categoryType)
            
            if let idx = find(selected, indexPath.row) {
                selected.removeAtIndex(idx)
            } else {
                selected.append(indexPath.row)
            }
            tableView.reloadData()
        }
    }
    
}
