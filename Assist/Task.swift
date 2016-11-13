//
//  Task.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit


enum TaskType {
    case scheduleMeeting
    case email
    case phoneCall
    case inquiry
    case purchase
    case reminder
}


class Task: NSObject {
    
    var id: String?
    var clientID: String?
    var assistantID: String?
    var taskType: TaskType?
    var text: String?
    var createdOn: Date?
    var deletedOn: Date?
    var isArchived: Bool?
    var completedOn: Date?
    var updatedOn: Date?
    // var deadlineOn: Date?
    
    init(taskDict: NSDictionary) {
        super.init()
        
        self.id = taskDict["id"] as? String
        self.clientID = (taskDict["client"] as? NSDictionary)?["client_id"] as? String
        self.assistantID = (taskDict["assistant"] as? NSDictionary)?["assistant_id"] as? String
        self.text = taskDict["text"] as? String
        // self.taskType = (taskDict["task_type"] as? NSDictionary)?["text"]
        // self.createdOn = taskDict["created_on"] as? Date
        // self.updatedOn = taskDict["updated_on"] as? Date
        // self.completedOn = taskDict["completed_on"] as? Date
        self.isArchived = taskDict["is_archived"] as? Bool
        
    }
}
