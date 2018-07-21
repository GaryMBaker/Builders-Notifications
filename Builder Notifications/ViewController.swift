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

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var pickerTextField: UITextField?

    @IBOutlet weak var  registerPassword: UITextField?
    @IBOutlet weak var  registerName: UITextField?
    @IBOutlet weak var  registerJobSite: UITextField?
    @IBOutlet weak var  registerEmail: UITextField?
    
    @IBOutlet weak var loginEmail: UITextField?
    @IBOutlet weak var loginPassword: UITextField?
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var handleDB = DatabaseHandle()
    var notificationHandler = DatabaseHandle()
    var pickOption = [String]()
    var notificationList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerTextField?.inputView = pickerView
        
        let ref = Database.database().reference()
        registerEmail?.delegate = self
        registerPassword?.delegate = self
        registerName?.delegate = self
        handleDB = ref.child("locations").observe(.childAdded) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let data = snap.value as? String {
                        self.pickOption.append(data)
                    }
                }
            }
        }
        
        
        notificationHandler = ref.child("notifications").observe(.childAdded) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let data = snap.value as? String {
                        self.notificationList.append(data)
                    }
                }
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField?.text = pickOption[row]
    }
    
    
    
    
    @IBAction func userLogin(sender: UIButton) {
        
        let password: String = loginPassword!.text!
        let email: String = loginEmail!.text!
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if user != nil {
                self.performSegue(withIdentifier: "AuthenticatedSegue", sender: nil)
            }
        }
    }
    
    @IBAction func userRegistered(sender: UIButton) {
        let password: String = registerPassword!.text!
        let name: String = registerName!.text!
        let jobsite: String = registerJobSite!.text!
        let email: String = registerEmail!.text!
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            print("User Created");
            
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { error in })
            }
            
            let userID = Auth.auth().currentUser!.uid
            Database.database().reference().child("users").child(userID).setValue(["Name": name, "Job Site": jobsite, "messaging_token": Messaging.messaging().fcmToken!, "user_id": userID])
        }
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        registerName?.resignFirstResponder()
        registerPassword?.resignFirstResponder()
        registerEmail?.resignFirstResponder()
        pickerTextField?.resignFirstResponder()
    
        return true
    }
}

