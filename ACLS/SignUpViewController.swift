//
//  SignUpViewController.swift
//  ACLS
//
//  Created by Hamza Ali on 10/26/18.
//  Copyright © 2018 Hamza Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class SignUpViewController: UIViewController {
    
    var refUsers: DatabaseReference!
    
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var GenderTextField: UITextField!
    
    
    @IBOutlet weak var birthdateTextField: UITextField!
    @IBOutlet weak var emergencyFirstNameTextField: UITextField!
    @IBOutlet weak var emergencyLastNameTextField: UITextField!
    @IBOutlet weak var emergencyPhoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super .viewDidLoad()
        FirebaseApp.configure()
        refUsers = Database.database().reference().child("users")
    }
    
    
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        
       
        if emailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        // ...
                        
                        print(error?.localizedDescription)
                        
                        let signUpAlert = UIAlertController(title: "Please verify your email", message: "Email Sent!", preferredStyle: .alert)
                        signUpAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(signUpAlert, animated: true, completion: nil)
                        
                       
                        
                }
                }
                
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
      addUsers()
    }
    
    func addUsers(){
        let key = refUsers.childByAutoId().key
        
        let user = ["id:":key,
                    "FirstName:": firstNameTextField.text! as String,
                    "LastName:": lastNameTextField.text! as String,
                    "E-mail:": emailTextField.text! as String,
                    "Gender:": GenderTextField.text! as String,
                    "Birthdate:": birthdateTextField.text! as String,
                    "EmergencyFirstName:": emergencyFirstNameTextField.text! as String,
                    "EmergencyLastName:": emergencyLastNameTextField.text! as String,
                    "EmergencyPhone:": emergencyPhoneNumberTextField.text! as String
        ]
        refUsers.child("key").setValue(user)
    }
}

