//
//  Chartable.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation

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
            days.sort({
                $0.rawDate.compare($1.rawDate) == NSComparisonResult.OrderedAscending
            })
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


let ChartDayMinimumDayAverage = 0
class ChartDay: Day, Chartable {
    
    let score: Int!
    
    var entries = [JournalEntry]() {
        didSet {
            padDay()
        }
    }
    
    var hours = [ChartHour]()
    
    lazy var color: UIColor = {
        return UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: CGFloat(self.score) / 100.0)
    }()
    
    init(date: NSDate, score: Int) {
        self.score = score
        super.init(date: date)
    }
    
    private func padDay() {
       // 0...23 [count: Int, score: Int]
        
        var chartHours = [ChartHour]()
        let groupedByHour = entries.groupBy { $0.timestamp.hour(offset: 0) }
        for (key, value) in groupedByHour {
            let h = ChartHour()
            h.entries = value
            h.hour = key
            chartHours.append(h)
        }
        
        var hours = chartHours.map { $0.hour }
        for i in 0..<25 {
            if find(hours, i) == nil {
                
                let j = JournalEntry()
                j.score = ChartDayMinimumDayAverage
                let c = NSCalendar.currentCalendar().components(.CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay, fromDate: rawDate)
                c.setValue(i, forComponent: .CalendarUnitHour)
                j.timestamp = NSCalendar.currentCalendar().dateFromComponents(c)
                j.userGenerated = false
                
                let h = ChartHour()
                h.hour = i
                h.entries = [j]
                chartHours.append(h)
            }
        }
        
        
        if self.hours.count != chartHours.count {
            self.hours = chartHours
            self.hours.sort({
                $0.hour < $1.hour
            })
        }
        
    }
    
}

class ChartHour {
    var hour: Int = 0
    var entries = [JournalEntry]()
    var score: Int {
        // TODO: potentially slow
        if self.entries.count == 0 {
            return 0
        }
        return self.entries.map { $0.score }.reduce(0, combine: +) / self.entries.count
    }
}
