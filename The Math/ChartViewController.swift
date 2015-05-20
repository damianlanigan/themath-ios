//
//  ChartViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ChartViewControllerDelegate: class {
    func didSelectMoment(entry: JournalEntry)
    func didSelectDay(day: Int)
    func didSelectWeek(week: Int)
}

class ChartViewController: UIViewController,
    UIScrollViewDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: ChartViewControllerDelegate?
    var editingScrollView = false
    var scope: CalendarScope = .Undefined
    
    var coordinators = [ChartViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 0...2 {
            loadNextChartView()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.delegate = self
        scrollView.transform = CGAffineTransformMakeScale(-1.0, 1.0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ensureContentSize()
        
        // kinda shitty but fixes some sizing issues
        // also slow
        for (idx, coordinator) in enumerate(self.coordinators) {
            coordinator.view.setNeedsLayout()
            coordinator.view.layoutIfNeeded()
            coordinator.view.reloadData()
        }
    }
    
    func becameActive() {
        println("became active: \(scope.rawValue)")
    }
    
    func becameInactive() {
        println("became inactive: \(scope.rawValue)")
    }
    
    private func ensureContentSize() {
        contentViewHeightConstraint.constant = view.frame.size.height
        contentViewWidthConstraint.constant = view.frame.size.width * CGFloat(coordinators.count)
        for (idx, coordinator) in enumerate(coordinators) {
            let v = coordinator.view
            v.frame = view.bounds
            v.frame.origin.x = view.bounds.size.width * CGFloat(idx)
        }
    }
    
    private func loadNextChartView() {
        let coordinator = ChartViewModel(scope: scope)
        coordinator.date = nextDate()
        coordinators.append(coordinator)
        contentView.addSubview(coordinator.view)
        
        ensureContentSize()
        
        editingScrollView = false
    }
    
    private func nextDate() -> NSDate {
        switch scope {
        case .Day:
            return NSDate().dateBySubtractingDays(coordinators.count).dateAdjustedForLocalTime()
        case .Week:
            return NSDate().dateBySubtractingDays(coordinators.count * 7).dateAdjustedForLocalTime()
        case .Month:
            if let m = coordinators.last?.dateValue as? Month {
                return m.startDate.dateBySubtractingDays(1)
            }
        default:
            return NSDate()
        }
        return NSDate()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let totalWidth = CGFloat(coordinators.count - 1) * view.frame.size.width
        let offsetX = scrollView.contentOffset.x
        if offsetX > totalWidth - view.frame.size.width && !editingScrollView {
            editingScrollView = true
            loadNextChartView()
        }
    }
}
