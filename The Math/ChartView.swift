//
//  ChartView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/12/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import JBChartView

class ChartView: UIView {
    
    var scope: CalendarScope!
    
    lazy var chart: JBChartView = {
        let c = self.scope == CalendarScope.Day ? JBLineChartView() : JBBarChartView()
        c.minimumValue = 1.0
        c.maximumValue = 100.0
        return c
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "pudge"
        label.frame = CGRectMake(0, 0, 200, 17)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.lightGrayColor()
        label.font = UIFont(name: "AvenirNext-Medium", size: 12.0)
        return label
    }()
    
    lazy var loader: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        transform = CGAffineTransformMakeScale(-1.0, 1.0)
        
        addSubview(chart)
        addSubview(loader)
        addSubview(timeLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loader.center = CGPointMake(frame.width / 2.0, frame.height / 2.0)
        chart.frame = CGRectMake(16, 53, frame.size.width - 32, frame.size.height - 53)
        timeLabel.center.x = frame.size.width / 2.0
    }
    
    func reloadData() {
        chart.reloadData()
    }

}
