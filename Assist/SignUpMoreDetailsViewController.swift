//
//  SignUpMoreDetailsViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class SignUpMoreDetailsViewController: UIViewController {
    
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    @IBOutlet weak var addGoogleContactsButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    var firstName: String!
    var lastName: String!
    var email: String!
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupButton.layer.cornerRadius = 4
        signupButton.clipsToBounds = true
        //signupButton.backgroundColor = UIColor(hexString: "#B19CD9FF")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onSignUpTap(_ sender: AnyObject) {
        let profession = professionTextField.text
        let password = passwordTextField.text
        let passwordAgain = passwordAgainTextField.text
        
        guard profession != "" && password != "" && passwordAgain != "" && password == passwordAgain else {
            // TODO: surface appropriate error message to user
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
