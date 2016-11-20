//
//  SignUpViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var signupButton: UIButton!

    // Developer cheat to skip login / signup
    @IBAction func didTap(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "OnboardingFlow", bundle: nil)
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "MeetAssistantNavigation")
        self.present(homeNavigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        firstNameTextField.tag = 0
        
        lastNameTextField.delegate = self
        lastNameTextField.tag = 1
        
        emailTextField.delegate = self
        emailTextField.tag = 2
        
        phoneNumberTextField.delegate = self
        phoneNumberTextField.tag = 3

        signupButton.layer.cornerRadius = 4
        signupButton.clipsToBounds = true
        //signupButton.backgroundColor = UIColor(hexString: "#B19CD9FF")
        signupButton.backgroundColor = UIColor(hexString: "#40bf40FF")
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "SignUp" {
            let firstName = firstNameTextField.text
            let lastName = lastNameTextField.text
            let email = emailTextField.text
            let phoneNumber = phoneNumberTextField.text
            return firstName != "" && lastName != "" && email != "" && phoneNumber != ""
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SignUp" {
            let firstName = firstNameTextField.text
            let lastName = lastNameTextField.text
            let email = emailTextField.text
            let phoneNumber = phoneNumberTextField.text
        
            let signupPart2 = segue.destination as! SignUpMoreDetailsViewController
            signupPart2.firstName = firstName
            signupPart2.lastName = lastName
            signupPart2.email = email
            signupPart2.phoneNumber = phoneNumber
        }
    }
    
}
