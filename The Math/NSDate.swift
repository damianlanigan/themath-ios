//
//  NSDate.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 9/11/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

import Foundation

extension NSDate {
    
    // MARK: Intervals In Seconds
    private class func minuteInSeconds() -> Double { return 60 }
    private class func hourInSeconds() -> Double { return 3600 }
    private class func dayInSeconds() -> Double { return 86400 }
    private class func weekInSeconds() -> Double { return 604800 }
    private class func yearInSeconds() -> Double { return 31556926 }

    
    // MARK: Components
    private class func componentFlags() -> NSCalendarUnit { return [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.WeekOfYear, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday, NSCalendarUnit.WeekdayOrdinal, NSCalendarUnit.WeekOfYear] }
    
    private class func components(fromDate fromDate: NSDate) -> NSDateComponents! {
        return NSCalendar.currentCalendar().components(NSDate.componentFlags(), fromDate: fromDate)
    }
    
    private func components() -> NSDateComponents  {
        return NSDate.components(fromDate: self)!
    }
    
    func timeZoneOffsetSeconds() -> Int {
        return NSTimeZone.localTimeZone().secondsFromGMT
    }

    func year (offset: Int = 0) -> Int { return self.components().year + offset }
    func month   (offset: Int = 0) -> Int { return self.components().month + offset }
    func week    (offset: Int = 0) -> Int { return self.components().weekOfYear + offset }
    func day     (offset: Int = 0) -> Int { return self.components().day + offset }
    func hour    (offset: Int = 0) -> Int { return self.components().hour + offset }
    func minute  (offset: Int = 0) -> Int { return self.components().minute + offset }
    func seconds (offset: Int = 0) -> Int { return self.components().second + offset }
    func weekday (offset: Int = 0) -> Int { return self.components().weekday + offset }
    func nthWeekday () -> Int { return self.components().weekdayOrdinal } //// e.g. 2nd Tuesday of the month is 2
    func monthDays () -> Int { return NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: self).length }

    
    func dateByAddingDays(days: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate + NSDate.dayInSeconds() * Double(days)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingDays(days: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - NSDate.dayInSeconds() * Double(days)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingHours(hours: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate + NSDate.hourInSeconds() * Double(hours)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingHours(hours: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - NSDate.hourInSeconds() * Double(hours)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateByAddingMinutes(minutes: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate + NSDate.minuteInSeconds() * Double(minutes)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateBySubtractingMinutes(minutes: Int) -> NSDate {
        let interval: NSTimeInterval = self.timeIntervalSinceReferenceDate - NSDate.minuteInSeconds() * Double(minutes)
        return NSDate(timeIntervalSinceReferenceDate: interval)
    }
    
    func dateAdjustedForLocalTime() -> NSDate {
        components().setValue(hour(timeZoneOffsetSeconds() / Int(NSDate.hourInSeconds())), forComponent: NSCalendarUnit.Hour)
        return NSCalendar.currentCalendar().dateFromComponents(components())!
    }
    
    func dateAtStartOfDay() -> NSDate {
        components().hour = 0
        components().minute = 0
        components().second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components())!
    }
    
    func dateAtEndOfDay() -> NSDate {
        components().hour = 23
        components().minute = 59
        components().second = 59
        return NSCalendar.currentCalendar().dateFromComponents(components())!
    }
    
    func dateAtStartOfWeek() -> NSDate {
        components().weekday = 1 // Sunday
        components().hour = 0
        components().minute = 0
        components().second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components())!
    }
    
    func dateAtEndOfWeek() -> NSDate {
        components().weekday = 7 // Sunday
        components().hour = 0
        components().minute = 0
        components().second = 0
        return NSCalendar.currentCalendar().dateFromComponents(components())!
    }

    func withoutTime() -> NSDate {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: self)
        return calendar.dateFromComponents(components)!
    }
    
    func relativeTimeToString() -> String {
        let time = self.timeIntervalSince1970
        let now = NSDate().timeIntervalSince1970
        
        let seconds = now - time
        let minutes = round(seconds/60)
        let hours = round(minutes/60)
        let days = round(hours/24)
        
        if seconds < 60 {
            return "a moment ago"
        }
        
        if minutes < 60 {
            return NSLocalizedString("\(Int(minutes)) minutes ago", comment: "relative time")
        }
        
        if hours < 24 {
            if hours == 1 {
                return NSLocalizedString("1 hour ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(Int(hours)) hours ago", comment: "relative time")
            }
        }
        
        if days < 7 {
            if days == 1 {
                return NSLocalizedString("1 day ago", comment: "relative time")
            } else {
                return NSLocalizedString("\(Int(days)) days ago", comment: "relative time")
            }
        }
        
        return NSLocalizedString("\(Int(days)) days ago", comment: "relative time")
    }


    func weekdayToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.weekdaySymbols[self.weekday()-1] 
    }
    
    func shortWeekdayToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.shortWeekdaySymbols[self.weekday()-1]
    }
    
    func veryShortWeekdayToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.veryShortWeekdaySymbols[self.weekday()-1]
    }
    
    func monthToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.monthSymbols[self.month()-1]
    }
    
    func shortMonthToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.shortMonthSymbols[self.month()-1]
    }
    
    func veryShortMonthToString() -> String {
        let formatter = NSDateFormatter()
        return formatter.veryShortMonthSymbols[self.month()-1]
    }
}

extension Int {
    func twelveHourClock() -> Int {
        if self == 0 {
            return 12
        }
        if self > 12 {
            return self - 12
        }
        return self
    }
    
    func pad() -> String {
        if "\(self)".characters.count == 1 {
            return "0\(self)"
        }
        return "\(self)"
    }
}