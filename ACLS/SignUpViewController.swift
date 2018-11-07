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
    var mysegementBool : Bool = true
    private var datePicker: UIDatePicker?
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var birthdateTextField: UITextField!
    
    @IBOutlet weak var emergencyFirstNameTextField: UITextField!
    @IBOutlet weak var emergencyLastNameTextField: UITextField!
    @IBOutlet weak var emergencyPhoneNumberTextField: UITextField!
    
    @IBOutlet weak var segmentedControllor: UISegmentedControl!
   
    
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
                        
                        self.addUsers()    /// add user info to database
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
      
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        
        switch segmentedControllor.selectedSegmentIndex{
        case 0:
            mysegementBool = true
        case 1:
            mysegementBool = false
        default:
            break
        }
             print(mysegementBool)
    }
    
    
    
    
    override func viewDidLoad() {
        super .viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignUpViewController.dateChanged(datePicker:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        birthdateTextField.inputView = datePicker
        
        refUsers = Database.database().reference().child("users")
        
    }
    
    
    @objc func dateChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
        view.endEditing(true)
        
    }
    
    func addUsers(){
        let key = refUsers.childByAutoId().key
        
        let user = ["id:":key!,
                    "FirstName:": firstNameTextField.text! as String,
                    "LastName:": lastNameTextField.text! as String,
                    "E-mail:": emailTextField.text! as String,
                    "isMale": mysegementBool, ////read boolean value
                    "Birthdate:": birthdateTextField.text! as String,   //convert it to integer instead
                    "EmergencyFirstName:": emergencyFirstNameTextField.text! as String,
                    "EmergencyLastName:": emergencyLastNameTextField.text! as String,
                    "EmergencyPhone:": emergencyPhoneNumberTextField.text! as String
                    ] as [String : Any]
        
        self.refUsers.childByAutoId().setValue(user)
        
    }
}

