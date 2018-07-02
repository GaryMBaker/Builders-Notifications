//
//  ViewController.swift
//  Builder Notifications
//
//  Created by Gary Baker on 2/07/18.
//  Copyright © 2018 Gary Baker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var likeButton: UIButton?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var passWord: UIInputView?

    
    
    @IBAction func likedThis(sender: UIButton) {
        userName?.text = "Blah"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
       
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

