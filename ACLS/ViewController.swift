//
//  ViewController.swift
//  ACLS
//
//  Created by Hamza Ali on 10/11/18.
//  Copyright © 2018 Hamza Ali. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var siginInLabel: UILabel!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signInButton: UIButton!
    
    var isSignIn:Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        
        // Flip the boolean
        isSignIn = !isSignIn
        
        // Check the bool and set the button and labels
        if isSignIn {
            siginInLabel.text = "Sign In"
            signInButton.setTitle("Sign In", for: .normal)
        }
        else {
            siginInLabel.text = "Register"
            signInButton.setTitle("Register", for: .normal)
        }
    }
 
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        
        if let email = emailTextField.text, let password = passwordTextField.text
        {
        
        // Check if it's sign in or register
        if isSignIn {
            // Sign in the user with Firebase
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                // Check that user isn't nil
                if let u = user {
                    // User is found, go to Home Screen
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
                else{
                    // Error: Check error and show message
                    
                }
                
            }
            
        }
        else {
            // Register the user with Firebase
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                
                // Check that user isn't nil
                if let u = user {
                    // User is found, go to Home Screen
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                }
                else{
                    // Error: Check error and show message
                    
               
                }
       
            }
            
            }

        }
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard when the view is tapped on
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}

