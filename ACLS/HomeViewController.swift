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

class HomeViewController: UIViewController, DataSentDelegate {
    
    var refUsers: DatabaseReference!
    
    struct GlobalVariable{
        static var  key2 = String()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refUsers = Database.database().reference().child("users")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBAction func DeleteAccount(_ sender: Any) {
 
    
                var refreshAlert = UIAlertController(title: "Delete Account", message: "Are you sure you want to Delete your Account ? ", preferredStyle: .alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                    Auth.auth().currentUser?.delete(completion: { (err) in
                        
                        do {
                            /*let main = UIStoryboard(name: "Main", bundle: nil)
                            let second = main.instantiateViewController(withIdentifier: "SignUp")
                            self.present(second, animated: false, completion: nil)*/
                            
                            self.deleteUserData()
                            try Auth.auth().signOut()
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    })
                    
                    let main = UIStoryboard(name: "Main", bundle: nil)
                    let second = main.instantiateViewController(withIdentifier: "SignUp")
                    self.present(second, animated: true, completion: nil)
                    
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
                    let second = main.instantiateViewController(withIdentifier: "SignUp")
                present(second, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func deleteUserData(){
        
      // let key = refUsers.childByAutoId().key
        
         self.refUsers.child(GlobalVariable.key2).removeValue()
        
        print("datadeleted")
    }
    
    
    func userDidEnterData(data: String) {
        GlobalVariable.key2 = data
    }
    
    // i need a segue from signup viewcontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUp" {
            let signUpViewController: SignUpViewController = segue.destination as! SignUpViewController
            signUpViewController.delegate = self
        }
        
}
}
