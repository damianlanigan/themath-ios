//
//  ChartViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol TimeRepresentable {
    func formattedDescription() -> String
}

protocol Chartable {
    
}

enum CalendarScope: Int {
    case Undefined
    case Day
    case Week
    case Month
}

class Month: TimeRepresentable {
    
    let startDate: NSDate!
    let endDate: NSDate!
    let dayCount: Int!
    
    init(date: NSDate) {
        
        let calendar = NSCalendar.currentCalendar()
        let range = calendar.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: date)
        dayCount = range.length
        
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        components.setValue(1, forComponent: .CalendarUnitDay)
        
        startDate = calendar.dateFromComponents(components)
        endDate = startDate.dateByAddingDays(dayCount - 1)
    }
    
    func previous() -> Month {
        let components = NSCalendar.currentCalendar().components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: startDate)
        components.setValue(components.month + 1, forComponent: .CalendarUnitMonth)
        let month = Month(date: NSCalendar.currentCalendar().dateFromComponents(components)!)
        return month
    }
    
    func next() -> Month {
        let components = NSCalendar.currentCalendar().components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: startDate)
        components.setValue(components.month - 1, forComponent: .CalendarUnitMonth)
        let month = Month(date: NSCalendar.currentCalendar().dateFromComponents(components)!)
        return month
    }
    
    func formattedDescription() -> String {
        return "\(startDate.monthToString()), \(startDate.year(offset: 0))"
    }
}

class ChartMonth: Month, Chartable {
    
    var days: [ChartDay] = [ChartDay]() {
        didSet {
            padMonth()
        }
    }
    
    private func padMonth() {
        let calendar = NSCalendar.currentCalendar()
        let dates = days.map { $0.rawDate.withoutTime() }
        
        var _days = days
        
        for i in 0..<dayCount {
            let d = startDate.dateByAddingDays(i).withoutTime()
            if find(dates, d) == nil {
                _days.append(ChartDay(date: d, score: ChartDayMinimumDayAverage))
            }
        }
        
        if _days.count != days.count {
            days = _days
        }
    }
    
}

typealias CalendarWeekDays = (
    monday: Day,
    tuesday: Day,
    wednesday: Day,
    thursday: Day,
    friday: Day,
    saturday: Day,
    sunday: Day
)

class Week: TimeRepresentable {
    
    let calendarDays: CalendarWeekDays
    
    init(date: NSDate) {
        
        let num = date.weekday() == 1 ? 7 : date.weekday() - 1
        let start = date.dateBySubtractingDays(num - 1)
        
        calendarDays = (
            Day(date: start),
            Day(date: start.dateByAddingDays(1)),
            Day(date: start.dateByAddingDays(2)),
            Day(date: start.dateByAddingDays(3)),
            Day(date: start.dateByAddingDays(4)),
            Day(date: start.dateByAddingDays(5)),
            Day(date: start.dateByAddingDays(6))
        )
    }
    
    // date is already adjusted for local timezone
    func contains(date: NSDate) -> Bool {
        return calendarDays.sunday.rawDate.dateAtEndOfDay().compare(date) == .OrderedDescending
    }
    
    func formattedDescription() -> String {
        let monday = calendarDays.monday.rawDate.dateAdjustedForLocalTime().dateAtStartOfDay()
        let sunday = calendarDays.sunday.rawDate.dateAdjustedForLocalTime().dateAtStartOfDay()
        let startMonth = monday.month(offset: 0)
        let endMonth = sunday.month(offset: 0)
        if startMonth == endMonth {
            return "\(monday.shortMonthToString()) \(monday.day(offset: 0)) - \(sunday.day(offset:0)), \(monday.year(offset: 0))"
        } else {
            return "\(monday.shortMonthToString()) \(monday.day(offset: 0)) - \(sunday.shortMonthToString()) \(sunday.day(offset: 0)), \(sunday.year(offset: 0))"
        }
    }
}

class ChartWeek: Week, Chartable {
    var days: [ChartDay] = [ChartDay]() {
        didSet {
            padWeek()
        }
    }
    
    private func padWeek() {
        let calendar = NSCalendar.currentCalendar()
        let dates = days.map { $0.rawDate.withoutTime() }
        
        var _days = days
        
        for i in 0..<7 {
            let d = calendarDays.monday.rawDate.dateByAddingDays(i).withoutTime()
            if find(dates, d) == nil {
                _days.append(ChartDay(date: d, score: ChartDayMinimumDayAverage))
            }
        }
        
        if _days.count != days.count {
            days = _days
        }
    }
}

class Day: TimeRepresentable {
    
    let rawDate: NSDate!
    
    init(date: NSDate) {
        rawDate = date
    }
    
    func week() -> Week {
        return Week(date: rawDate)
    }
    
    func formattedDescription() -> String {
        return "\(rawDate.shortMonthToString()) \(rawDate.day(offset: 0)), \(rawDate.year(offset: 0))"
    }
}


let ChartDayMinimumDayAverage = 2
class ChartDay: Day, Chartable {
    let score: Int!
    var entries = [JournalEntry]()
    
    init(date: NSDate, score: Int) {
        self.score = score
        super.init(date: date)
    }
}

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
