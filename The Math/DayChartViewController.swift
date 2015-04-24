//
//  DayInfoGraphViewController.swift
//  GraphIt
//
//  Created by Michael Kavouras on 4/22/15.
//  Copyright (c) 2015 Michael Kavouras. All rights reserved.
//

import UIKit


class DayChartViewController: ChartViewController,
    JBLineChartViewDelegate,
    JBLineChartViewDataSource {
    
    var chartData: [[CGFloat]] = [[CGFloat]]()
    let lineGraph = JBLineChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSomeDummyData()
        
        lineGraph.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        lineGraph.delegate = self
        lineGraph.dataSource = self
        lineGraph.minimumValue  = 1.0
        lineGraph.maximumValue = 100.0
        view.addSubview(lineGraph)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        lineGraph.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        lineGraph.reloadData()
    }
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return UInt(chartData.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(chartData[Int(lineIndex)].count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return chartData[Int(lineIndex)][Int(horizontalIndex)]
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
        return UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: chartData[Int(lineIndex)][Int(horizontalIndex)] / 100.0)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt) {
        selectedIdx = Int(horizontalIndex)
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView!) {
        if let idx = selectedIdx {
            delegate?.didSelectMoment()
        }
    }
    
    private func loadSomeDummyData() {
        let numberOfPoints = 2 + (arc4random() % 8)
        var points = [CGFloat]()
        for i in 0...numberOfPoints {
            points.append(CGFloat(20 + (arc4random() % (101 - 20))))
        }
        chartData.append(points)
    }

}
