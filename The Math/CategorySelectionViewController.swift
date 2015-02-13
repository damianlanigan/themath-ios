//
//  CategorySelectionViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 2/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol CategorySelectionViewControllerDelegate {
    func categorySelectionViewDidFinishSelectingCategories(categories: [CategoryType])
}

class CategorySelectionViewController: UIViewController, CategorySelectionTableViewControllerDelegate {

    @IBOutlet weak var contentContainerView: UIView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBOutlet weak var getStartedButtonHeightConstraint: NSLayoutConstraint!
    
    var selectedCategories = [CategoryType]()
    
    var delegate: CategorySelectionViewControllerDelegate?
    
    var laid = false

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadCategorySelectionTableView()
        formatHeaderView()
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
    
    func formatHeaderView() {
        headerView.layer.shadowColor = UIColor.blackColor().CGColor
        headerView.layer.shadowOpacity = 0.1
        headerView.layer.shadowOffset = CGSizeMake(0.0, 1.0)
        headerView.layer.shadowRadius = 2.0
        view.bringSubviewToFront(headerView)
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: <CategorySelectionTableViewControllerDelegate>
    
    func categorySelectionTableViewDidSelectCategory(viewController: CategorySelectionTableViewController, type: CategoryType) {
        if let idx = find(selectedCategories, type) {
            selectedCategories.removeAtIndex(idx)
            Tracker.trackCategoryDeselected(type)
        } else {
            selectedCategories.append(type)
            Tracker.trackCategorySelected(type)
        }
        
        getStartedButton.hidden = selectedCategories.count == 0
//        getStartedButtonHeightConstraint.constant = getStartedButton.hidden ? 0 : 49
        viewController.tableView.contentInset.bottom = 49
//        viewController.tableView.contentOffset.y = getStartedButton.hidden ? viewController.tableView.contentOffset.y : viewController.tableView.contentOffset.y - 49
    }

}
