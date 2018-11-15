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

class HomeViewController: UIViewController {
    
    var refUsers: DatabaseReference!
    
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
                            self.deleteUserData()
                            try Auth.auth().signOut()
                        } catch let error as NSError {
                            print(error.localizedDescription)
                        }
                    })
                    
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                    self.present(vc, animated: true, completion: nil)
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
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func deleteUserData(){
        
       let key = refUsers.childByAutoId().key
        
         self.refUsers.child(key!).removeValue()
        
        print("datadeleted")
    }
   

}
