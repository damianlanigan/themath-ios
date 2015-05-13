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
    var offset: Int!
    
    var view: ChartView = {
        return ChartView()
    }()
    
    init(week: Week) {
        self.week = week
    }
    
    private func fetchWeek(date: NSDate, completion: (newWeek: ChartWeek) -> Void) {
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let monday = Week(date: date).calendarDays.monday.floor.adjustedForLocalTime(calendar)
        let today = NSDate().adjustedForLocalTime(calendar)
        
        let params = [
            "start_date" : monday,
            "end_date" : today,
            "timezone_offset" : (NSTimeZone.localTimeZone().secondsFromGMT / 60 / 60)
        ]
        
        request(Router.AverageScore(params)).responseJSON { (request, response, data, error) in
            if let data = data as? Array<Dictionary<String,Int>> {
                
                println(data)
                
                var days = [ChartDay]()
                for d in data {
                    for (date, score) in d {
                        let timestamp = NSDate(fromString: date, format: DateFormat.ISO8601)
                        let day = ChartDay(date: timestamp, score: score)
                        days.append(day)
                    }
                }
                println(days)


                let week = ChartWeek(date: date)
                
                week.days = days
                
                completion(newWeek: week)
            }
        }
    }
    
    // MARK: Chart

    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
//        if let week = currentWeek {
//            return UInt(week.days.count)
//        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
//        let idx = Int(index)
//        return CGFloat(currentWeek!.days[idx].score)
        return 100
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
//        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
//            let idx = Int(index)
//            let perc = CGFloat(currentWeek!.days[idx].score) / 100.0
//            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
//            return view
//        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 30.0
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        println("poop")
    }
}