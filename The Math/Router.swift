//
//  Router.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/24/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    static let baseURLString = DEBUG ? "http://localhost:3000" : "http://themath-api.herokuapp.com"
    static let urlProtocol = "http://"
    static let urlDomain = DEBUG ? "localhost:3000" : "themath-api.herokuapp.com"
    static let apiPath = "/api"
    static let apiVersion = "/v1"

    case SignupAccount([String: AnyObject])
    case LoginAccount([String: AnyObject])
    case CreateJournalEntry([String: AnyObject])
    case AverageScore([String: AnyObject])
    case JournalEntries([String: AnyObject])
    case LatestJournalEntry()
    
    var method: Alamofire.Method {
        switch self {
        case .SignupAccount:
            return .POST
        case .LoginAccount:
            return .POST
        case .CreateJournalEntry:
            return .POST
        case .AverageScore:
            return .GET
        case .JournalEntries:
            return .GET
        case .LatestJournalEntry:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .SignupAccount:
            return "/signup"
        case .LoginAccount:
            return "/oauth/token"
        case .CreateJournalEntry:
            return "/users/self/journal_entry"
        case .AverageScore:
            return "/users/self/reports/average_score_by_date"
        case .JournalEntries:
            return "/users/self/journal_entries"
        case .LatestJournalEntry:
            return "/users/self/journal_entries/latest"
        }
    }
    
    var base: String {
        switch self {
            case .LoginAccount:
                return Router.baseURLString
            default:
                return Router.getAPIUrl()
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: base)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
            case .LoginAccount(let parameters):
                return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .SignupAccount(let parameters):
                return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .CreateJournalEntry(let parameters):
                return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .AverageScore(let parameters):
                return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            case .JournalEntries(let parameters):
                return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
            default:
                return mutableURLRequest
        }
    }
    
    static func getAPIUrl() -> String {
        return "\(urlProtocol)\(urlDomain)\(apiPath)\(apiVersion)"
    }

}