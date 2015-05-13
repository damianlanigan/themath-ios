//
//  ChartCoordinator.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/12/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import JBChartView

class ChartCoordinator: NSObject,
    JBBarChartViewDataSource,
    JBBarChartViewDelegate {
    
    let week: Week!
    var chartWeek: ChartWeek?
    var offset: Int! {
        didSet {
            populateChart()
        }
    }
    
    lazy var view: ChartView = {
        let v = ChartView()
        v.chart.delegate = self
        v.chart.dataSource = self
        return v
    }()
    
    init(week: Week) {
        self.week = week
    }
    
    func populateChart() {
        fetchWeek { () -> Void in
            self.view.loader.stopAnimating()
            self.view.reloadData()
        }
    }
    
    private func fetchWeek(completion: () -> Void) {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let monday = week.calendarDays.monday.rawDate
        let today = NSDate().adjustedForLocalTime(calendar)
        
        let params = [
            "start_date" : monday,
            "end_date" : week.contains(today) ? today : week.calendarDays.sunday.ceil.adjustedForLocalTime(calendar),
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
                        let timestamp = calendar.dateFromComponents(comps)!
                        let day = ChartDay(date: timestamp, score: score)
                        days.append(day)
                    }
                }

                self.chartWeek = ChartWeek(date: self.week.calendarDays.monday.rawDate)
                self.chartWeek!.days = days
                
                completion()
            }
        }
    }
    
    // MARK: Chart
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        if let week = chartWeek {
            return UInt(week.days.count)
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        if let week = chartWeek {
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
            let perc = CGFloat(chartWeek!.days[idx].score) / 100.0
            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
            return view
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 30.0
    }
    

}