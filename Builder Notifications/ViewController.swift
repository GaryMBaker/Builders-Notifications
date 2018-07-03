//
//  ViewController.swift
//  Builder Notifications
//
//  Created by Gary Baker on 2/07/18.
//  Copyright © 2018 Gary Baker. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var likeButton: UIButton?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var passWord: UIInputView?
    
    @IBOutlet weak var  registerUsername: UITextField?
    @IBOutlet weak var  registerPassword: UITextField?
    @IBOutlet weak var  registerName: UITextField?
    @IBOutlet weak var  registerJobSite: UITextField?
    @IBOutlet weak var  registerEmail: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func likedThis(sender: UIButton) {
        userName?.text = "Blah"
    }
    
    @IBAction func userRegistered(sender: UIButton) {
        
        let uname: String = registerUsername!.text!
        let password: String = registerPassword!.text!
        let name: String = registerName!.text!
        let jobsite: String = registerJobSite!.text!
        
        Database.database().reference().child("users").child("Gary").setValue(["Username": uname, "Password": password, "Name": name, "Job Site": jobsite])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

