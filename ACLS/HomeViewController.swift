//
//  HomeViewController.swift
//  ACLS
//
//  Created by Hamza Ali on 10/26/18.
//  Copyright © 2018 Hamza Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Alamofire

class HomeViewController: UIViewController {
    
    var refUsersHome: DatabaseReference!
    var SMSsent: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refUsersHome = Database.database().reference().child("users")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        
        if Auth.auth().currentUser?.uid == nil {
            print("user is not logged in for SMS")
        } else {
            print("userlogged in for SMS")
            
            //UserID
            let uid = Auth.auth().currentUser!.uid
            print("UserID:\(uid)")
            
            //timestamp
            let timestamp = NSDate().timeIntervalSince1970
            print("Timestamp: \(timestamp)")
            
            func instance (){
                
                let loginInstance = ["UserID:": uid,
                                     "TimeStamp": timestamp,
                                     "SMSsent": SMSsent
                    ] as [String : Any]
                
                Database.database().reference().child("LogIn Instance").childByAutoId().setValue(loginInstance)
            }
                
                instance()
            
              Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                let emergrncyphone = snapshot.childSnapshot(forPath: "EmergencyPhone:" ).value
                print("emergrncy phone number from database:\(emergrncyphone!)")

                let headers = [
                    "Content-Type": "application/x-www-form-urlencoded"
                ]
               // let someString = "+18322963652"
                let smsMessageBody = "Hello from ACLS app!"
                let parameters: Parameters = [
                    "To":  emergrncyphone ?? "",
                    "Body": smsMessageBody ?? ""
                ]
                
                Alamofire.request("http://e60bd524.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).responseJSON { response in
                    print(response.response)
                    
                }
              })
            }
    }
    
    @IBAction func DeleteAccount(_ sender: Any) {
 
                var refreshAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to Delete your Account ? ", preferredStyle: .alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                    self.deleteUserData()

                    Auth.auth().currentUser?.delete(completion: { (err) in
                        
                        do {
                            let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                         
                            try Auth.auth().signOut()
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    })
                    
                    let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogIn")
                    self.present(main, animated: true, completion: nil)
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                    
                    refreshAlert .dismiss(animated: true, completion: nil)
                    
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let main = UIStoryboard(name: "Main", bundle: nil)
                    let second = main.instantiateViewController(withIdentifier: "LogIn")
                present(second, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteUserData(){
        if Auth.auth().currentUser?.uid == nil {
            print("user is not logged in for delete")
        } else {
            print("userlogged in for delete")
            let uid2 = Auth.auth().currentUser!.uid
            print(uid2)
            
        self.refUsersHome.child(uid2).removeValue()
        print("datadeleted")
    }
    
}
}
