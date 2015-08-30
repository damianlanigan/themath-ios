//
//  ChartDetailViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class WhatTheAbsoluteFuck: UIViewController {
    
    var entry: JournalEntry!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Mood"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let v = UIView.viewFromNib("JournalEntryView") as! JournalEntryView
        v.entry = entry
        view.addSubview(v)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for v in view.subviews {
            if let v = v as? JournalEntryView {
                v.frame = view.bounds
            }
        }
    }
}