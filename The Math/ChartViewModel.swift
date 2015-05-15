//
//  ChartCoordinator.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/12/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import JBChartView

class ChartViewModel: NSObject,
    JBLineChartViewDelegate,
    JBLineChartViewDataSource,
    JBBarChartViewDataSource,
    JBBarChartViewDelegate {
    
    var scope: CalendarScope = .Undefined
    
    var dateValue: TimeRepresentable?
    var chartableDateValue: Chartable?
    
    var offset: Int! {
        didSet {
            populateChart()
        }
    }
    
    var date: NSDate! {
        didSet {
            assert(scope != .Undefined, "Cannot set date without a scope")
            if scope == .Day {
                dateValue = Day(date: date)
            } else if scope == .Week {
                dateValue = Week(date: date)
            } else if scope == .Month {
                dateValue = Month(date: date)
            }
        }
    }
    
    lazy var view: ChartView = {
        let v = ChartView(scope: self.scope)
        v.chart.delegate = self
        v.chart.dataSource = self
        let text = self.dateValue!.formattedDescription()
        v.timeLabel.text = text
        return v
    }()
    
    init(scope: CalendarScope) {
        self.scope = scope
    }
    
    func populateChart() {
        if scope == .Week {
            fetchWeek { () -> Void in
                self.view.loader.stopAnimating()
                self.view.reloadData()
            }
        }
        if scope == .Day {
            fetchDay { () -> Void in
                self.view.loader.stopAnimating()
                self.view.reloadData()
            }
        }
        if scope == .Month {
            fetchMonth { () -> Void in
            }
        }
    }
    
    private func fetchWeek(completion: () -> Void) {
        let week = dateValue as! Week
        let monday = week.calendarDays.monday.rawDate.dateAtStartOfDay()
        
        let params = [
            "start_date" : monday,
            "end_date" : monday.dateAtEndOfWeek().dateAtEndOfDay(),
            "timezone_offset" : (NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60)
        ]
        
        request(Router.AverageScore(params)).responseJSON { (request, response, data, error) in
            if let data = data as? Array<Dictionary<String,Int>> {
                
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

                self.chartableDateValue = ChartWeek(date: week.calendarDays.monday.rawDate)
                (self.chartableDateValue as! ChartWeek).days = days
                
                completion()
            }
        }
    }
    
    private func fetchDay(completion: () -> Void) {
        let day = dateValue as! Day
        
        let params = [
            "start_datetime" : day.rawDate.dateAtStartOfDay(),
            "end_datetime" : day.rawDate.dateAtEndOfDay(),
            "timezone_offset" : (NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60)
        ]
        
        request(Router.JournalEntries(params)).responseJSON { (request, response, data, error) in
            if let data = data as? Array<Dictionary<String,AnyObject>> {
                var entries: [JournalEntry] = [JournalEntry]()
                for d in data {
                    let entry = JournalEntry.fromJSONRequest(d)
                    entries.append(entry)
                }
                
                var scores: [Int] = entries.map { $0.score }
                var sum = scores.reduce(0, combine: +)
                let average = entries.count > 0 ? sum / entries.count : ChartDayMinimumDayAverage
                self.chartableDateValue = ChartDay(date: day.rawDate, score: average)
                (self.chartableDateValue as! ChartDay).entries = entries
                completion()
            }
        }
    }
    
    private func fetchMonth(completion: () -> Void) {
        
    }
    
    // MARK: Chart BAR
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        if let week = chartableDateValue as? ChartWeek {
            return UInt(week.days.count)
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        if let week = chartableDateValue as? ChartWeek {
            let idx = Int(index)
            return CGFloat(week.days[idx].score)
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
//        selectedIdx = Int(index)
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
//        if let idx = selectedIdx {
//            delegate?.didSelectDay(idx)
//        }
    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
            let idx = Int(index)
            
            if let week = chartableDateValue as? ChartWeek {
                let perc = CGFloat(week.days[idx].score) / 100.0
                view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
            }
            
            return view
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 30.0
    }
    
    // MARK: Chart LINE
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        if let day = chartableDateValue as? ChartDay {
            return 1
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        if let day = chartableDateValue as? ChartDay {
            return UInt(day.entries.count)
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        if let day = chartableDateValue as? ChartDay {
            let hIdx = Int(horizontalIndex)
            return CGFloat(day.entries[hIdx].score)
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true
    }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 3.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.blackColor().colorWithAlphaComponent(0.3)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIColor! {
        
        if let day = chartableDateValue as? ChartDay {
            let lIdx = Int(lineIndex)
            let hIdx = Int(horizontalIndex)
            return UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: CGFloat(day.entries[hIdx].score) / 100.0)
        }

        return UIColor.blackColor()
    }

}