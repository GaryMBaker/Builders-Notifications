//
//  AuthenticatedViewController.swift
//  Builder Notifications
//
//  Created by Gary Baker on 3/07/18.
//  Copyright © 2018 Gary Baker. All rights reserved.
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AuthenticatedViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {

    @IBOutlet weak var pickerTextField: UITextField?
    @IBOutlet weak var locationTextField: UITextField?
    @IBOutlet weak var  registerPassword: UITextField?
    @IBOutlet weak var  registerName: UITextField?
    @IBOutlet weak var  registerJobSite: UITextField?
    @IBOutlet weak var  registerEmail: UITextField?
    @IBOutlet weak var  post: UITextField?
    @IBOutlet weak var  location: UITextField?
    
    var handle = DatabaseHandle()
    var pickOption = [String]()
    
    @IBAction func sendPost(sender: UIButton) {
        let post: String = self.post!.text!
        let userID = Auth.auth().currentUser!.uid
        let userName = Auth.auth().currentUser!.displayName


        Database.database().reference().child("notifications").childByAutoId().setValue(["post": post])
    }
 //test commit
   
    @IBAction func authLogout(sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error while signing out!")
        }
    }
  
    @IBAction func addLocation(sender: UIButton) {
        let location: String = self.location!.text!
        Database.database().reference().child("locations").childByAutoId().setValue(["location": location])
    }
    
    @IBAction func removeLocation(sender: UIButton) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.pickerTextField?.inputView = pickerView
        
        let ref = Database.database().reference()
        
        handle = ref.child("locations").observe(.childAdded) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let data = snap.value as? String {
                        self.pickOption.append(data)
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
        pickerTextField!.text = pickOption[row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
