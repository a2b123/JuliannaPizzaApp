//
//  APIManager.swift
//  JuliannasPizzaApp
//
//  Created by Amar Bhatia on 8/1/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FBSDKLoginKit

class APIManager {
    
    // create a singleton that doesnt get used again
    static let shared = APIManager()
    let baseURL = NSURL(string: "localhost:8000/")
    
    var accessToken = ""
    var refreshToken = ""
    var expired = Date()
    
    // API to login a user
    func login(userType: String, completionHandler: @escaping (NSError?) -> Void) {
        print("Your token String: \(FBSDKAccessToken.current().tokenString)")
        let path = "api/social/convert-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "grant_type": "convert_token",
            "client_id" : CLIENT_ID,
            "client_secret" : CLIENT_SECRET,
            "backend" : "facebook",
            "token" : FBSDKAccessToken.current().tokenString,
            "user_type" : userType
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let jsonData = JSON(value)
                self.accessToken = jsonData["access_token"].string!
                self.refreshToken = jsonData["refresh_token"].string!
                self.expired = Date().addingTimeInterval(TimeInterval(jsonData["expires_in"].int!))
                
                print(jsonData)
                
                completionHandler(nil)
                break
                
            case .failure(let error):
                completionHandler(error as NSError)
                break
                
            }
        }
    }
    
    // API to logout a user
    func logout(completionHandler: @escaping (NSError?) -> Void) {
        let path = "api/social/revoke-token/"
        let url = baseURL!.appendingPathComponent(path)
        let params: [String: Any] = [
            "client_id" : CLIENT_ID,
            "client_secret" : CLIENT_SECRET,
            "token": self.accessToken
        ]
        
        Alamofire.request(url!, method: .post, parameters: params, encoding: URLEncoding(), headers: nil).responseString { (response) in
            switch response.result {
            case .success:
                completionHandler(nil)
                break
            
            case .failure(let error):
                completionHandler(error as NSError)
                break
            }
        }
    }
    
    // API to refresh the token when it's expired
    
    func refreshTokenIfNeeded(completionHandler: @escaping () -> Void) {
        let path = "api/social/refresh-token/"
        let url = baseURL?.appendingPathComponent(path)
        let param: [String: Any] = [
            "access_token": self.accessToken,
            "refresh_token": self.refreshToken
            
        ]
        
        if (Date() > self.expired) {
        }
    }

    
    
}
