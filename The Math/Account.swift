//
//  Account.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 4/25/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit
import KeychainAccess
import Alamofire

class Account: NSObject {
    
    private let AccountKeychainService = "UserAccountKeychainService"
    private let AccountAccessTokenKeychainKey = "haid_access_token"
    
    var accessToken: String? {
        get {
            let keychain = Keychain(service: AccountKeychainService)
            do {
                let token = try keychain.get(AccountAccessTokenKeychainKey)
                return token
            } catch {
                return nil
            }
        }
    }
    
    class func sharedAccount() -> Account {
        struct Single {
            static let instance: Account = Account()
        }
        return Single.instance
    }
    
    class func currentUser() -> User {
        struct Single {
            static let instance: User = User()
        }
        return Single.instance
    }
    
    override init() {
        super.init()
        setAuthorizationHeader()
    }
    
    func signup(params: [String: AnyObject], callback: ((Bool, [String:[String]]?)) -> ()) {
        
        request(Router.SignupAccount(params)).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
            
        }
        
//        request(Router.SignupAccount(params)).responseJSON { (request, response, data, error) in
//            if let data = data as? [String: AnyObject] {
//                if let errors = data["errors"] as? [String: [String]] {
//                    callback((false, errors))
//                } else {
//                    self.setAccessToken(data["access_token"] as? String)
//                    callback((true, nil))
//                }
//            }
//        }
    }
    
    func login(params: [String: AnyObject], callback: ((Bool, [String:[String]]?)) -> ()) {

        request(Router.LoginAccount(params)).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
        
        }
        
//        request(Router.LoginAccount(params)).responseJSON { (request, response, data, error) in
//            if let response = response {
//                if response.statusCode != 200 {
//                    callback((false, nil))
//                } else {
//                    if let data = data as? [String: AnyObject] {
//                        self.setAccessToken(data["access_token"] as? String)
//                        callback((true, nil))
//                    }
//                }
//            } else {
//                callback((false, nil))
//            }
//        }
    }
    
    func isAuthenticated() -> Bool {
        let keychain = Keychain(service: AccountKeychainService)
        do {
            try keychain.get(AccountAccessTokenKeychainKey)
            return true
        } catch {
            return false
        }
    }
    
    private func setAccessToken(token: String?) {
        let keychain = Keychain(service: AccountKeychainService)
        if let token = token {
            do {
                try keychain.set(token, key: AccountAccessTokenKeychainKey)
                setAuthorizationHeader()
            } catch {}
        } else {
            do {
                try keychain.remove(AccountAccessTokenKeychainKey)
            } catch {}
        }
    }
    
    private func setAuthorizationHeader() {
        if let _ = accessToken {
//            Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?["Authorization"] = "Bearer \(token)"
            print("set authorization header")
//            println("\(Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders)")
        }
    }
    
    
    func logout(completion: () -> Void) {
        setAccessToken(nil)
        completion()
    }
   
}
