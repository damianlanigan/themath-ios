//
//  WeekInfoGraphViewController.swift
//  GraphIt
//
//  Created by Michael Kavouras on 4/22/15.
//  Copyright (c) 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import JBChartView

class WeekChartViewController: ChartViewController,
    JBBarChartViewDataSource,
    JBBarChartViewDelegate {
    
    var currentWeek: ChartWeek?
    
    let chart = JBBarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChartView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chart.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadChart()
    }
    
    private func addChartView() {
        chart.dataSource = self
        chart.delegate = self
        chart.minimumValue = 1.0
        chart.maximumValue = 100.0
        view.addSubview(chart)
    }
    
    private func reloadChart() {
        chart.reloadData()
    }
    
    // MARK: Data
    
    override func fetchAndDisplayLatestData() {
        fetchWeek(NSDate(), completion: { (week: ChartWeek) -> Void in
            self.currentWeek = week
            self.reloadChart()
        })
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


//                let week = ChartWeek(date: params["start_date"]!)
                let week = ChartWeek(date: (params["start_date"] as! NSDate))
                week.days = days
//
//                completion(newWeek: newWeek)
            }
        }
    }
    
    
    // MARK: Chart

    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        if let week = currentWeek {
//            return UInt(week.chartDays.count)
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        let idx = Int(index)
//        return CGFloat(currentWeek!.chartDays[idx].averageMood)
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        selectedIdx = Int(index)
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        if let idx = selectedIdx {
            delegate?.didSelectDay(idx)
        }
    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
//        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
//            let idx = Int(index)
//            let perc = CGFloat(currentWeek!.chartDays[idx].averageMood) / 100.0
//            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
//            return view
//        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 30.0
    }
}

