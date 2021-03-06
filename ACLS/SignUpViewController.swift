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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    var refUsers: DatabaseReference!
    
    var mysegementBool : Bool = true
    
    private var datePicker: UIDatePicker?
    
    struct GlobalVariable{
        static var  userBirthDateSince1970 = Double()
        static var key = String()
    }
    
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
                
                // add user info to database
                self.addUsers()

                    let signUpAlert = UIAlertController(title: "Account Created", message: "You can now Login!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                        let LoginViewController = self.storyboard?.instantiateViewController(withIdentifier: "LogIn")
                        self.present(LoginViewController!, animated: true, completion: nil)
                    }
                    signUpAlert.addAction(action)
                    self.present(signUpAlert, animated: true, completion: nil)

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
 
    override func viewDidLoad() {
        super .viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emergencyFirstNameTextField.delegate = self
        emergencyLastNameTextField.delegate = self
        emergencyPhoneNumberTextField.delegate = self
        

        ///stteing datepicker wheel
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(SignUpViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        ///setting tap Gesture to quit datepicker when touching the screen
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)   /// quit the datepicker wheel when touching other place on the screen
        
        //show the picked date on birthday textfield
        birthdateTextField.inputView = datePicker
        
        ///refrence to users node on database
        refUsers = Database.database().reference().child("users")
        
    }
    
    //emergencyphone UItextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emergencyPhoneNumberTextField{
            let plusLabel = UILabel()
            plusLabel.text = " +1"
            plusLabel.font = UIFont(name: plusLabel.font.fontName, size: 14)
            plusLabel.sizeToFit()
            textField.leftView = plusLabel
            textField.leftViewMode = UITextField.ViewMode.always
    }
      
    }
    // Hide keyboard when user taps return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return(true)
    }
    
    // isMale boolean value changing with selected segement
    @IBAction func indexChanged(_ sender: Any) {
        
        switch segmentedControllor.selectedSegmentIndex{
        case 0:
            mysegementBool = true //male segement selected
        case 1:
            mysegementBool = false // female segement selected
        default:
            break
        }
        print("isMale:",mysegementBool)
    }
    
    //date formater function
    @objc func dateChanged(datePicker: UIDatePicker){
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthdateTextField.text = dateFormatter.string(from: datePicker.date) //date for view
        GlobalVariable.userBirthDateSince1970 = datePicker.date.timeIntervalSince1970 //date for database
        print("userBirthDate:\(GlobalVariable.userBirthDateSince1970)")
    }
    
    //respond to screen toching function
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
       view.endEditing(true)
    }
    
    // add user information to database when signup
    func addUsers(){
        let userID=Auth.auth().currentUser!.uid
        
        //user information dictionary to be saved into database
        let user = [
                    "FirstName:": firstNameTextField.text! as String,
                    "LastName:": lastNameTextField.text! as String,
                    "E-mail:": emailTextField.text! as String,
                    "isMale": mysegementBool,
                    "EmergencyFirstName:": emergencyFirstNameTextField.text! as String,
                    "EmergencyLastName:": emergencyLastNameTextField.text! as String,
                    "EmergencyPhone:": "+1" + emergencyPhoneNumberTextField.text! as String,
                    "BirthDate": GlobalVariable.userBirthDateSince1970
                    ] as [String : Any] //allow other types than String to be saved in the dictionary
        
        //setting each user information under its user id
        self.refUsers.child(userID).setValue(user)
    }
}

