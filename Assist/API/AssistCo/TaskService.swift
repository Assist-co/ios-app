//
//  TaskService.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import Alamofire

class TaskService: NSObject {
    
    private static var baseURLString: String! {
        return Constants.devURLString
    }
    
    /********** TASK API **********/
    
    class func fetchTasksForClient(
        completion: @escaping ([Task]?, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/clients/\(Client.currentUserID!)/tasks",
            method: .get
            ).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
                    
                    completion(Task.tasks(array: responseDict["results"] as! Array), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    class func fetchTaskForID(
        taskID: Int,
        completion: @escaping (Task?, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/clients/\(Client.currentUserID!)/tasks/\(taskID)",
            method: .get
            ).responseJSON { (response) in
                switch response.result {
                case .success:
                    guard let responseDict = response.result.value as? [String: AnyObject] else{
                        completion(nil, nil)
                        return
                    }
                    completion(Task(dictionary: responseDict as NSDictionary), nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    class func createTask(
        taskDict: Dictionary<String, AnyObject>,
        completion: @escaping (Task?, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/tasks",
            method: .post,
            parameters: taskDict
            ).validate().responseJSON(
                completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        guard let responseDict = response.result.value as? [String: AnyObject] else{
                            completion(nil, nil)
                            return
                        }
                        completion(Task(dictionary: responseDict as NSDictionary), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
            }
        )
    }
    
    class func updateTask(
        taskID: Int,
        taskDict: Dictionary<String, AnyObject>,
        completion: @escaping (Task?, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/clients/\(Client.currentUserID!)/tasks/\(taskID)",
            method: .patch,
            parameters: taskDict
            ).validate().responseJSON(
                completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        guard let responseDict = response.result.value as? [String: AnyObject] else{
                            completion(nil, nil)
                            return
                        }
                        completion(Task(dictionary: responseDict as NSDictionary), nil)
                    case .failure(let error):
                        completion(nil, error)
                    }
            }
        )
    }
    
    class func deleteTask(
        taskID: Int,
        completion: @escaping (Bool, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/clients/\(Client.currentUserID!)/tasks/\(taskID)",
            method: .delete
            ).validate().responseJSON(
                completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        completion(true,nil)
                    case .failure(let error):
                        completion(false, error)
                    }
            }
        )
    }
}
