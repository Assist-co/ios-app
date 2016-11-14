//
//  AssistClient.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import Alamofire

class AssistClient: NSObject {

    static let sharedInstance = AssistClient(baseURLString: Constants.devURLString)

    var baseURLString: String!

    init(baseURLString: String) {
        super.init()
        self.baseURLString = baseURLString
    }

    
    /********* AUTH API *************/
    
    // Response is Token Object
    func signUpClient(
        signUpDict: Dictionary<String, AnyObject>,
        completion: @escaping (Dictionary<String, AnyObject>?, Error?) -> ()) {
        
        Alamofire.request(
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
    func loginClient(
        email: String?,
        password: String?,
        completion: @escaping (Dictionary<String, AnyObject>?, Error?) -> ()
        ) {
        
        Alamofire.request(
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
    func logoutClient(
        completion: @escaping (Bool, Error?) -> ()
        ) {
        
        Alamofire.request(
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
    
    /********** OPTION API **********/
    
    func fetchGenders(
        completion: @escaping ([Gender]?, Error?) -> ()
        ) {
        
        Alamofire.request(
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
    

    func fetchProfessions(
        completion: @escaping ([Profession]?, Error?) -> ()
        ) {
        
        Alamofire.request(
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

    func fetchAssistantTaskTypes(
        completion: @escaping ([AssistantTaskType]?, Error?) -> ()
        ) {
        
        Alamofire.request(
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

    
    /********** CLIENT API **********/
    
    func fetchClient(
        clientID: Int,
        completion: @escaping (Client?, Error?) -> ()
        ){
        Alamofire.request(
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
    
    func updateClient(
        clientID: Int,
        clientDict: Dictionary<String, AnyObject>,
        completion: @escaping (Client?, Error?) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)",
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

    func deleteClient(
        clientID: Int,
        completion: @escaping (Bool, Error?) -> ()
        ){
        Alamofire.request(
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


    /********** ASSISTANT API **********/

    func fetchAssistant(
        AssistantID: Int,
        completion: @escaping (Assistant?, Error?) -> ()
        ){
        Alamofire.request(
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
    
    func updateAssistant(
        assistantID: Int,
        clientDict: Dictionary<String, AnyObject>,
        completion: @escaping (Assistant?, Error?) -> ()
        ) {
        Alamofire.request(
            "\(baseURLString)/assistants/\(assistantID)",
            method: .patch,
            parameters: clientDict
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
    


    /********** TASK API **********/

    func fetchTasksForClient(
        clientID: Int,
        completion: @escaping ([Task]?, Error?) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)/tasks",
            method: .get
            ).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
//                    completion(Task(dictionary: responseDict as NSDictionary), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }

    func getTask(
        taskID: String,
        clientID: String,
        success: @escaping (Task) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)tasks/\(taskID)",
            method: .get
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    func createTask(
        clientID: String,
        taskDict: Dictionary<String, String>,
        success: @escaping (Task) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)/tasks",
            method: .post,
            parameters: taskDict
        ).validate().responseJSON(
            completionHandler: { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    print("Validation Successful")
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                case .failure(let error):
                    failure(error)
                }
            }
        )
    }

    func updateTask(
        taskID: String,
        clientID: String,
        taskDict: Dictionary<String,String>,
        success: @escaping (Task) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)/tasks/\(taskID)",
            method: .patch,
            parameters: taskDict
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    func deleteTask(
        clientID: String,
        taskID: String,
        success: @escaping () -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)/tasks\(taskID)",
            method: .delete
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                print("Validation Successful")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
            case .failure(let error):
                failure(error)
            }
        }
    }
}
