//
//  Week.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 7/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation

class CalendarWeek: TimeRepresentable {
    
    let calendarDays: CalendarWeekDays
    
    init(date: NSDate) {
        
        let num = date.weekday() == 1 ? 7 : date.weekday() - 1
        let start = date.dateBySubtractingDays(num - 1)
        
        calendarDays = (
            CalendarDay(date: start),
            CalendarDay(date: start.dateByAddingDays(1)),
            CalendarDay(date: start.dateByAddingDays(2)),
            CalendarDay(date: start.dateByAddingDays(3)),
            CalendarDay(date: start.dateByAddingDays(4)),
            CalendarDay(date: start.dateByAddingDays(5)),
            CalendarDay(date: start.dateByAddingDays(6))
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
    
    var params: [String: AnyObject]  {
        let monday = calendarDays.monday.rawDate.dateAtStartOfDay()
        return [
            "start_date" : monday,
            "end_date" : monday.dateAtEndOfWeek().dateAtEndOfDay(),
            "timezone_offset" : (NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60)
        ]
    }
    
    
    func fetchChartableRepresentation(completion: (result: Chartable) -> Void) {
        request(Router.AverageScore(params)).responseJSON { (request, response, data, error) in
            if let data = data as? Array<Dictionary<String,Int>> {
                let chartable = ChartWeek(date: self.calendarDays.monday.rawDate)
                
                var days = [ChartDay]()
                for d in data {
                    for (date, score) in d {
                        let comps = NSDateComponents()
                        let parts = split(date) { $0 == "-" }
                        comps.setValue(parts[0].toInt()!, forComponent: .CalendarUnitYear)
                        comps.setValue(parts[1].toInt()!, forComponent: .CalendarUnitMonth)
                        comps.setValue(parts[2].toInt()!, forComponent: .CalendarUnitDay)
                        let timestamp = NSCalendar.currentCalendar().dateFromComponents(comps)!
                        let day = ChartDay(date: timestamp, score: score)
                        days.append(day)
                    }
                }

                chartable.days = days
                
                completion(result: chartable)
            }
        }
    }
}

class ChartWeek: CalendarWeek, Chartable {
    var values: [AnyObject] {
        return days
    }
    
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
    
    // MARK: Chartable
    
    func barPadding() -> CGFloat {
        return 30.0
    }
    
    func viewAtIndex(index: Int) -> UIView {
        let view = NSBundle.mainBundle().loadNibNamed("BarView", owner: nil, options: nil)[0] as! BarView
        let perc = CGFloat(days[index].score) / 100.0
        view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
        return view
    }
    
    func valueAtIndex(index: Int) -> CGFloat {
        return CGFloat(days[index].score)
    }
    
    func hasValueAtIndex(index: Int) -> Bool {
        return days[index].score > 0
    }
}
