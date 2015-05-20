//
//  ChartDetailViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class ChartDetailViewController: UIViewController {
    
    var hour: ChartHour!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println(hour.entries.count)
        
        for entry in hour.entries {
            let v = UIView.viewFromNib("ChartDetailView") as! ChartDetailView
            v.entry = entry
            view.addSubview(v)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
    }
    
    func done() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        for v in view.subviews {
            if let v = v as? ChartDetailView {
                v.frame = view.bounds
            }
        }
    }
}