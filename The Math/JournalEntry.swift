//
//  JournalEntry.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/21/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import CoreLocation

class JournalEntry {
    var categories: [CategoryType] = [CategoryType]()
    var note = ""
    var score: Int!
    var timestamp: NSDate!
    var lat: Double?
    var lng: Double?
    var locationAccuracy: Double?
    var locationString: String?
    
    var userGenerated = true
    var commitForSave = false
    var location: CLLocation? {
        get {
            if let lat = lat, lng = lng {
                return CLLocation(latitude: lat, longitude: lng)
            }
            return nil
        }
    }
    
    // MARK: State
    var waitingOnGeocode = false
    var onSaveCallback: (() -> Void)?
    
    func save(completion: (() -> Void)? = nil) {
        onSaveCallback = completion
        commitForSave = true
        
        if !waitingOnGeocode {
           actuallySave()
        }
    }
    
    private func actuallySave() {
        request(Router.CreateJournalEntry(["journal_entry" : asJSON()])).responseJSON { (request, response, data, error) in
            if let data = data as? [String: AnyObject] {
                if let errors = data["errors"] as? [String: [String]] {
                    println("something went wrong")
                } else {
                    if let callback = self.onSaveCallback {
                        callback()
                    }
                }
            }
        }
    }
    
    // MARK: Vendor
    
    func addLocation(location: CLLocation) {
        println("setting location... \(NSDate())")
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        locationAccuracy = location.horizontalAccuracy
        
        geocode()
    }
    
    private func geocode() {
        println("geocoding... \(NSDate())")
        waitingOnGeocode = true
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (places: [AnyObject]!, error: NSError!) -> Void in
            if let place = places[0] as? CLPlacemark {
                println(place.subLocality)
                self.locationString = place.subLocality
            }
            println("finished geocoding... \(NSDate())")
            self.waitingOnGeocode = false
            if self.commitForSave {
                self.save()
            }
        })
    }
    
    func delete() {
        println("delete this post")
    }
    
    private func asJSON() -> [String: AnyObject] {
        
        var json = [
            "score" : score,
            "timestamp" : timestamp,
            "categories" : categories.map { $0.rawValue },
            "note" : note == "Add a note..." ? "" : note
        ]
        
        if let lat = lat, lng = lng, acc = locationAccuracy {
            json["lat"] = lat
            json["lng"] = lng
            json["location_accuracy"] = acc
            
            if let str = locationString {
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
            entry.lat = lat.doubleValue()
        }
        if let lng = json["lng"] as? String {
            entry.lng = lng.doubleValue()
        }
        
        entry.locationString = json["location_string"] as? String
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