//
//  ClientService.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class ClientService: NSObject {

    private static var baseURLString: String! {
        return Constants.devURLString
    }
    
    class func fetchClient(
        clientID: Int,
        completion: @escaping (Client?, Error?) -> ()
        ){
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/clients/\(clientID)",
            method: .get
            ).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
                    completion(Client(dictionary: responseDict as NSDictionary), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    class func updateClient(
        clientID: Int,
        clientDict: Dictionary<String, AnyObject>,
        completion: @escaping (Client?, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/clients/\(clientID)",
            method: .patch,
            parameters: clientDict
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
                    completion(Client(dictionary: responseDict as NSDictionary), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    class func deleteClient(
        clientID: Int,
        completion: @escaping (Bool, Error?) -> ()
        ){
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/clients/\(clientID)",
            method: .delete
            ).responseJSON { (response) in
                switch response.result {
                case .success:
                    completion(true, nil)
                case .failure(let error):
                    completion(false, error)
                }
        }
    }
    
}
