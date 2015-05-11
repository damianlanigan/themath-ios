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
    
    var entries = [JournalEntry]()
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        chart.reloadData()
    }
    
    override func fetchAndDisplayLatestData() {
        fetchDay(NSDate(), completion: { () -> Void in
            self.reloadChart()
        })
    }
    
    private func fetchDay(date: NSDate, completion: () -> Void) {
        
        let params = [
            "start_datetime" : Day(date: date).floor,
            "end_datetime" : Day(date: date).ceil
        ]
        
        request(Router.JournalEntries(params)).responseJSON { (request, response, data, error) in
            if let data = data as? Array<Dictionary<String,AnyObject>> {
                self.entries = []
                for d in data {
                    let entry = JournalEntry.fromJSONRequest(d)
                    self.entries.append(entry)
                }
                completion()
            }
        }
    }
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(entries.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        let idx = Int(horizontalIndex)
        return CGFloat(entries[idx].score)
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
        return UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: CGFloat(entries[hIdx].score) / 100.0)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        selectedIdx = Int(horizontalIndex)
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        if let idx = selectedIdx {
            delegate?.didSelectMoment(entries[idx])
        }
    }
}
