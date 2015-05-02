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

class Week {
    
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
}

class ChartWeek: Week {
    var chartDays: [ChartDay] = [ChartDay]() {
        didSet {
            var _days = chartDays
            let dayAbbrsWithIndex = ["mon" : 1, "tue" : 2, "wed" : 3, "thu" : 4, "fri" : 5, "sat" : 6, "sun" : 7]
            let dayAbbrs = chartDays.map { $0.rawDate.shortWeekdayToString().lowercaseString }

            for abbr in dayAbbrsWithIndex.keys {
                if find(dayAbbrs, abbr) == nil {
                    println("\(dayAbbrs)")//, \(abbr)")
                    _days.append(ChartDay(mood: 0, timestamp: self.calendarDays.monday.rawDate.dateByAddingDays(dayAbbrsWithIndex[abbr]! - 1)))
                } else {
                    println("hey")
                }
            }
            _days.sort { [unowned self] in
                dayAbbrsWithIndex[$0.rawDate.shortWeekdayToString().lowercaseString]! <
                    dayAbbrsWithIndex[$1.rawDate.shortWeekdayToString().lowercaseString]!
            }
            chartDays = _days
            println(chartDays.map { $0.rawDate.shortWeekdayToString() })
        }
    }
}

class Day {
    
    let rawDate: NSDate!
    
    init(date: NSDate) {
        rawDate = date
    }
    
    func week() -> Week {
        return Week(date: rawDate)
    }
}

class ChartDay: Day {
    
    let averageMood: Int!
    
    init (mood: Int, timestamp: NSDate) {
        averageMood = mood
        super.init(date: timestamp)
    }
}


class ChartViewController: UIViewController {

    weak var delegate: ChartViewControllerDelegate?
    var selectedIdx: Int?
    var hasLaidOutChart = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayLatestData()
    }
    
    func fetchAndDisplayLatestData() {
        // abstract
    }

}
