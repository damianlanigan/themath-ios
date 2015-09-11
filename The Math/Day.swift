//
//  Day.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 7/1/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import ExSwift

extension Array {
    func groupBy <U> (groupingFunction group: (Element) -> U) -> [U: Array] {
        
        var result = [U: Array]()
        
        for item in self {
            
            let groupKey = group(item)
            
            // If element has already been added to dictionary, append to it. If not, create one.
            if result[groupKey] != nil {
                result[groupKey]! += [item]
            } else {
                result[groupKey] = [item]
            }
        }
        
        return result
    }
}

class CalendarDay: TimeRepresentable {
    
    let rawDate: NSDate!
    
    init(date: NSDate) {
        rawDate = date
    }
    
    func week() -> CalendarWeek {
        return CalendarWeek(date: rawDate)
    }
    
    func formattedDescription() -> String {
        return "\(rawDate.shortMonthToString()) \(rawDate.day(0)), \(rawDate.year(0))"
    }
    
    func formattedDescriptionWithWeekday() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        let weekday = formatter.stringFromDate(rawDate)
        return "\(weekday) • \(formattedDescription())"
    }
    
    var params: [String: AnyObject] {
        return [
            "start_datetime" : rawDate.dateAtStartOfDay(),
            "end_datetime" : rawDate.dateAtEndOfDay(),
            "timezone_offset" : (NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60)
        ]
    }
    
    func fetchChartableRepresentation(completion: (result: Chartable) -> Void) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            request(Router.JournalEntries(params)).responseJSON(completionHandler: { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
                
            })
            
//            request(Router.JournalEntries(params)).responseJSON { (request, response, data, error) in
//                if let data = data as? Array<Dictionary<String,AnyObject>> {
//                    let chartable = ChartDay(date: self.rawDate)
//                    var entries: [JournalEntry] = [JournalEntry]()
//                    for d in data {
//                        let entry = JournalEntry.fromJSONRequest(d)
//                        entries.insert(entry, atIndex: 0)
//                    }
//                    chartable.entries = entries
//                    
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        completion(result: chartable)
//                    })
//                }
//            }
        })
    }
}


let ChartDayMinimumDayAverage = 0
class ChartDay: CalendarDay, Chartable {
    
    // cache
    private var _score: Int!
    var score: Int {
        if _score == nil {
            let scores: [Int] = self.entries.map { $0.score }
            let sum = scores.reduce(0, combine: +)
            return self.entries.count > 0 ? sum / self.entries.count : ChartDayMinimumDayAverage
        }
        return _score
    }
    
    var hours = [ChartHour]()
    
    var entries = [JournalEntry]() {
        didSet { padDay() }
    }
    
    lazy var color: UIColor = {
        return UIColor.moodColorAtPercentage(CGFloat(self.score) / 100.0)
    }()
    
    convenience init(date: NSDate, score: Int) {
        self.init(date: date)
        _score = score
    }
    
    private func padDay() {
       // 0...23 [count: Int, score: Int]
        
        var chartHours = [ChartHour]()
        let groupedByHour = entries.groupBy { $0.timestamp.hour(0) }
        for (key, value) in groupedByHour {
            let h = ChartHour()
            h.entries = value
            h.hour = key
            chartHours.append(h)
        }
        
        let hours = chartHours.map { $0.hour }
        for i in 0..<25 {
            if hours.indexOf(i) >= 0 {
                
                let j = JournalEntry()
                j.score = ChartDayMinimumDayAverage
                let c = NSCalendar.currentCalendar().components([.Year, .Month, .Day], fromDate: rawDate)
                c.setValue(i, forComponent: .Hour)
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
            self.hours.sortInPlace({
                $0.hour < $1.hour
            })
        }
        
    }
    
    // MARK: Chartable
    
    var values: [AnyObject] {
        return hours
    }
    
    func barPadding() -> CGFloat {
        return 8.0
    }
    
    func viewAtIndex(index: Int) -> UIView {
        let view = NSBundle.mainBundle().loadNibNamed("BarView", owner: nil, options: nil)[0] as! BarView
        let perc = CGFloat(hours[index].score) / 100.0
        view.barContainer.backgroundColor = UIColor.moodColorAtPercentage(perc)
        return view
    }
    
    func valueAtIndex(index: Int) -> CGFloat {
        return CGFloat(hours[index].score)
    }
    
    func hasValueAtIndex(index: Int) -> Bool {
        return hours[index].entries.count > 0 && hours[index].entries[0].userGenerated
    }
    
}

class ChartHour {
    var hour: Int = 0
    var entries = [JournalEntry]()
    lazy var score: Int = {
        // TODO: potentially slow
        if self.entries.count == 0 {
            return 0
        }
        return self.entries.map { $0.score }.reduce(0, combine: +) / self.entries.count
    }()
}