//
//  LoginViewController.swift
//  JuliannasPizzaApp
//
//  Created by Amar Bhatia on 7/31/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var fbLoginSuccess = false
    var userType: String = USERTYPE_CUSTOMER

    @IBOutlet weak var fbLoginButton: UIButton!
    @IBOutlet weak var useDifferentAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (FBSDKAccessToken.current() != nil) {
            useDifferentAccountButton.isHidden = false
            FBManager.getFBUserData(completionHandler: { 
                self.fbLoginButton.setTitle("Continue as \(User.currentUser.email!)", for: .normal)
//                self.fbLoginButton.sizeToFit()
            })
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil && fbLoginSuccess == true) {
            performSegue(withIdentifier: "CustomerView", sender: self)
        }
    }
    
    // FB Login

    @IBAction func fbLogin(_ sender: Any) {
        if (FBSDKAccessToken.current() != nil) {
            
            APIManager.shared.login(userType: userType, completionHandler: { (error) in
                self.self.fbLoginSuccess = true
                self.viewDidAppear(true)
            })
        } else {
            
            FBManager.shared.logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (result, error) in
                
                
                if (error == nil) {
                    FBManager.getFBUserData(completionHandler: {
                        APIManager.shared.login(userType: self.userType, completionHandler: { (error) in
                            self.self.fbLoginSuccess = true
                            self.viewDidAppear(true)
                        })
                    })
                }
            })
        }
    }
    
    
    // FB Logout
    @IBAction func useDifferentAccountButtonPressed(_ sender: Any) {
        
        APIManager.shared.logout { (error) in
            if error == nil {
                FBManager.shared.logOut()
                User.currentUser.resetInfo()
                
                self.useDifferentAccountButton.isHidden = true
                self.useDifferentAccountButton.setTitle("Login with Facebook", for: .normal)
            }
        }
        
    }
    
}





