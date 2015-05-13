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
    
    let chart = JBBarChartView()
    
    lazy var loader: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        transform = CGAffineTransformMakeScale(-1.0, 1.0)
        
        addSubview(loader)
        
        chart.minimumValue = 1.0
        chart.maximumValue = 100.0
        addSubview(chart)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loader.center = CGPointMake(frame.width / 2.0, frame.height / 2.0)
        chart.frame = CGRectMake(16, 0, frame.size.width - 32, frame.size.height)
    }
    
    func reloadData() {
        chart.reloadData()
    }

}
