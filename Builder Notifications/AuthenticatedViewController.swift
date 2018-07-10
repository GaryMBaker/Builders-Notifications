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

class AuthenticatedViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var pickerTextField: UITextField?
    @IBOutlet weak var locationTextField: UITextField?
    @IBOutlet weak var  registerPassword: UITextField?
    @IBOutlet weak var  registerName: UITextField?
    @IBOutlet weak var  registerJobSite: UITextField?
    @IBOutlet weak var  registerEmail: UITextField?
    @IBOutlet weak var  post: UITextField?
    @IBOutlet weak var  location: UITextField?
    
    
    var handle = DatabaseHandle()
    var notificationHandler = DatabaseHandle()
    var pickOption = [String]()
    var notificationList = [String]()
    
    
    @IBAction func forgotPasswordTapped(_ sender: Any) {
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        forgotPasswordAlert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
            let resetEmail = forgotPasswordAlert.textFields?.first?.text
            Auth.auth().sendPasswordReset(withEmail: resetEmail!, completion: { (error) in
                if error != nil{
                    let resetFailedAlert = UIAlertController(title: "Reset Failed", message: "Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
                    resetFailedAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetFailedAlert, animated: true, completion: nil)
                }else {
                    let resetEmailSentAlert = UIAlertController(title: "Reset email sent successfully", message: "Check your email", preferredStyle: .alert)
                    resetEmailSentAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(resetEmailSentAlert, animated: true, completion: nil)
                }
            })
        }))
        //PRESENT ALERT
        self.present(forgotPasswordAlert, animated: true, completion: nil)
    }
    
    @IBAction func sendPost(sender: UIButton) {
        let post: String? = self.post!.text!
        
        Database.database().reference().child("notifications").childByAutoId().setValue(["post": post])
        
        
        Messaging.messaging().sendMessage(["body" : "messageData"], to: "184904612529@gcm.googleapis.com", withMessageID: "messageId", timeToLive: 200)
    }
 
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
        var ref = Database.database().reference().child("locations").childByAutoId();
        
        let forgotPasswordAlert = UIAlertController(title: "Forgot password?", message: "Enter email address", preferredStyle: .alert)
        forgotPasswordAlert.addTextField { (textField) in
            textField.placeholder = "Enter email address"
        }
        forgotPasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        self.pickerTextField?.inputView = pickerView
        
        let ref = Database.database().reference()
        
        let tableView = UITableView()
        tableView.delegate = self
        
        notificationHandler = ref.child("notifications").observe(.childAdded) { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot {
                    if let data = snap.value as? String {
                        self.notificationList.append(data)
                    }
                }
            }
        }
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell();
        cell.textLabel?.text = notificationList[indexPath.row]
        
        return cell
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
