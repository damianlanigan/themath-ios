//
//  ChartCoordinator.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/12/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import JBChartView

class ChartViewModel: NSObject,
    JBBarChartViewDataSource,
    JBBarChartViewDelegate {
    
    var scope: CalendarScope = .Undefined
    var dateValue: TimeRepresentable?
    var chartableDateValue: Chartable?
    
    var selectedBarIdx: Int?
    
    weak var delegate: ChartDelegate?
    
    var date: NSDate! {
        didSet {
            assert(scope != .Undefined, "Cannot set date without a scope")
            if scope == .Day {
                dateValue = Day(date: date)
            } else if scope == .Week {
                dateValue = Week(date: date)
            } else if scope == .Month {
                dateValue = Month(date: date)
            }
            populateChart()
        }
    }
    
    lazy var view: ChartView = {
        let v = ChartView(scope: self.scope, model: self)
        v.chart.delegate = self
        v.chart.dataSource = self
        let text = self.dateValue!.formattedDescription()
        v.timeLabel.text = text
        return v
    }()
    
    init(scope: CalendarScope) {
        self.scope = scope
    }
    
    func populateChart() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            self.dateValue?.fetchChartableRepresentation({ (result) -> Void in
                self.chartableDateValue = result
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.view.loader.stopAnimating()
                    self.view.reloadData()
                })
            })
        })
    }
    
    // MARK: Chart BAR
    
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        if let day = chartableDateValue as? ChartDay {
            return UInt(day.hours.count)
        }
        if let week = chartableDateValue as? ChartWeek {
            return UInt(week.days.count)
        }
        if let month = chartableDateValue as? ChartMonth {
            return UInt(month.days.count)
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        let idx = Int(index)
        if let day = chartableDateValue as? ChartDay {
            return CGFloat(day.hours[idx].score)
        }
        if let week = chartableDateValue as? ChartWeek {
            return CGFloat(week.days[idx].score)
        }
        if let month = chartableDateValue as? ChartMonth {
            return CGFloat(month.days[idx].score)
        }
        return 0
    }
    
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        if let view: BarView = NSBundle.mainBundle().loadNibNamed("BarView", owner: self, options: nil)[0] as? BarView {
            let idx = Int(index)
            
            if let day = chartableDateValue as? ChartDay {
                let perc = CGFloat(day.hours[idx].score) / 100.0
                view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
            }
            
            if let week = chartableDateValue as? ChartWeek {
                let perc = CGFloat(week.days[idx].score) / 100.0
                view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
            }
            
            if let month = chartableDateValue as? ChartMonth {
                let perc = CGFloat(month.days[idx].score) / 100.0
                view.barContainer.backgroundColor = UIColor.colorAtPercentage(UIColor.mood_startColor(), color2: UIColor.mood_endColor(), perc: perc)
            }
            
            return view
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        if let day = chartableDateValue as? ChartDay {
            return 8.0
        } else if let week = chartableDateValue as? ChartWeek {
          return 30.0
        } else if let month = chartableDateValue as? ChartMonth {
            return 4.0
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let idx = Int(index)
        if let day = chartableDateValue as? ChartDay {
            if day.hours[idx].entries.count > 0 {
                if day.hours[idx].entries[0].userGenerated {
                    selectedBarIdx = idx
                } else {
                    println("filler")
                }
            }
        }
        // week is just average score so there are no entries
        if let week = chartableDateValue as? ChartWeek {
            if week.days[idx].score > 0 {
                selectedBarIdx = idx
            }
        }
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        if let idx = selectedBarIdx {
            if let day = chartableDateValue as? ChartDay {
                delegate?.didSelectHour(day.hours[idx])
            } else if let week = chartableDateValue as? ChartWeek {
                delegate?.didSelectDay(week.days[idx])
            }
        }
    }
}