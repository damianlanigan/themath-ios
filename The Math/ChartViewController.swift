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
    
    let length: Int!
    let firstDay: NSDate!
    let lastDay: NSDate!
    
    init(date: NSDate) {
        
        let c = NSCalendar.currentCalendar()
        let range = c.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: date)

        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let components = calendar!.components(.CalendarUnitEra | NSCalendarUnit.CalendarUnitYear | .CalendarUnitMonth, fromDate: NSDate())
        components.day = 1;
        
        firstDay = calendar!.dateFromComponents(components)
        lastDay = firstDay.dateByAddingDays(range.length)
        length = range.length
    }
    
    func formattedDescription() -> String {
        return "\(firstDay.monthToString()), \(firstDay.year(offset: 0))"
    }
}

class ChartMonth: Month, Chartable {
    var chartDays: [ChartDay] = [ChartDay]() {
        didSet {
//            var _days = chartDays
//            let dayAbbrsWithIndex = ["mon" : 1, "tue" : 2, "wed" : 3, "thu" : 4, "fri" : 5, "sat" : 6, "sun" : 7]
//            let dayAbbrs = chartDays.map { $0.rawDate.shortWeekdayToString().lowercaseString }
//            
//            for abbr in dayAbbrsWithIndex.keys {
//                if find(dayAbbrs, abbr) == nil {
//                    _days.append(ChartDay(mood: 0, timestamp: self.calendarDays.monday.rawDate.dateByAddingDays(dayAbbrsWithIndex[abbr]! - 1)))
//                }
//            }
//            _days.sort { [unowned self] in
//                dayAbbrsWithIndex[$0.rawDate.shortWeekdayToString().lowercaseString]! <
//                    dayAbbrsWithIndex[$1.rawDate.shortWeekdayToString().lowercaseString]!
//            }
//            chartDays = _days
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
        let allDays = [
            "mon" : calendarDays.monday.rawDate,
            "tue" : calendarDays.tuesday.rawDate,
            "wed" : calendarDays.wednesday.rawDate,
            "thu" : calendarDays.thursday.rawDate,
            "fri" : calendarDays.friday.rawDate,
            "sat" : calendarDays.saturday.rawDate,
            "sun" : calendarDays.sunday.rawDate
        ]
        
        var pad = [ChartDay]()
        
        var have = days.map { $0.rawDate.shortWeekdayToString().lowercaseString }
        
        let dayShorts = Array(allDays.keys)
        
        var _days = days
        
        for short in dayShorts {
            if find(have, short) == nil {
                _days.append(ChartDay(date: (allDays[short]! as NSDate), score: ChartDayMinimumDayAverage))
            }
        }
        
        if _days.count != days.count {
            days = _days
            days.sort({
                $0.rawDate.compare($1.rawDate) == NSComparisonResult.OrderedAscending
            })
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
        let idx = nextIdx()
        let coordinator = ChartViewModel(scope: scope)
        coordinator.date = NSDate().dateBySubtractingDays(idx).dateAdjustedForLocalTime()
        coordinator.offset = idx
        coordinators.append(coordinator)
        contentView.addSubview(coordinator.view)
        
        ensureContentSize()
        
        editingScrollView = false
    }
    
    private func nextIdx() -> Int {
        switch scope {
        case .Day:
            return coordinators.count
        case .Week:
            return coordinators.count * 7
        default:
            return 0
        }
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
