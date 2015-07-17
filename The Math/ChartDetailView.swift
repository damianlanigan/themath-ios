//
//  ChartDetailView.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import MapKit

class ChartDetailView: UIView {

    @IBOutlet weak var progressView: CircleProgressView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryContainerView: UIView!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var contentViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapContainerView: UIView!
    
    var entry: JournalEntry! {
        didSet {
            updateUIForJournalEntry()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentViewWidthConstraint.constant = frame.size.width
        mapContainerView.layer.cornerRadius = 10.0
        mapContainerView.clipsToBounds = true
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
        minute = count(minute) < 2 ? "0\(minute)" : minute
        
        formatter.dateFormat = "h"
        var hour = formatter.stringFromDate(date)
        
        formatter.dateFormat = "EEEE"
        let weekday = formatter.stringFromDate(date)
        
        formatter.dateFormat = "a"
        let aORp = formatter.stringFromDate(date)
        
        timeLabel.text = "\(weekday) at \(hour):\(minute) \(aORp)"
        dateLabel.text = "\(date.monthToString()) \(date.day()), \(date.year(offset: 0))"
        if let location = entry.location {
            let v = Vendor(type: VendorType.Location, content: entry.geocodedLocationString!)
            dateLabel.text = "\(dateLabel.text!) • \(entry.geocodedLocationString!)"
            
            mapView.centerCoordinate = location.coordinate
            mapView.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.01, 0.01))
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            mapView.addAnnotation(annotation)
            
        }
        noteLabel.text = entry.note
        
        var size = CGSizeMake(32, 32)
        let padding = 4
        for (idx, category) in enumerate(entry.categories) {
            let image = UIImage.imageForCategoryType(category)
            let color = UIColor.colorForCategoryType(category)
            let frame = CGRectMake(size.width * CGFloat(idx) + CGFloat(padding * idx), 0.0, size.width, size.height)
            let view = UIImageView(frame: frame)
            view.image = image
            view.layer.cornerRadius = 16.0
            view.backgroundColor = color
            
            categoryContainerView.addSubview(view)
        }
        
//        var vendors = [Vendor]()
//        if let location = entry.lat {
//            let v = Vendor(type: VendorType.Location, content: entry.locationString!)
//            vendors.append(v)
//        }
//        
//        for (idx, vendor) in enumerate(vendors) {
//            let v = UIView.viewFromNib("ChartDetailVendorView") as! ChartDetailVendorView
//            v.vendorTitleLabel.text = vendor.title
//            v.vendorImage.image = vendor.image
//            v.vendorContentLabel.text = vendor.content
//            
//            let width: CGFloat = 278.0
//            v.frame = CGRectMake(CGFloat(idx) * width, 0.0, width, vendorInformationContainerView.frame.size.height)
//            vendorInformationContainerView.addSubview(v)
//        }
        
    }
    
}
