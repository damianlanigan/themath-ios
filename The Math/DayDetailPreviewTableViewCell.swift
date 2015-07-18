//
//  DayDetialPreviewTableViewCell.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 7/17/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class DayDetailPreviewTableViewCell: UITableViewCell {

    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var timestampLabel: CabritoLabel!
    
    var score: Int = 0 {
        didSet {
            progressView.progress = Double(CGFloat(score) / 100.0)
            progressView.trackFillColor = UIColor.moodColorAtPercentage(CGFloat(score) / 100)
        }
    }
    
}
