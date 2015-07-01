//
//  Chartable.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/20/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import UIKit

protocol TimeRepresentable {
    func formattedDescription() -> String
    func fetchChartableRepresentation(completion: (result: Chartable) -> Void)
}

protocol Chartable {
    func barPadding() -> CGFloat
    func viewAtIndex(index: Int) -> UIView
    func valueAtIndex(index: Int) -> CGFloat
    func hasValueAtIndex(index: Int) -> Bool
    var values: [AnyObject] { get }
}

enum CalendarScope: Int {
    case Undefined
    case Day
    case Week
    case Month
    
    func timeValue(date: NSDate) -> TimeRepresentable? {
        switch self {
        case .Day:
            return CalendarDay(date: date)
        case .Week:
            return CalendarWeek(date: date)
        case .Month:
            return CalendarMonth(date: date)
        default:
            return nil
        }
    }
}

typealias CalendarWeekDays = (
    monday: CalendarDay,
    tuesday: CalendarDay,
    wednesday: CalendarDay,
    thursday: CalendarDay,
    friday: CalendarDay,
    saturday: CalendarDay,
    sunday: CalendarDay
)
