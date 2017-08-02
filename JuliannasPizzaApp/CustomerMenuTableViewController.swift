//
//  CustomerMenuTableViewController.swift
//  JuliannasPizzaApp
//
//  Created by Amar Bhatia on 7/30/17.
//  Copyright © 2017 AmarBhatia. All rights reserved.
//

import UIKit

class CustomerMenuTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 120/255, green: 1/255, blue: 22/255, alpha: 1)
        
        nameLabel.text = User.currentUser.name
        profileImageView.image = try! UIImage(data: Data(contentsOf: URL(string: User.currentUser.pictureURL!)!))
        profileImageView.layer.cornerRadius = 70/2
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 1.0
        profileImageView.layer.borderColor = UIColor.white.cgColor

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomerLogout" {
            
            APIManager.shared.logout(completionHandler: { (error) in
                
                if error == nil {
                    FBManager.shared.logOut()
                    User.currentUser.resetInfo()
                }
                
            })
            
        }
    }

}
