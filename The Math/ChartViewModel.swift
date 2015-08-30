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
        let chartView = ChartView(scope: self.scope, model: self)
        chartView.chart.delegate = self
        chartView.chart.dataSource = self
        chartView.timeLabel.text = self.dateValue!.formattedDescription()
        return chartView
    }()
    
    init(scope: CalendarScope) {
        self.scope = scope
    }
    
    func populateChart() {
        self.dateValue?.fetchChartableRepresentation({ (result) -> Void in
            self.chartableDateValue = result
            self.view.loader.stopAnimating()
            self.view.reloadData()
            var sum = result.values.map { ($0 as! ChartDay).score }.reduce(0, combine: +)
            if sum == 0 {
                self.view.showEmptyState()
            }
        })
    }
    
    // MARK: <JBBarChartViewDataSource>
    
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
    
    // MARK: <JBBarChartViewDelegate>
    
    func barChartView(barChartView: JBBarChartView!, didSelectBarAtIndex index: UInt) {
        let idx = Int(index)
        if let chartable = chartableDateValue {
            if chartable.hasValueAtIndex(idx) {
                selectedBarIdx = idx
            }
        }
    }
    
    func didDeselectBarChartView(barChartView: JBBarChartView!) {
        if let idx = selectedBarIdx, chartable = chartableDateValue {
            delegate?.didSelectChartDateValue(chartable.values[idx])
        }
        selectedBarIdx = nil
    }
}