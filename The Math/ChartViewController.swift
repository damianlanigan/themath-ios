//
//  ChartViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/23/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

protocol ChartViewControllerDelegate: class {
    func didSelectMoment()
    func didSelectDay(day: Int)
    func didSelectWeek(week: Int)
}

typealias CalendarWeekDays = (
    monday: Day,
    tuesday: Day,
    wednesday: Day,
    thursday: Day,
    friday: Day,
    saturday: Day,
    sunday: Day
)

class Week {
    
    let calendarDays: CalendarWeekDays
    
    init(date: NSDate) {
        let num = date.weekday() - 1 == 0 ? 7 : date.weekday() - 1
        let start = date.dateBySubtractingDays(num - 1)
        calendarDays = (
            Day(date: start),
            Day(date: start.dateByAddingDays(1)),
            Day(date: start.dateByAddingDays(2)),
            Day(date: start.dateByAddingDays(3)),
            Day(date: start.dateByAddingDays(4)),
            Day(date: start.dateByAddingDays(5)),
            Day(date: start.dateByAddingDays(6))
        )
    }
}

class ChartWeek: Week {
    var chartDays: [ChartDay] = [ChartDay]() {
        didSet {
            var _days = chartDays
            let dayAbbrsWithIndex = ["mon" : 1, "tue" : 2, "wed" : 3, "thu" : 4, "fri" : 5, "sat" : 6, "sun" : 7]
            let dayAbbrs = chartDays.map { $0.rawDate.shortWeekdayToString().lowercaseString }

            for abbr in dayAbbrsWithIndex.keys {
                if find(dayAbbrs, abbr) == nil {
                    _days.append(ChartDay(mood: 0, timestamp: self.calendarDays.monday.rawDate.dateByAddingDays(dayAbbrsWithIndex[abbr]! - 1)))
                }
            }
            _days.sort { [unowned self] in
                dayAbbrsWithIndex[$0.rawDate.shortWeekdayToString().lowercaseString]! <
                    dayAbbrsWithIndex[$1.rawDate.shortWeekdayToString().lowercaseString]!
            }
            chartDays = _days
        }
    }
}

class Day {
    
    let rawDate: NSDate!
    
    init(date: NSDate) {
        rawDate = date
    }
    
    func week() -> Week {
        return Week(date: rawDate)
    }
}

class ChartDay: Day {
    
    let averageMood: Int!
    
    init (mood: Int, timestamp: NSDate) {
        averageMood = mood
        super.init(date: timestamp)
    }
}


class ChartViewController: UIViewController {

    weak var delegate: ChartViewControllerDelegate?
    var selectedIdx: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAndDisplayLatestData()
    }
    
    func fetchAndDisplayLatestData() {
        // abstract
    }

}
