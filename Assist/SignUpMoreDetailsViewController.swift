//
//  SignUpMoreDetailsViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class SignUpMoreDetailsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var addGoogleContactsButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorView: UIView!
    
    var firstName: String!
    var lastName: String!
    var email: String!
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 4
        signupButton.clipsToBounds = true
        signupButton.backgroundColor = UIColor(hexString: "#256e93ff")
        
        professionTextField.delegate = self
        professionTextField.tag = 0
        
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        
        passwordAgainTextField.delegate = self
        passwordAgainTextField.tag = 2
        
        errorView.layer.borderWidth = 1
        errorView.layer.borderColor = UIColor.red.cgColor
        errorView.layer.cornerRadius = 4
        errorView.isHidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    @IBAction func onSignUpTap(_ sender: AnyObject) {
        let profession = professionTextField.text!
        let password = passwordTextField.text
        let passwordAgain = passwordAgainTextField.text
        guard profession != "" && password != "" && passwordAgain != "" && password == passwordAgain else {
            self.errorView.isHidden = false
            return
        }
        
        AuthService.signUpClient(
            signUpDict: [
                "email": email as Any,
                "password": password as Any,
                "first_name": firstName as Any,
                "last_name": lastName as Any,
                "phone": phoneNumber as Any,
                "profession": profession as Any,
                
                // TODO: add support for these or remove them
                "gender": "male" as Any,
                "date_of_birth": "1991-04-25" as Any,
            ]
        ) {
            (response: Dictionary<String, Any>?, error: Error?) in
            if error != nil {
                self.errorView.isHidden = false
            }else{
                let token = response!["token"] as! String
                UserDefaults.standard.set(token, forKey: "userToken")
                UserDefaults.standard.synchronize()
                let clientId = response!["client_id"] as! Int
                ClientService.fetchClient(clientID: clientId, completion: { (client: Client?, error: Error?) in
                    if let client = client {
                        Client.currentUser = client
                        Client.currentUserID = client.id
                        Client.currentID = String(client.id)
                    }
                })
                DispatchQueue.main.async {
                    self.presentAssistantViewController()
                }
            }
        }

    }
    
    //MARK:- Utils
    
    private func presentAssistantViewController(){
        let storyboard = UIStoryboard(name: "OnboardingFlow", bundle: nil)
        let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "MeetAssistantNavigation")
        self.present(homeNavigationController, animated: true, completion: nil)
    }

}
