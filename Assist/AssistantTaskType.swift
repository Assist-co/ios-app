//
//  TaskOption.swift
//  Assist
//
//  Created by christopher ketant on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class AssistantTaskType: NSObject {
    
    var display: String!
    var sort: Int!
    var permalink: String!
    override var description: String{
        return "Task: \(display!)"
    }
    
    init(dictionary: NSDictionary) {
        self.display  = dictionary["display"] as! String
        self.sort     = dictionary["sort"] as! Int
        self.permalink = dictionary["permalink"] as! String
    }
    
    class func taskTypes(array: [NSDictionary]) -> [AssistantTaskType]{
        var tasks = [AssistantTaskType]()
        for dictionary in array {
            let task = AssistantTaskType(dictionary: dictionary)
            tasks.append(task)
        }
        return tasks
    }
}
