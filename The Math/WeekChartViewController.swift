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
    
    var bars: [InfoGraphWeek] = [InfoGraphWeek]()
    
    let barGraph = JBBarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSomeDummyData()
        
        barGraph.dataSource = self
        barGraph.delegate = self
        barGraph.minimumValue = 1.0
        barGraph.maximumValue = 100.0
        view.addSubview(barGraph)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        barGraph.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)
        barGraph.reloadData()
    }

    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(bars.count)
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return bars[Int(index)].mood
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
            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: bars[Int(index)].mood / 100.0)
            return view
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 30.0
    }
    
    private func loadSomeDummyData() {
        var days: [String] = ["M", "T", "W", "T", "F", "S", "S"]
        for day in 0...6 {
            var num = 20 + (arc4random() % (101 - 20))
            let data = InfoGraphWeek(mood: CGFloat(num), day: days[day])
            bars.append(data)
        }
    }

}

