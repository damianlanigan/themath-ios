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
        
        chart.dataSource = self
        chart.delegate = self
        chart.minimumValue = 0.0
        chart.maximumValue = 100.0
        view.addSubview(chart)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        chart.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadChart()
    }
    
    func reloadChart() {
        chart.reloadData()
    }
    
    // MARK: Data
    
    override func fetchAndDisplayLatestData() {
        getWeekWithDate(NSDate(), completion: { (week: ChartWeek) -> Void in
            self.currentWeek = week
            self.reloadChart()
        })
    }
    
    private func getWeekWithDate(date: NSDate, completion: (newWeek: ChartWeek) -> Void) {
        
        let params = [
            "start_date" : Week(date: date).calendarDays.monday.rawDate,
            "end_date" : NSDate()
        ]
        
        request(Router.AverageScore(params)).responseJSON { (request, response, data, error) in
            if let data = data as? Array<Dictionary<String,Int>> {
                
                // construct a Week from our data
                
                var days = [ChartDay]()
                for d in data {
                    for (date, score) in d {
                        let timestamp = NSDate(fromString: date, format: DateFormat.ISO8601)
                        let day = ChartDay(mood: score, timestamp: timestamp)
                        days.append(day)
                    }
                }
                
                let newWeek = ChartWeek(date: params["start_date"]!)
                newWeek.chartDays = days
                completion(newWeek: newWeek)
            }
        }
    }
    
    
    // MARK: Graph

    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        if let week = currentWeek {
            return UInt(week.chartDays.count)
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        let idx = Int(index)
        return CGFloat(currentWeek!.chartDays[idx].averageMood)
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
        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
            let idx = Int(index)
            let perc = CGFloat(currentWeek!.chartDays[idx].averageMood) / 100.0
            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
            return view
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 30.0
    }
}

