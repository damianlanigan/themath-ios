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
        
        loadNextChartView()
        for i in 0...2 {
            _performBlock({
                self.loadNextChartView()
            }, withDelay: 0.1)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.delegate = self
//        scrollView.transform = CGAffineTransformMakeScale(-1.0, 1.0)
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
    }
    
    func becameInactive() {
        println("became inactive: \(scope.rawValue)")
    }
    
    private func loadNextChartView() {
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
            if let m = coordinators.last?.dateValue as? CalendarMonth {
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
        if offsetX < view.frame.size.width && !editingScrollView {
//        if offsetX > totalWidth - view.frame.size.width && !editingScrollView {
            editingScrollView = true
            loadNextChartView()
        }
    }
    
    func didSelectChartDateValue(value: AnyObject) {
        delegate?.didSelectChartDateValue(value)
    }
}
