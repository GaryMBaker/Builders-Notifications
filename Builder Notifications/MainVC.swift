//
//  MainVC.swift
//  Builder Notifications
//
//  Created by Shea Paris on 23/07/18.
//  Copyright © 2018 Gary Baker. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
       NotificationCenter.default.addObserver(self, selector: #selector(ShowNotifications),name:NSNotification.Name("ShowNotifications"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShowAccount),name:NSNotification.Name("ShowAccount"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ShowAdmin),name:NSNotification.Name("ShowAdmin"), object: nil)
    }
    
    @objc func ShowNotifications() {
    performSegue(withIdentifier: "ShowNotifications", sender: nil)
    }
    
    @objc func ShowAccount() {
        performSegue(withIdentifier: "ShowAccount", sender: nil)
    }
    
    @objc func ShowAdmin() {
        performSegue(withIdentifier: "ShowAdmin", sender: nil)
    }
    
    @IBAction func MoreButtonTapped() {
        print("more button tapped")
        NotificationCenter.default.post(name: NSNotification.Name("toggleSideMenu"), object: nil)
    }
}
