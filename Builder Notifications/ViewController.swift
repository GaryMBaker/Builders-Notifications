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
    
    @IBOutlet weak var loginEmail: UITextField?
    @IBOutlet weak var loginPassword: UITextField?
    
    
    var handle: AuthStateDidChangeListenerHandle?

    @IBAction func likedThis(sender: UIButton) {
        
        let password: String = loginPassword!.text!
        let email: String = loginEmail!.text!
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            self.userName?.text = "Sucessfully signed in!"
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func userRegistered(sender: UIButton) {
        let uname: String = registerUsername!.text!
        let password: String = registerPassword!.text!
        let name: String = registerName!.text!
        let jobsite: String = registerJobSite!.text!
        let email: String = registerEmail!.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            print("User Created");
        }
        
        Database.database().reference().child("users").child("Gary").setValue(["Username": uname, "Name": name, "Job Site": jobsite])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
}

