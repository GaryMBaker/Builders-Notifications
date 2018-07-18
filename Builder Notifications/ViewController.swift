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


    @IBOutlet weak var jobsite: UITextField!
    @IBOutlet weak var pickerTextField: UITextField!
    
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
        let toolbar = UIToolbar(frame: CGRect(x:0,y: 0,width:self.view.frame.size.width, height:40))
        toolbar.barStyle = UIBarStyle.blackTranslucent
        toolbar.tintColor = UIColor.white
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ViewController.donePressed(sender:)))
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0,y: 0, width:self.view.frame.size.width/3, height: 40))
        
        label.font = UIFont.systemFont(ofSize: 14)
        
        label.textColor = UIColor.yellow
        
        label.textAlignment = NSTextAlignment.center
        
        label.text = "Jobsite"
        
        let labelButton = UIBarButtonItem(customView: label)
        
        toolbar.setItems([flexButton, flexButton, labelButton, flexButton, doneButton], animated:true)
        
        pickerTextField?.inputAccessoryView = toolbar
        
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
        let jobsite: String = self.jobsite!.text!
        let email: String = registerEmail!.text!

        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            print("User Created");
            
            let userID = Auth.auth().currentUser!.uid
            Database.database().reference().child("users").child(userID).setValue(["Name": name, "Job Site": jobsite])
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
    @objc func donePressed(sender: UIBarButtonItem) {
        pickerTextField.resignFirstResponder()
    }
}

