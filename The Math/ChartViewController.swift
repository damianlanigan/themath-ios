//
//  ChartViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ChartViewControllerDelegate: class {
    func didSelectMoment()
    func didSelectDay(day: Int)
    func didSelectWeek(week: Int)
}

protocol Chartable {
    
}

enum ChartTimeRange {
    case Month
    case Week
    case Day
    case Undefined
}

class Month {
    
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
}

class ChartMonth: Month {
    var chartDays: [ChartDay] = [ChartDay]() {
        didSet {
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

class Week {
    
    let calendarDays: CalendarWeekDays
    
    init(date: NSDate) {
        
        let num = date.weekday() == 1 ? 7 : date.weekday() - 1
        let start = date.dateBySubtractingDays(num - 1)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: start)
        let beginning = calendar.dateFromComponents(components)!
        
        calendarDays = (
            Day(date: beginning),
            Day(date: beginning.dateByAddingDays(1)),
            Day(date: beginning.dateByAddingDays(2)),
            Day(date: beginning.dateByAddingDays(3)),
            Day(date: beginning.dateByAddingDays(4)),
            Day(date: beginning.dateByAddingDays(5)),
            Day(date: beginning.dateByAddingDays(6))
        )
        
    }
}

class ChartWeek: Week {
    var days: [ChartDay] = [ChartDay]() {
        didSet {
            padWeek()
        }
    }
    
    private func padWeek() {
        var have = days.map { $0.short }
        var allDays = [Day]()
        let mirror = reflect(calendarDays)
        for i in 0..<mirror.count {
            allDays.append(mirror[i].1.value as! Day)
        }
        
        var _days = days
        
        for day in allDays {
            if find(have, day.short) == nil {
                _days.append(ChartDay(date: day.rawDate, score: 0))
            }
        }
        
        if days.count != _days.count {
            days = _days
            days.sort({
                $0.rawDate.compare($1.rawDate) == NSComparisonResult.OrderedAscending
            })
        }
    }
}

class Day {
    
    let rawDate: NSDate!
    
    var short: String {
        return rawDate.shortWeekdayToString().lowercaseString
    }
    
    var floor: NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: rawDate)
        components.setValue(0, forComponent: NSCalendarUnit.CalendarUnitHour)
        let beginning = calendar.dateFromComponents(components)!
        return beginning
    }
    
    init(date: NSDate) {
        rawDate = date
    }
    
    func week() -> Week {
        return Week(date: rawDate)
    }
    
}

class ChartDay: Day, Chartable {
    
    let score: Int!
    var entries = [JournalEntry]()

    init(date: NSDate, score: Int) {
        self.score = score
        super.init(date: date)
    }
}


class ChartViewController: UIViewController {

    weak var delegate: ChartViewControllerDelegate?
    var selectedIdx: Int?
    var hasLaidOutChart = false
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fetchAndDisplayLatestData()
    }
    
    func fetchAndDisplayLatestData() {
        // abstract
    }
    
    func chartType() -> ChartType {
        // abstract
        return .Undefined
    }

}
