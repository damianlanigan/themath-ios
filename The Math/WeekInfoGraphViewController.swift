//
//  WeekInfoGraphViewController.swift
//  GraphIt
//
//  Created by Michael Kavouras on 4/22/15.
//  Copyright (c) 2015 Michael Kavouras. All rights reserved.
//

import UIKit

class WeekInfoGraphViewController: UIViewController,
    JBBarChartViewDataSource,
    JBBarChartViewDelegate {
    
    var bars: [CGFloat] = [30, 70, 90, 60, 98, 100, 58]
    var days: [String] = ["M", "T", "W", "T", "F", "S", "S"]
    
    let barGraph = JBBarChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        barGraph.dataSource = self
        barGraph.delegate = self
        barGraph.minimumValue = 1.0
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
        println("\(bars[Int(index)])")
    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
//            view.barLabel.text = days[Int(index)]
            view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: bars[Int(index)] / 100.0)
            return view
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        return 30.0
    }

}

