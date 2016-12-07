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
    @IBOutlet weak var titleContainer: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorView: UIView!
    private var formContainerOriginalX: CGFloat!
    private var titleContainerOriginalX: CGFloat!
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.formContainer.frame.origin.x = -(self.formContainer.frame.size.width + self.formContainer.frame.origin.x)
        self.titleContainer.frame.origin.x = (self.titleContainer.frame.size.width + self.view.frame.maxX)
        self.presentForm()
    }
    
    //MARK:- Animations
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func presentForm(){
        self.formContainer.isHidden = false
        self.titleContainer.isHidden = false
        UIView.animate(withDuration: 0.75, delay: 0.0, options: .curveEaseIn, animations: {
            self.formContainer.frame.origin.x = self.formContainerOriginalX
            self.titleContainer.frame.origin.x = self.titleContainerOriginalX
        }) { (success: Bool) in
            
        }
    }
    
    //MARK:- UITextfield delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
    
    //MARK:- Actions
    
    @IBAction func didTap(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "OnboardingFlow", bundle: nil)
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "MeetAssistantNavigation")
        self.present(homeNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func signupPressed(_ button: UIButton) {
        self.view.endEditing(true)
        if self.validateInput() {
            self.errorView.isHidden = true
            UIView.animate(withDuration: 0.75, delay: .3, options: .curveEaseOut, animations: {
                self.formContainer.frame.origin.x = (self.formContainer.frame.size.width + self.view.frame.maxX)
                self.titleContainer.frame.origin.x = -(self.titleContainer.frame.size.width + self.view.frame.maxX)
            }) { (success: Bool) in
                self.formContainer.isHidden = true
                self.titleContainer.isHidden = true
                self.performSegue(withIdentifier: "SignUp", sender: self)
            }
        }else{
            self.errorView.isHidden = false
        }
    }
    
    //MARK:- Utils
    
    private func setup(){
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
        signupButton.backgroundColor = UIColor(hexString: "#256e93ff")
        
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        errorView.layer.borderWidth = 1
        errorView.layer.borderColor = UIColor.red.cgColor
        errorView.layer.cornerRadius = 4
        errorView.isHidden = true
        
        self.formContainerOriginalX = self.formContainer.frame.origin.x
        self.titleContainerOriginalX = self.titleContainer.frame.origin.x
    }
    
    private func validateInput() -> Bool{
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let email = emailTextField.text
        let phoneNumber = phoneNumberTextField.text
        let isValid = firstName != "" && lastName != "" && email != "" && phoneNumber != ""
        if isValid {
            return true
        }else{
            return false
        }
    }

    //MARK:- Navigation

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
