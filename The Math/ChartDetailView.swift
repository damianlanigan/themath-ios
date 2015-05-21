//
//  ChartDetailView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class ChartDetailView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var vendorInformationContainerView: UIView!
    @IBOutlet weak var deleteMoodButton: CabritoButton!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    
    var entry: JournalEntry! {
        didSet {
            updateUIForJournalEntry()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentViewWidthConstraint.constant = frame.size.width
    }
    
    @IBAction func didTapDeleteMoodButton(sender: AnyObject) {
        entry.delete()
    }
    
    private func updateUIForJournalEntry() {
        let perc = CGFloat(entry.score) / 100.0
        let color = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
        progressView.progress = Double(perc)
        progressView.trackFillColor = color
        timeLabel.textColor = color
        
        let formatter = NSDateFormatter()
        let date = entry.timestamp
        
        formatter.dateFormat = "mm"
        var minute = formatter.stringFromDate(date)
        minute = count(minute) < 2 ? "0\(minute)" : minute
        
        formatter.dateFormat = "h"
        var hour = formatter.stringFromDate(date)
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.stringFromDate(date)
        
        formatter.dateFormat = "a"
        let aORp = formatter.stringFromDate(date)
        
        timeLabel.text = "\(weekday) at \(hour):\(minute) \(aORp)"
        dateLabel.text = "\(date.monthToString()) \(date.day()), \(date.year(offset: 0))"
        noteLabel.text = entry.note
        
        
        for category in entry.categories {
            println(category)
        }
    }

}
