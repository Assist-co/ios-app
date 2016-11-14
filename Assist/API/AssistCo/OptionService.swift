//
//  OptionClient.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class OptionService: NSObject {
    
    private static var baseURLString: String! {
        return Constants.devURLString
    }

    
    /********** OPTION API **********/
    
    class func fetchGenders(
        completion: @escaping ([Gender]?, Error?) -> ()
        ) {
        
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/option/genders",
            method: .get
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil,nil)
                        return
                    }
                    completion(Gender.genders(array: responseDict["results"] as! Array), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    
    class func fetchProfessions(
        completion: @escaping ([Profession]?, Error?) -> ()
        ) {
        
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/option/professions",
            method: .get
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil,nil)
                        return
                    }
                    completion(Profession.professions(array: responseDict["results"] as! Array), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    class func fetchAssistantTaskTypes(
        completion: @escaping ([AssistantTaskType]?, Error?) -> ()
        ) {
        
        AssistClient.sharedInstance.session.request(
            "\(self.baseURLString!)/option/task-types",
            method: .get
            ).validate().responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil,nil)
                        return
                    }
                    completion(AssistantTaskType.taskTypes(array: responseDict["results"] as! Array), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

}
