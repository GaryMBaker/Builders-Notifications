//
//  containerVC.swift
//  Builder Notifications
//
//  Created by Shea Paris on 23/07/18.
//  Copyright © 2018 Gary Baker. All rights reserved.
//

import UIKit

class containerVC: UIViewController {

     @IBOutlet weak var SideMenuConstraint: NSLayoutConstraint!
     var sideMenuOpen = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu),name:NSNotification.Name("toggleSideMenu"), object: nil)
        
    }
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            sideMenuOpen = false
            SideMenuConstraint.constant = -187
        } else {
            sideMenuOpen = true
            SideMenuConstraint.constant = 0
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}
