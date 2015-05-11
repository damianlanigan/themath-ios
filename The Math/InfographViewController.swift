//
//  InfographViewController.swift
//  The Math
//
//  Created by Michael Kavouras on 1/30/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class InfographViewController: UIViewController,
    ChartViewControllerDelegate {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var graphContainer: UIView!
    var previouslySelectedSegmentIndex: Int = 1
    var viewControllers = [ChartViewController]()
    var selectedViewController: UIViewController?
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
        println(sender.selectedSegmentIndex)
        previouslySelectedSegmentIndex = sender.selectedSegmentIndex
        navigateToViewControllerAtIndex(previouslySelectedSegmentIndex)
    }
    
    private func reloadState() {
        navigateToViewControllerAtIndex(previouslySelectedSegmentIndex)
    }
    
    private func navigateToViewControllerAtIndex(index: Int) {
        if let viewController = selectedViewController {
            viewController.view.hidden = true
        }
        segmentedControl.selectedSegmentIndex = index
        selectedViewController = viewControllers[index]
        selectedViewController!.view.hidden = false
        selectedViewController!.viewDidAppear(false)
        selectedViewController!.view.frame = graphContainer.bounds
        selectedViewController!.view.layoutIfNeeded()
    }
    
    private func loadViewControllers() {
        let dayViewController = DayChartViewController()
        let weekViewController = WeekChartViewController()
        let monthViewController = MonthChartViewController()
        viewControllers = [dayViewController, weekViewController, monthViewController]
        for viewController in viewControllers {
            viewController.delegate = self
            viewController.view.hidden = true
            graphContainer!.addSubview(viewController.view)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("preparing")
        if let navController = segue.destinationViewController as? UINavigationController {
            if let viewController = navController.viewControllers[0] as? DayChartDetailTableViewController {
                println("happenin")
                viewController.entry = entry!
            }
        }
    }
    
    // MARK: <ChartViewControllerDelegate>
    
    func didSelectMoment(entry: JournalEntry) {
        orientationLocked = true
        self.entry = entry
        performSegueWithIdentifier("PresentDayDetail", sender: self)
    }
    
    func didSelectDay(day: Int) {
        println("Day selected: \(day)")
        navigateToViewControllerAtIndex(0)
    }
    
    func didSelectWeek(week: Int) {
        println("Week selected: \(week)")
        navigateToViewControllerAtIndex(1)
    }
    
    // MARK: Utility
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
}
