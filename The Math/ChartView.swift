//  
//
//  ChartView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/12/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import JBChartView

class ChartView: UIView, JBChartViewDelegate {
    
    var scope: CalendarScope!
    weak var model: ChartViewModel!
    
    lazy var chart: JBChartView = {
        let c = JBBarChartView()
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
    
    init(scope: CalendarScope, model: ChartViewModel) {
        self.scope = scope
        self.model = model
        super.init(frame: CGRectZero)
        
        transform = CGAffineTransformMakeScale(-1.0, 1.0)
        
        addSubview(chart)
        addSubview(chartFooterView())
        addSubview(loader)
        addSubview(timeLabel)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loader.center = CGPointMake(frame.width / 2.0, frame.height / 2.0)
        
        // date label height = 17
        // footer height = 20
        chart.frame = CGRectMake(16, 32, frame.size.width - 32, frame.size.height - 52 - (chart.footerPadding * 2.0))
        let padding: CGFloat = scope == CalendarScope.Month ? 14.0 : (scope == CalendarScope.Day ? 12.0 : 0.0)
        chartFooterView().frame = CGRectMake(padding, chart.frame.size.height + chart.frame.origin.y + 1, frame.size.width - (padding * 2.0), 20.0)
        
        var labelCount = chartFooterView().subviews.filter { $0.isKindOfClass(UILabel.self) }.count
        let labelWidth = chartFooterView().frame.size.width / CGFloat(labelCount)
        for (idx, view) in enumerate(chartFooterView().subviews) {
            if let label = view as? UILabel {
                label.textColor = UIColor.grayColor()
                
                let yOffset: CGFloat = 0.0
                let width = labelWidth
                let xOffset = CGFloat(idx) * width
                let height: CGFloat = 20.0
                label.frame = CGRectMake(xOffset, yOffset, width, height)
            }
        }
        timeLabel.center.x = frame.size.width / 2.0
    }
    
    func reloadData() {
        chart.reloadData()
    }
    
    // MARK: Footer View
    
    private var _footerView: UIView?
    
    func chartFooterView() -> UIView {
        if _footerView != nil {
            return _footerView!
        }
        if scope == .Day {
            _footerView = dayFooterView()
        } else if scope == .Week {
            _footerView = weekFooterView()
        } else if scope == .Month {
            _footerView = monthFooterView()
        }
        return _footerView!
    }
    
    private func dayFooterView() -> UIView {
        let v = UIView()
        var labels = [UILabel]()
        
        var hours = ["12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12"]
        
        for i in hours {
            let l = ChartFooterLabel()
            l.text = i
            l.textAlignment = .Center
            labels.append(l)
        }
        
        for label in labels {
            label.textColor = UIColor.lightGrayColor()
            label.font = UIFont(name: CabritoSansFontName, size: 12)
            v.addSubview(label)
        }
        
        return v
    }
    
    private func weekFooterView() -> UIView {
        let v = UIView()
        let days = ["M", "T", "W", "T", "F", "S", "S"]
        for i in 0..<7 {
            let l = ChartFooterLabel()
            l.textAlignment = .Center
            l.font = UIFont(name: CabritoSansFontName, size: 12.0)
            l.text = days[i]
            l.textColor = UIColor.whiteColor()
            v.addSubview(l)
        }
        return v
    }
    
    private func monthFooterView() -> UIView {
        let v = UIView()
        let month = (self.model.dateValue as! Month)
        for i in 0..<month.dayCount {
            let l = ChartFooterLabel()
            l.textAlignment = .Center
            l.font = UIFont(name: CabritoSansFontName, size: 12.0)
            l.textColor = UIColor.lightGrayColor()
            
            let date = month.startDate.dateByAddingDays(i)
            var day = "\(date.day())"
            l.text = day
            
            v.addSubview(l)
        }
        return v
    }
    

}
