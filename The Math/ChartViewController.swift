//
//  ChartViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ChartViewControllerDelegate {
    func didSelectMoment()
    func didSelectDay(day: Int)
    func didSelectWeek(week: Int)
}

struct InfoGraphWeek {
    let mood: CGFloat!
    let day: String!
}

class ChartViewController: UIViewController {

    var delegate: ChartViewControllerDelegate?

}
