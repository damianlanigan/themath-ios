//
//  CategorySelectionViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 2/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol CategorySelectionViewControllerDelegate: class {
    func categorySelectionViewDidFinishSelectingCategories(categories: [CategoryType])
}

class CategorySelectionViewController: UIViewController, CategorySelectionTableViewControllerDelegate {

    @IBOutlet weak var contentContainerView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var getStartedButtonHeightConstraint: NSLayoutConstraint!
    
    var selectedCategories = [CategoryType]()
    
    weak var delegate: CategorySelectionViewControllerDelegate?
    
    var laid = false

    override func viewDidLayoutSubviews() {
        if !laid {
            laid = true
            loadCategorySelectionTableView()
        }
    }
    
    @IBAction func getStartedButtonTapped(sender: AnyObject) {
        CategoryCoordinator.sharedInstance().updateCategories(selectedCategories)
        delegate?.categorySelectionViewDidFinishSelectingCategories(selectedCategories)
    }
    
    func loadCategorySelectionTableView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("CategorySelectionTable") as? CategorySelectionTableViewController
        viewController?.delegate = self
        _addContentViewController(viewController!, toView: contentContainerView)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: <CategorySelectionTableViewControllerDelegate>
    
    func categorySelectionTableViewDidSelectCategory(viewController: CategorySelectionTableViewController, type: CategoryType) {
        if let idx = find(selectedCategories, type) {
            selectedCategories.removeAtIndex(idx)
            Tracker.track("category", action: "delected", label: type.rawValue)
        } else {
            selectedCategories.append(type)
            Tracker.track("category", action: "selected", label: type.rawValue)
        }
        
        getStartedButton.hidden = selectedCategories.count == 0
        viewController.tableView.contentInset.bottom = 50
    }

}
