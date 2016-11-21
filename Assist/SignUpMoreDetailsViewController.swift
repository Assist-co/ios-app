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
        //signupButton.backgroundColor = UIColor(hexString: "#B19CD9FF")
        
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
        let profession = professionTextField.text
        let password = passwordTextField.text
        let passwordAgain = passwordAgainTextField.text
        
        guard profession != "" && password != "" && passwordAgain != "" && password == passwordAgain else {
            self.errorView.isHidden = false
            return
        }
        
        AuthService.signUpClient(
            signUpDict: [
                "email": email as AnyObject,
                "password": password as AnyObject,
                "first_name": firstName as AnyObject,
                "last_name": lastName as AnyObject,
                "phone": phoneNumber as AnyObject,
                "profession": profession as AnyObject,
                
                // TODO: add support for these or remove them
                "gender": "male" as AnyObject,
                "date_of_birth": "1991-04-25" as AnyObject,
            ]
        ) {
            (response: Dictionary<String, AnyObject>?, error: Error?) in
            if let error = error {
                // TODO: raise appropriate error to user
                self.errorView.isHidden = false
                print(error.localizedDescription)
            }
            if let response = response {
                let token = response["token"] as! String
                
                // TODO: check if this is actually safe...
                UserDefaults.standard.set(token, forKey: "userToken")
                UserDefaults.standard.synchronize()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeNavigationController = storyboard.instantiateViewController(withIdentifier: "HomeNavigationController")
                self.present(homeNavigationController, animated: true, completion: nil)
            }
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
