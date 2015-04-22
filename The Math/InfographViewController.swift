//
//  InfographViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/30/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class InfographViewController: GAITrackedViewController {
    
    @IBOutlet weak var graphContainer: UIView!
    var previouslySelectedSegmentIndex: Int = 1
    var viewControllers = [UIViewController]()
    var selectedViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewControllers()
        reloadState()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        screenName = "Infograph"
    }
    
    @IBAction func navigationControl(sender: UISegmentedControl) {
        println(sender.selectedSegmentIndex)
        previouslySelectedSegmentIndex = sender.selectedSegmentIndex
        navigateToViewController(previouslySelectedSegmentIndex)
    }
    
    private func reloadState() {
        navigateToViewController(previouslySelectedSegmentIndex)
    }
    
    private func navigateToViewController(index: Int) {
        if let viewController = selectedViewController {
            viewController.view.removeFromSuperview()
        }
        selectedViewController = viewControllers[index]
        graphContainer.addSubview(selectedViewController!.view)
        selectedViewController!.view.frame = graphContainer.bounds
        selectedViewController!.view.layoutIfNeeded()
    }
    
    private func loadViewControllers() {
        let dayViewController = DayInfoGraphViewController()
        let weekViewController = WeekInfoGraphViewController()
        let monthViewController = MonthInfoGraphViewController()
        viewControllers = [dayViewController, weekViewController, monthViewController]
    }

    
}
