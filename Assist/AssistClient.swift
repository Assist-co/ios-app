//
//  AssistClient.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import Alamofire

// TODO: move these somewhere intelligent
let devURLString = "http://127.0.0.1:8000/api"
let prodURLString = ""


class AssistClient: NSObject {

    static let sharedInstance = AssistClient(baseURLString: devURLString)

    var baseURLString: String!

    init(baseURLString: String) {
        super.init()
        self.baseURLString = baseURLString
    }


    /********** CLIENT API **********/

    func createClient(
        clientDict: Dictionary<String, String>,
        success: @escaping (Client) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/create",
            method: .post,
            parameters: clientDict
        ).validate().responseJSON(
            completionHandler: { (response: DataResponse<Any>) in
                switch response.result {
                case .success:
                    // print("Validation Successful")
                    if let JSON = response.result.value {
                        // print("JSON: \(JSON)")
                        success(Client(clientDict: JSON as! NSDictionary))
                    }
                case .failure(let error):
                    failure(error)
                }
            }
        )
    }

    func getClient(
        clientID: String,
        success: @escaping (Client) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)",
            method: .get
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                // print("Validation Successful")
                if let JSON = response.result.value {
                    // print("JSON: \(JSON)")
                    success(Client(clientDict: JSON as! NSDictionary))
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    func updateClient(
        clientID: String,
        clientDict: Dictionary<String, String>,
        success: @escaping (Client) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)",
            method: .patch,
            parameters: clientDict
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                // print("Validation Successful")
                if let JSON = response.result.value {
                    // print("JSON: \(JSON)")
                    success(Client(clientDict: JSON as! NSDictionary))
                }
            case .failure(let error):
                failure(error)
            }
        }
    }

    func deleteClient(
        clientID: String,
        success: @escaping () -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)",
            method: .delete
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                /*
                print("deleteClient Validation Successful")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }*/
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }


    /********** ASSISTANT API **********/

    func getAssistant(
        assistantID: String,
        success: @escaping (Assistant) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/assistants/\(assistantID)",
            method: .get
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                // print("getAssistant Validation Successful")
                if let JSON = response.result.value {
                    //print("JSON: \(JSON)")
                    success(Assistant(assistantDict: JSON as! NSDictionary))
                }
            case .failure(let error):
                failure(error)
            }
        }
    }


    /********** TASK API **********/

    func getTasksForClient(
        clientID: String,
        success: @escaping ([Task]) -> (),
        failure: @escaping (Error) -> ()
    ) {
        Alamofire.request(
            "\(baseURLString)/clients/\(clientID)/tasks",
            method: .get
        ).validate().responseJSON { (response: DataResponse<Any>) in
            switch response.result {
            case .success:
                // print("getTasksForClient Validation Successful")
                if let JSON = response.result.value {
                    // print("JSON: \(JSON)")
                    var tasks: [Task] = []
                    for item in JSON as! [Any] {
                        tasks.append(Task(taskDict: item as! NSDictionary))
                    }
                    success(tasks)
                }
            case .failure(let error):
                failure(error)
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
                // print("getTask Validation Successful")
                if let JSON = response.result.value {
                    // print("JSON: \(JSON)")
                    success(Task(taskDict: JSON as! NSDictionary))
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
                    // print("createTask Validation Successful")
                    if let JSON = response.result.value {
                        // print("JSON: \(JSON)")
                        success(Task(taskDict: JSON as! NSDictionary))
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
                // print("updateTask Validation Successful")
                if let JSON = response.result.value {
                    // print("JSON: \(JSON)")
                    success(Task(taskDict: JSON as! NSDictionary))
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
                /*
                print("Validation Successful")
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }*/
                success()
            case .failure(let error):
                failure(error)
            }
        }
    }
}
