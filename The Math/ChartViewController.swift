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


class Day {
    
    let rawDate: NSDate!
    
    var floor: NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: rawDate)
        let beginning = calendar.dateFromComponents(components)!
        return beginning
    }
    
    var ceil: NSDate {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let components = calendar.components(NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitYear, fromDate: rawDate)
        let offset = 0 // (nstimezone.localtimezone().secondsfromgmt / 60 / 60)
        components.setValue(23 + offset, forComponent: NSCalendarUnit.CalendarUnitHour)
        components.setValue(59, forComponent: NSCalendarUnit.CalendarUnitMinute)
        components.setValue(59, forComponent: NSCalendarUnit.CalendarUnitSecond)
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

class ChartWeek: Week {
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
        println(days.map { $0.rawDate })
//        var have = days.map { $0.short }
//        var allDays = [Day]()
//        let mirror = reflect(calendarDays)
//        for i in 0..<mirror.count {
//            allDays.append(mirror[i].1.value as! Day)
//        }
//        
//        var _days = days
//        
//        for day in allDays {
//            if find(have, day.short) == nil {
//                _days.append(ChartDay(date: day.rawDate, score: 0))
//            }
//        }
//        
//        if days.count != _days.count {
//            days = _days
//            days.sort({
//                $0.rawDate.compare($1.rawDate) == NSComparisonResult.OrderedAscending
//            })
//        }
    }
}

class ChartDay: Day {
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
    
    
    func fetchAndDisplayLatestData() {
        // abstract
    }
    
    func makeActive() {
        fetchAndDisplayLatestData()
    }

}
