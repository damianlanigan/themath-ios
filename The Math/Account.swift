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
    
    func signup(params: [String: AnyObject], callback: ((Bool, [String:[String]]?)) -> ()) {
        
        request(Router.SignupAccount(params)).responseJSON { (request: NSURLRequest?, response: NSHTTPURLResponse?, result: Result<AnyObject>) -> Void in
            if result.isSuccess {
                if let token = result.value!["access_token"] as? String {
                    self.setAccessToken(token)
                    callback((true, nil))
                } else {
                    callback((false, result.value!["errors"] as! [String: [String]]))
                }
            } else {
                print("there")
                callback((false, result.value!["errors"] as! [String: [String]]))
            }
        }
        
    }
    
    func login(params: [String: AnyObject], callback: (Bool) -> ()) {

        request(Router.LoginAccount(params)).responseJSON { (_, _, result: Result<AnyObject>) -> Void in
            
            // TODO: this should throw an error, not just butt out
            
            if result.isSuccess {
                if let token = result.value!["access_token"] as? String {
                    self.setAccessToken(token)
                    callback(true)
                } else {
                    callback(false)
                }
            } else {
                print("there")
                callback(false)
            }
        }
    }
    
    func isAuthenticated() -> Bool {
        let keychain = Keychain(service: AccountKeychainService)
        do {
            let token = try keychain.get(AccountAccessTokenKeychainKey)
            if token == nil {
                return false
            }
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
                print("set access token")
            } catch {
                print("failed to set access token")
            }
        } else {
            do {
                try keychain.remove(AccountAccessTokenKeychainKey)
                print("removed access token")
            } catch {
                print("failed to remove access token")
            }
        }
    }
    
    func logout(completion: () -> Void) {
        setAccessToken(nil)
        completion()
    }
   
}
