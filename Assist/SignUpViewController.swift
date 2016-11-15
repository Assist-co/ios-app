//
//  SignUpViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var signupButton: UIButton!

    // Developer cheat to skip login / signup
    @IBAction func didTap(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
        self.present(homeNavigationController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signupButton.layer.cornerRadius = 4
        signupButton.clipsToBounds = true
        //signupButton.backgroundColor = UIColor(hexString: "#B19CD9FF")
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
