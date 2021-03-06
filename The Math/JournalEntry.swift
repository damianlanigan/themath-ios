//
//  JournalEntry.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Alamofire

class JournalEntry {
    var categories: [CategoryType] = [CategoryType]()
    var note = ""
    var score: Int!
    var timestamp: NSDate!
    var lat: Double?
    var lng: Double?
    var locationAccuracy: Double?
    var geocodedLocationString: String?
    
    lazy var color: UIColor = {
        return UIColor.moodColorAtPercentage(CGFloat(self.score) / 100)
    }()
    
    var userGenerated = true
    var location: CLLocation? {
        get {
            if let lat = lat, lng = lng {
                return CLLocation(latitude: lat, longitude: lng)
            }
            return nil
        }
    }
    
    var shouldWaitOnLocation: Bool {
        return LocationCoordinator.isActive() && geocodedLocationString == nil
    }
    
    var hasLocation: Bool {
        return location != nil
    }
    
    lazy var formattedTimestamp: String = {
        let hour = self.timestamp.hour()
        let minute = self.timestamp.minute()
        let amPm = hour < 12 || hour == 24 ? "am" : "pm"
        
        return "\(hour.twelveHourClock()):\(minute.pad()) \(amPm)"
    }()
    
    // MARK: State
    var onSaveCallback: (() -> Void)?
    
    // overly confusing implementation. Race condition between
    // when user hits save and location/geocoding
    func save(completion: (() -> Void)? = nil) {
        if completion != nil {
            onSaveCallback = completion
        }
        
        if !shouldWaitOnLocation && onSaveCallback != nil {
            actuallySave()
        }
    }
    
    private func actuallySave() {
        
        // TODO: HANDLE ERROR
        
        print("ACTUALLY SAVING")
        
        let params = ["journal_entry" : asJSON()]
        request(Router.CreateJournalEntry(params)).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
            if result.isSuccess {
                if let data = result.value! as? [String: AnyObject] {
                    if let _ = data["errors"] as? [String: [String]] {
                        print("something went wrong")
                    } else {
                        if let callback = self.onSaveCallback {
                            callback()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Vendor
    
    func addLocation(location: CLLocation) {
        print("setting location... \(NSDate())")
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        locationAccuracy = location.horizontalAccuracy
        
        geocode()
    }
    
    private func geocode() {
        print("geocoding... \(NSDate())")
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!) { (places: [CLPlacemark]?, error:NSError?) -> Void in
            if let places = places {
                if places.count > 0 {
                    print(places[0].subLocality)
                    self.geocodedLocationString = places[0].subLocality
                }
            }
            print("finished geocoding... \(NSDate())")
            self.save()
        }
    }
    
    func delete() {
        print("delete this post")
    }
    
    private func asJSON() -> [String: AnyObject] {
        
        var json = [
            "score" : score,
            "timestamp" : timestamp,
            "categories" : categories.map { $0.rawValue },
            "note" : note == "Give some context to what's going on..." ? "" : note
        ]
        
        if let lat = lat, lng = lng, acc = locationAccuracy {
            json["lat"] = lat
            json["lng"] = lng
            json["location_accuracy"] = acc
            
            if let str = geocodedLocationString {
                json["location_string"] = str
            }
        }
        
        return json
    }
    
    class func fromJSONRequest(json: [String:AnyObject]) -> JournalEntry {
        let entry = JournalEntry()
        entry.note = json["note"] as! String
        entry.categories = (json["categories"] as! [String]).map { CategoryType(rawValue: $0.capitalizedString)! }
        
        // LOCATION NOT TRANSLATING TO TYPE
        if let lat = json["lat"] as? String {
            entry.lat = (lat as NSString).doubleValue
        }
        if let lng = json["lng"] as? String {
            entry.lng = (lng as NSString).doubleValue
        }
        
        entry.geocodedLocationString = json["location_string"] as? String
        entry.score = json["score"] as! Int
        
        let dateString = json["timestamp"] as! String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone(abbreviation: "GMT")
        let date = formatter.dateFromString(dateString)
        
        entry.timestamp = date!.dateAdjustedForLocalTime()
        
        return entry
    }
}
