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
        taskDict: Dictionary<String, Any>,
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
                        
                        let generatedTask = Task(dictionary: responseDict as NSDictionary)
                        
                        MessagingClient.sharedInstance.postMessage(message: generatedTask.text!)
                        CalendarService.sharedInstance.createEvent(task: generatedTask)
                        completion(generatedTask, nil)
                    case .failure(let error):
                        if let data = response.data{
                            print("Error: \(String(data: data, encoding: String.Encoding.utf8)!)")
                        }
                        completion(nil, error)
                    }
            }
        )
    }
    
    class func updateTask(
        taskID: Int,
        taskDict: Dictionary<String, Any>,
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
        task: Task,
        completion: @escaping (Bool, Error?) -> ()
        ) {
        let taskID = task.id!
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/clients/\(Client.currentUserID!)/tasks/\(taskID)",
            method: .delete
            ).validate().responseJSON(
                completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        CalendarService.sharedInstance.removeEvent(task: task)
                        completion(true,nil)
                    case .failure(let error):
                        completion(false, error)
                    }
            }
        )
    }
    
    class func addContactsToTask(
        taskID: Int,
        contactDicts: Array<Dictionary<String, Any>>,
        completion: @escaping (Task?, Error?) -> ()
        ) {
        AssistClient.sharedInstance.session.request(
            "\(baseURLString!)/tasks/\(taskID)/contacts",
            method: .post,
            parameters: ["contacts": contactDicts]
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
}
