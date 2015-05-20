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
    var previouslySelectedSegmentIndex: Int = 1
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
        let dayViewController = storyboard.instantiateViewControllerWithIdentifier("ChartViewController") as! ChartViewController
        dayViewController.scope = .Day
        let weekViewController = storyboard.instantiateViewControllerWithIdentifier("ChartViewController") as! ChartViewController
        weekViewController.scope = .Week
        let monthViewController = storyboard.instantiateViewControllerWithIdentifier("ChartViewController") as! ChartViewController
        monthViewController.scope = .Month
        viewControllers = [dayViewController, weekViewController, monthViewController]
        for viewController in viewControllers {
            viewController.delegate = self
            viewController.view.hidden = true
            graphContainer!.addSubview(viewController.view)
        }
    }
    
    // MARK: <ChartViewControllerDelegate>
    
    func didSelectDay(day: Int) {
        println("selected day: \(day)")
        navigateToViewControllerAtIndex(0)
    }
    
    func didSelectWeek(week: Int) {
        println("selected week: \(week)")
        navigateToViewControllerAtIndex(1)
    }
    
    func didSelectHour(hour: ChartHour) {
        println("selected hour: \(hour)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ChartDetailViewController") as! ChartDetailViewController
        viewController.hour = hour
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    // MARK: Utility
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
}
