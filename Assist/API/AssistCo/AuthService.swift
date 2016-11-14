//
//  AuthService.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import Alamofire

class AuthService: NSObject {
    
    private static var baseURLString: String! {
        return Constants.devURLString
    }

    // Response is Token Object
    class func signUpClient(
        signUpDict: Dictionary<String, AnyObject>,
        completion: @escaping (Dictionary<String, AnyObject>?, Error?) -> ()) {
        
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/signup",
            method: .post,
            parameters: signUpDict
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    completion(response.result.value as? [String : AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    // Response is Token Object
    class func loginClient(
        email: String?,
        password: String?,
        completion: @escaping (Dictionary<String, AnyObject>?, Error?) -> ()
        ) {
        
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/login",
            method: .post,
            parameters: ["email": "\(email!)", "password": "\(password!)"]
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
                    completion(responseDict, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    // Response is success object
    class func logoutClient(
        completion: @escaping (Bool, Error?) -> ()
        ) {
        
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/logout",
            method: .delete
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error)
                }
        }
    }
}
