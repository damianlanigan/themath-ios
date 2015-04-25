//
//  Router.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/24/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation

enum Router: URLRequestConvertible {
    static let baseURLString = "http://localhost:3000"
    static let urlProtocol = "http://"
    static let urlDomain = "localhost:3000"
    static let apiPath = "/api"
    static let apiVersion = "/v1"
    static var credentials: String?
    
    case SignupAccount([String: AnyObject])
    case LoginAccount([String: AnyObject])
    
    var method: Method {
        switch self {
        case .SignupAccount:
            return .POST
        case .LoginAccount:
            return .POST
        }
    }
    
    var path: String {
        switch self {
        case .SignupAccount:
            return "/signup"
        case .LoginAccount:
            return "/oauth/token"
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
        default:
            return mutableURLRequest
        }
    }
    
    static func getAPIUrl() -> String {
        return "\(urlProtocol)\(urlDomain)\(apiPath)\(apiVersion)"
    }

}