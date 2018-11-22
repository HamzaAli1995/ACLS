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
    
    var refUsers: DatabaseReference!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        refUsers = Database.database().reference().child("users")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func sendMessage(_ sender: AnyObject) {
        
        // send message to +18322963652 (you can put your number to check)
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        let someString = "+18322963652"
        let smsMessageBody = "Hello from ACLS app!"
        let parameters: Parameters = [
            "To": someString ?? "",
            "Body": smsMessageBody ?? ""
        ]
        
        Alamofire.request("http://e0dc7faa.ngrok.io/sms", method: .post, parameters: parameters, headers: headers).responseJSON { response in
            print(response.response)
            
        }
    }
    
    
    @IBAction func DeleteAccount(_ sender: Any) {
 
    
                var refreshAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to Delete your Account ? ", preferredStyle: .alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                    Auth.auth().currentUser?.delete(completion: { (err) in
                        
                        do {
                            let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                            
                            
                            print("key from signupVC = \(SignUpViewController.GlobalVariable.key)")
                            
                            self.deleteUserData()
                            
                            try Auth.auth().signOut()
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    })
                    
                    let main = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
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
        
        self.refUsers.child(SignUpViewController.GlobalVariable.key).removeValue()
        
        print("datadeleted")
    }
    
}
