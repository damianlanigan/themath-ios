//
//  ChartViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ChartDelegate: class {
    func didSelectChartDateValue(value: AnyObject)
}

class ChartViewController: UIViewController,
    UIScrollViewDelegate,
    ChartDelegate {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: ChartDelegate?
    var editingScrollView = false
    var scope: CalendarScope = .Undefined
    
    var coordinators = [ChartViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPreviousChartView()
        for i in 0...1 {
            _performBlock({
                self.loadPreviousChartView()
            }, withDelay: 0.3)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentViewHeightConstraint.constant = view.frame.size.height
        contentViewWidthConstraint.constant = view.frame.size.width * CGFloat(coordinators.count)
        for (idx, coordinator) in enumerate(coordinators) {
            let v = coordinator.view
            v.frame = view.bounds
            v.frame.origin.x = view.bounds.size.width * CGFloat(idx)
        }
    }
    
    func becameActive() {
        println("became active: \(scope.rawValue)")
        for (idx, coordinator) in enumerate(coordinators) {
            coordinator.view.reloadData()
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
    }
    
    func becameInactive() {
        println("became inactive: \(scope.rawValue)")
    }
    
    private func loadPreviousChartView() {
        let coordinator = ChartViewModel(scope: scope)
        coordinator.date = previousDate()
        coordinator.delegate = self
        
        coordinators.unshift(coordinator)
        contentView.addSubview(coordinator.view)
        
        let p = scrollView.contentOffset
        
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        var newP = p
        newP.x += scrollView.frame.size.width
        scrollView.setContentOffset(newP, animated: false)
        
        editingScrollView = false
    }
    
    private func previousDate() -> NSDate {
        switch scope {
        case .Day:
            return NSDate().dateBySubtractingDays(coordinators.count).dateAdjustedForLocalTime()
        case .Week:
            return NSDate().dateBySubtractingDays(coordinators.count * 7).dateAdjustedForLocalTime()
        case .Month:
            if let m = coordinators.first?.dateValue as? CalendarMonth {
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
        if offsetX <= view.frame.size.width && !editingScrollView {
            editingScrollView = true
            loadPreviousChartView()
        } else if offsetX > totalWidth - view.frame.size.width && !editingScrollView {
//            println("load next date")
        }
    }
    
    func didSelectChartDateValue(value: AnyObject) {
        delegate?.didSelectChartDateValue(value)
    }
}
