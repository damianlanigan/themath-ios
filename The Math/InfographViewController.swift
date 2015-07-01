//
//  InfographViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/30/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class InfographViewController: UIViewController,
    ChartDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var graphContainer: UIView!
    var previouslySelectedSegmentIndex: Int = 0
    var viewControllers = [ChartViewController]()
    var selectedViewController: ChartViewController?
    var orientationLocked = false
    var entry: JournalEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViewControllers()
        reloadState()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        orientationLocked = false
    }
    
    @IBAction func navigationControl(sender: UISegmentedControl) {
        previouslySelectedSegmentIndex = sender.selectedSegmentIndex
        navigateToViewControllerAtIndex(previouslySelectedSegmentIndex)
    }
    
    private func reloadState() {
        navigateToViewControllerAtIndex(previouslySelectedSegmentIndex)
    }
    
    private func navigateToViewControllerAtIndex(index: Int) {
        if let viewController = selectedViewController {
            viewController.view.hidden = true
            viewController.becameInactive()
        }
        segmentedControl.selectedSegmentIndex = index
        selectedViewController = viewControllers[index]
        selectedViewController!.view.hidden = false
        selectedViewController!.becameActive()
        selectedViewController!.view.frame = graphContainer.bounds
        selectedViewController!.view.layoutIfNeeded()
    }
    
    private func loadViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let weekViewController = storyboard.instantiateViewControllerWithIdentifier("ChartViewController") as! ChartViewController
        weekViewController.scope = .Week
        let monthViewController = storyboard.instantiateViewControllerWithIdentifier("ChartViewController") as! ChartViewController
        monthViewController.scope = .Month
        viewControllers = [weekViewController, monthViewController]
        for viewController in viewControllers {
            viewController.delegate = self
            viewController.view.hidden = true
            graphContainer!.addSubview(viewController.view)
        }
    }
    
    // MARK: <ChartViewControllerDelegate>
    
    func didSelectChartDateValue(value: AnyObject) {
        if let value = value as? ChartDay {
            value.fetchChartableRepresentation({ (result) -> Void in
                let navigationController = UINavigationController()
                let tableViewController = UITableViewController()
                navigationController.viewControllers = [tableViewController]
                self.presentViewController(navigationController, animated: true, completion: nil)
            })
        }
    }
    
    func didSelectDay(day: ChartDay) {
        println("selected day: \(day)")
        // show all of the entries for that day
        // currently only pulling average score for 
        // the week so we'll need to do another request
    }
    
    func didSelectWeek(week: ChartWeek) {
        println("selected week: \(week)")
//        navigateToViewControllerAtIndex(1)
    }
    
    func didSelectHour(hour: ChartHour) {
        println("selected hour: \(hour)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ChartDetailViewController") as! ChartDetailViewController
        viewController.hour = hour
        
        let navigationController = UINavigationController()
        navigationController.viewControllers = [viewController]

        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    // MARK: Utility
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
}
