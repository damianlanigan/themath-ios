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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println(hour.entries.count)
    }
}