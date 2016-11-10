//
//  AssistClient.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import AFNetworking

// TODO: move these somewhere intelligent
let devURLString = "http://127.0.0.1:5000/"
let prodURLString = ""


// TODO add error handling
class AssistClient: NSObject {
    
    static let sharedInstance = AssistClient(baseURLString: devURLString)
    
    var baseURLString: String!
    var urlSession: URLSession!
    
    init(baseURLString: String) {
        super.init()
        self.baseURLString = baseURLString
        self.urlSession = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue: OperationQueue.main
        )
    }
    
    func createClient(
        clientDict: [NSDictionary],
        success: @escaping (Client) -> (),
        failure: @escaping (Error) -> ()
    ) {
        let url = URL(string: "\(baseURLString)/clients/create")
        let request = URLRequest(url: url!)
        let task: URLSessionDataTask = self.urlSession.dataTask(
            with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        print("response: \(responseDictionary)")
                        success(Client(clientDict: responseDictionary))
                    }
                }
            }
        )
        task.resume()
    }
    
    func updateClient(
        clientID: String,
        success: @escaping (Client) -> (),
        failure: @escaping (Error) -> ()
    ) {
        // let url = URL(string: "\(baseURLString)/clients/\(clientID)/update")
        // let request = URLRequest(url: url!)
    }
    
    func deleteClient(
        clientID: String,
        success: @escaping () ->(),
        failure: @escaping (Error) -> ()
    ) {
        // let url = URL(string: "\(baseURLString)/clients/\(clientID)/delete")
        // let request = URLRequest(url: url!)
    }
    
    func getTasks(
        taskIDs: [String],
        success: @escaping ([Task]) -> (),
        failure: @escaping (Error) -> ()
    ) {
        
    }
    
    func createTasks(
        taskDicts: [NSDictionary],
        success: @escaping ([Task]) -> (),
        failure: @escaping (Error) -> ()
    ) {
        
    }
    
    func updateTasks(
        taskIDs: [String],
        success: @escaping ([Task]) -> (),
        failure: @escaping (Error) -> ()
    ) {
        
    }
    
    func deleteTasks(
        taskIDs: [String],
        success: @escaping () -> (),
        failure: @escaping (Error) -> ()
    ) {
        
    }
}
