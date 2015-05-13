//
//  ChartView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/12/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class ChartView: UIView {
    
    lazy var loader: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activity.hidesWhenStopped = true
        activity.startAnimating()
        return activity
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loader)
       transform = CGAffineTransformMakeScale(-1.0, 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        loader.center = CGPointMake(frame.width / 2.0, frame.height / 2.0)
        println(center)
    }

}
