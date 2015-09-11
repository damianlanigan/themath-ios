//
//  ChartDetailView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import MapKit

class JournalEntryView: UIView {

    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var moodMessageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var moodMessageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var categoryContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    
    var entry: JournalEntry! {
        didSet {
            updateUIForJournalEntry()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentViewWidthConstraint.constant = frame.size.width
        mapContainerView.layer.cornerRadius = 6.0
        mapContainerView.clipsToBounds = true
        
        if entry.note.isEmpty {
            moodMessageBottomConstraint.constant = 30
            moodMessageTopConstraint.constant = 0
        }
        
        if entry.categories.isEmpty {
            categoryContainerHeightConstraint.constant = 0
            categoryContainerTopConstraint.constant = 0
        }
        
        if entry.location == nil {
            mapViewHeightConstraint.constant = 0
            detailsLabel.hidden = true
        }
    }
    
    private func updateUIForJournalEntry() {
        let perc = CGFloat(entry.score) / 100.0
        let color = entry.color
        progressView.progress = Double(perc)
        progressView.trackFillColor = color
        timeLabel.textColor = color
        
        let formatter = NSDateFormatter()
        let date = entry.timestamp
        
        formatter.dateFormat = "mm"
        var minute = formatter.stringFromDate(date)
        minute = (minute.characters.count < 2) ? "0\(minute)" : minute
        
        formatter.dateFormat = "h"
        let hour = formatter.stringFromDate(date)
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.stringFromDate(date)
        
        formatter.dateFormat = "a"
        let aORp = formatter.stringFromDate(date)
        
        timeLabel.text = "\(weekday) at \(hour):\(minute) \(aORp)"
        dateLabel.text = "\(date.monthToString()) \(date.day()), \(date.year(0))"
        
        if let location = entry.location {
            dateLabel.text = "\(dateLabel.text!) • \(entry.geocodedLocationString!)"
            
            mapView.centerCoordinate = location.coordinate
            mapView.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01, 0.01))
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            
        }
        
        noteLabel.text = entry.note
        
        let size = CGSizeMake(36, 36)
        let padding = 4
        for (idx, category) in entry.categories.enumerate() {
            let image = UIImage.imageForCategoryType(category)
            let color = UIColor.colorForCategoryType(category)
            let frame = CGRectMake(size.width * CGFloat(idx) + CGFloat(padding * idx), 0.0, size.width, size.height)
            let view = UIImageView(frame: frame)
            view.image = image
            view.layer.cornerRadius = 18.0
            view.backgroundColor = color
            
            categoryContainerView.addSubview(view)
        }
        
    }
    
}
