//
//  MonthInfoGraphViewController.swift
//  GraphIt
//
//  Created by Michael Kavouras on 4/22/15.
//  Copyright (c) 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class MonthChartViewController: ChartViewController,
    JBBarChartViewDataSource,
    JBBarChartViewDelegate {
    
    var bars: [CGFloat] = [CGFloat]()
    
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
        return bars[Int(index)]
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        delegate?.didSelectWeek(Int(ceil(Double(index) / 7.0)))
    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: bars[Int(index)] / 100.0)
            return view
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 4.0
    }
    
    private func loadSomeDummyData() {
        let today = NSDate()
        let c = NSCalendar.currentCalendar()
        let days = c.rangeOfUnit(NSCalendarUnit.DayCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: today)
        
        for day in 1...days.length {
            var num = 1 + (arc4random() % 100)
            bars.append(CGFloat(num))
        }
    }

}
