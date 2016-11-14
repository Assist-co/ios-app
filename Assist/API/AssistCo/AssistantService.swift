//
//  AssistantService.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class AssistantService: NSObject {

    private static var baseURLString: String! {
        return Constants.devURLString
    }
    
    /********** ASSISTANT API **********/
    
    class func fetchAssistant(
        AssistantID: Int,
        completion: @escaping (Assistant?, Error?) -> ()
        ){
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/assistants/\(AssistantID)",
            method: .get
            ).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
                    completion(Assistant(dictionary: responseDict as NSDictionary), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    class func updateAssistant(
        assistantID: Int,
        assistantDict: Dictionary<String, AnyObject>,
        completion: @escaping (Assistant?, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/assistants/\(assistantID)",
            method: .patch,
            parameters: assistantDict
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
                    completion(Assistant(dictionary: responseDict as NSDictionary), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
}
