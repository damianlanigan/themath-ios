//
//  Month.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 7/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class CalendarMonth: TimeRepresentable {
    
    let startDate: NSDate!
    let endDate: NSDate!
    let dayCount: Int!
    
    init(date: NSDate) {
        
        let calendar = NSCalendar.currentCalendar()
        let range = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: date)
        dayCount = range.length
        
        let components = calendar.components([.Year, .Month], fromDate: date)
        components.setValue(1, forComponent: .Day)
        
        startDate = calendar.dateFromComponents(components)
        endDate = startDate.dateByAddingDays(dayCount - 1)
    }
    
    func previous() -> CalendarMonth {
        let components = NSCalendar.currentCalendar().components([.Year, .Month], fromDate: startDate)
        components.setValue(components.month + 1, forComponent: .Month)
        return CalendarMonth(date: NSCalendar.currentCalendar().dateFromComponents(components)!)
    }
    
    func next() -> CalendarMonth {
        let components = NSCalendar.currentCalendar().components([.Year, .Month], fromDate: startDate)
        components.setValue(components.month - 1, forComponent: .Month)
        return CalendarMonth(date: NSCalendar.currentCalendar().dateFromComponents(components)!)
    }
    
    func formattedDescription() -> String {
        return "\(startDate.monthToString()), \(startDate.year(0))"
    }
    
    var params: [String: AnyObject] {
        return [
            "start_date" : startDate.dateAtStartOfDay(),
            "end_date" : endDate.dateAtEndOfDay(),
            "timezone_offset" : (NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60)
        ]
    }
    
    func fetchChartableRepresentation(completion: (result: Chartable) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
//            request(Router.AverageScore(params)).responseJSON { (request, response, data, error) in
//                if let data = data as? Array<Dictionary<String,Int>> {
//                    
//                    var days = [ChartDay]()
//                    for d in data {
//                        for (date, score) in d {
//                            let comps = NSDateComponents()
//                            let parts = split(date) { $0 == "-" }
//                            comps.setValue(parts[0].toInt()!, forComponent: .CalendarUnitYear)
//                            comps.setValue(parts[1].toInt()!, forComponent: .CalendarUnitMonth)
//                            comps.setValue(parts[2].toInt()!, forComponent: .CalendarUnitDay)
//                            let timestamp = NSCalendar.currentCalendar().dateFromComponents(comps)!
//                            
//                            let before = timestamp.compare(self.startDate) == NSComparisonResult.OrderedAscending
//                            let after = timestamp.compare(self.endDate) == NSComparisonResult.OrderedDescending
//                            if before || after {
//                                continue
//                            }
//                            let day = ChartDay(date: timestamp, score: score)
//                            days.append(day)
//                        }
//                    }
//                
//                    
//                    let chartable = ChartMonth(date: self.startDate)
//                    chartable.days = days
//                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        completion(result: chartable)
//                    })
//                }
//            }
        })
    }
}

class ChartMonth: CalendarMonth, Chartable {
    
    var days: [ChartDay] = [ChartDay]() {
        didSet {
            padMonth()
        }
    }
    
    private func padMonth() {
        let dates = days.map { $0.rawDate.withoutTime() }
        
        var _days = days
        
        for i in 0..<dayCount {
            let d = startDate.dateByAddingDays(i).withoutTime()
            if dates.indexOf(d) > 0 {
                _days.append(ChartDay(date: d, score: ChartDayMinimumDayAverage))
            }
        }
        
        if _days.count != days.count {
            days = _days
            days.sortInPlace({
                $0.rawDate.compare($1.rawDate) == NSComparisonResult.OrderedAscending
            })
        }
    }
    
    // MARK: Chartable
    
    var values: [AnyObject] {
        return days
    }
    
    func barPadding() -> CGFloat {
        return 4.0
    }
    
    func viewAtIndex(index: Int) -> UIView {
        let view = NSBundle.mainBundle().loadNibNamed("BarView", owner: nil, options: nil)[0] as! BarView
        view.barContainer.backgroundColor = UIColor.moodColorAtPercentage(CGFloat(days[index].score) / 100)
        return view
    }
    
    func valueAtIndex(index: Int) -> CGFloat {
        return CGFloat(days[index].score)
    }
    
    func hasValueAtIndex(index: Int) -> Bool {
        return days[index].score > 0
    }
    
}
