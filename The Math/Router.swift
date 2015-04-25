//
//  Router.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/24/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import Foundation

enum Router: URLRequestConvertible {
    
    static let urlProtocol = "https://"
    static let urlDomain = "www.digitsu.com"
    static let apiPath = "/api"
    static let apiVersion = "/1.0"
    static let imagesPath = "/images"
    static var credentials: String?
    
    case LoginAccount([String: AnyObject])
    case ReadLibrary([String: AnyObject])
    case ReadProducts([String: AnyObject])
    case ReadVideoClips(String)
    case addWishlisted(String)
    case deleteWishlisted(String)
    
    var method: Method {
        switch self {
        case .LoginAccount,.addWishlisted:
            return .POST
        case .ReadProducts,.ReadLibrary,.ReadVideoClips:
            return .GET
        case .deleteWishlisted:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .LoginAccount:
            return "/accounts/login.json"
        case .ReadLibrary:
            return "/products/self/library.json"
        case .ReadProducts:
            return "/products.json"
        case .ReadVideoClips(let productId):
            return "/products/\(productId)/video_clips.json"
        case .addWishlisted(let productId):
            return "/products/\(productId)/wishlist.json"
        case .deleteWishlisted(let productId):
            return "/products/\(productId)/wishlist.json"
        }
    }
    
    var URLRequest: NSURLRequest {
        
        let URL = NSURL(string: Router.getAPIUrl())!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let credentials = Router.credentials {
            mutableURLRequest.setValue("Basic \(credentials)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .LoginAccount(let parameters):
            return ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .ReadLibrary(let parameters):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        case .ReadProducts(let parameters):
            return ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
    
    static func getAPIUrl() -> String {
        return "\(urlProtocol)\(urlDomain)\(apiPath)\(apiVersion)"
    }
    
    static func setCredentials(emailAddress: String, password: String) {
        let plainString = "\(emailAddress):\(password)" as NSString
        let plainData = plainString.dataUsingEncoding(NSUTF8StringEncoding)
        credentials = plainData?.base64EncodedStringWithOptions(.allZeros)
    }

}