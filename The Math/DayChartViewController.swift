//
//  DayInfoGraphViewController.swift
//  GraphIt
//
//  Created by Michael Kavouras on 4/22/15.
//  Copyright (c) 2015 Michael Kavouras. All rights reserved.
//

import UIKit
import JBChartView

class DayChartViewController: ChartViewController,
    JBLineChartViewDelegate,
    JBLineChartViewDataSource {
    
    var chartData: [[Int]] = [[Int]]()
    let chart = JBLineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChartView()
        
    }
    private func addChartView() {
        chart.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        chart.delegate = self
        chart.dataSource = self
        chart.minimumValue  = 1.0
        chart.maximumValue = 100.0
        view.addSubview(chart)
    }
    
    private func reloadChart() {
        chart.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        chart.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        chart.reloadData()
    }
    
    override func fetchAndDisplayLatestData() {
        fetchDay(NSDate(), completion: { (week: ChartDay) -> Void in
            self.reloadChart()
        })
    }
    
    private func fetchDay(date: NSDate, completion: (day: ChartDay) -> Void) {
        
        let params = [
            "start_datetime" : Day(date: NSDate()).floor,
            "end_datetime" : NSDate()
        ]
        
        request(Router.JournalEntries(params)).responseJSON { (request, response, data, error) in
            println(data)
            if let data = data as? Array<Dictionary<String,Int>> {
                println(data)
            }
        }
    }
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(chartData[Int(lineIndex)].count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return CGFloat(chartData[Int(lineIndex)][Int(horizontalIndex)])
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
        let lIdx = Int(lineIndex)
        let hIdx = Int(horizontalIndex)
        return UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: CGFloat(chartData[lIdx][hIdx]) / 100.0)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        selectedIdx = Int(horizontalIndex)
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        if let idx = selectedIdx {
            delegate?.didSelectMoment()
        }
    }
}
