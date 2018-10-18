//
//  ViewController.swift
//  ACLS
//
//  Created by Hamza Ali on 10/11/18.
//  Copyright © 2018 Hamza Ali. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: Any) {
        
     // Check if the user has verified their email, Check if the email format is correct, login to the home page if all conditions are met
        Auth.auth().signIn(withEmail: textFieldLoginEmail.text!, password: textFieldLoginPassword.text!) { (user, error) in
            if error == nil{
                
                Auth.auth().signIn(withEmail: self.textFieldLoginEmail.text!, password: self.textFieldLoginPassword.text!) { (authResult, error) in
                    if let authResult = authResult {
                        let user = authResult.user
                        if user.isEmailVerified {
                            self.performSegue(withIdentifier: "LoginToList" , sender: self)
                        } else {
                            let alert = UIAlertController(title: "Error", message: "Please verify email", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    if let error = error {
                        print("Cant Sign in user")
                    }
                }
            }
            else{
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
}

    // Sign out user and go back to main screen
    @IBAction func signOutDidTouch(_ sender: Any) {
    do {
    try Auth.auth().signOut()
    }
    catch let signOutError as NSError {
    print ("Error signing out: %@", signOutError)
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let initial = storyboard.instantiateInitialViewController()
    UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    // Register user to firebase and send a verification email
   @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Register",
                                      message: "Register",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let emailField = alert.textFields![0]
                                        let passwordField = alert.textFields![1]
                                        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) {
                                            user, error in
                                            if error != nil {
                                                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                                                    switch errorCode {
                                                    case .weakPassword:
                                                        print("Please provide a strong password")
                                                    default:
                                                        print("There is an error")
                                                    }
                                                    
                                                }
                                            }
                                            if user != nil {
                                                Auth.auth().currentUser?.sendEmailVerification { (error) in
                                                    // ...
                                                
                                                    print(error?.localizedDescription)
                                                }
                                            }
                                        }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
}


