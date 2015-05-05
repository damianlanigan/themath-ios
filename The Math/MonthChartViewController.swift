//
//  MonthInfoGraphViewController.swift
//  GraphIt
//
//  Created by Michael Kavouras on 4/22/15.
//  Copyright (c) 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import JBChartView

class MonthChartViewController: ChartViewController,
    JBBarChartViewDataSource,
    JBBarChartViewDelegate {
    
    var currentMonth: ChartMonth?
    let chart = JBBarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchAndDisplayLatestData()
        
        chart.dataSource = self
        chart.delegate = self
        chart.minimumValue = 1.0
        chart.maximumValue = 100.0
        view.addSubview(chart)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        chart.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                chart.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        reloadChart()
    }
    
    private func reloadChart() {
        chart.reloadData()
    }
    
    // MARK: Data
    
    override func fetchAndDisplayLatestData() {
//        fetchData(NSDate(), completion: { (month: ChartMonth) -> Void in
//            self.currentMonth = month
//            self.reloadChart()
//        })
    }
    
    private func fetchData(date: NSDate, completion: (newMonth: ChartMonth) -> Void) {
        
        let params = [
            "start_date" : Month(date: date).firstDay,
            "end_date" : NSDate()
        ]
        
        request(Router.AverageScore(params)).responseJSON { (request, response, data, error) in
            if let data = data as? Array<Dictionary<String,Int>> {
                
                // construct a Month from our data
                
                var days = [ChartDay]()
//                for d in data {
//                    for (date, score) in d {
//                        let timestamp = NSDate(fromString: date, format: DateFormat.ISO8601)
//                        let day = ChartDay(mood: score, timestamp: timestamp)
//                        days.append(day)
//                    }
//                }
                
                let newMonth = ChartMonth(date: params["start_date"]!)
                newMonth.chartDays = days
                completion(newMonth: newMonth)
            }
        }
    }

    // MARK: Chart
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return 0 //UInt(bars.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return 0 //bars[Int(index)]
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        selectedIdx = Int(index)
    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
//            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: bars[Int(index)] / 100.0)
            return view
        }
        return UIView()
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        if let idx = selectedIdx {
            let week = ceil(Double(idx) / 7.0)
            delegate?.didSelectWeek(Int(week))
        }
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 4.0
    }
    
    private func loadSomeDummyData() {
        let today = NSDate()
        let c = NSCalendar.currentCalendar()
        let days = c.rangeOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: today)
        
        for day in 1...days.length {
            var num = 1 + (arc4random() % 100)
//            bars.append(CGFloat(num))
        }
    }

}
