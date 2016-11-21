//
//  SignInViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var errorView: UIView!

    @IBAction func onSignIn(_ sender: AnyObject) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        guard (email != "" && password != "") else {
            // TODO: alert user they need to enter email and password
            self.errorView.isHidden = false
            return
        }
        
        AuthService.loginClient(
            email: email,
            password: password
        ) { (response: Dictionary<String, AnyObject>?, error: Error?) in
            if error != nil {
                // TODO: alert user that they had incorrect email/password
                self.errorView.isHidden = false
                return
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinButton.layer.cornerRadius = 4
        signinButton.clipsToBounds = true
        signinButton.backgroundColor = UIColor(hexString: "#40bf40FF")
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        errorView.layer.borderWidth = 1
        errorView.layer.borderColor = UIColor.red.cgColor
        errorView.layer.cornerRadius = 4
        errorView.isHidden = true
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
