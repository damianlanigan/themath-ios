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
            dateValue = scope.timeValue(date)
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
        if let chartable = chartableDateValue {
            return UInt(chartable.values.count)
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, heightForBarViewAtIndex index: UInt) -> CGFloat {
        if let chartable = chartableDateValue {
            return chartable.valueAtIndex(Int(index))
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, barViewAtIndex index: UInt) -> UIView! {
        if let chartable = chartableDateValue {
            return chartable.viewAtIndex(Int(index))
        }
        return UIView()
    }
    
    func barPaddingForBarChartView(barChartView: JBBarChartView!) -> CGFloat {
        if let chartable = chartableDateValue {
            return chartable.barPadding()
        }
        return 0
    }
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let idx = Int(index)
        if let chartable = chartableDateValue {
            if chartable.hasValueAtIndex(idx) {
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