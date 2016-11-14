//
//  Task.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit


class Task: NSObject {
    
    var id: Int?
    var type: AssistantTaskType?
    var text: String?
    var createdOn: Date?
    var completedOn: Date?
    var client: Client?
    var assistant: Assistant?
    var isComplete: Bool? = false
    override var description: String{
        return "Task: \(self.id!)"
    }
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? Int
        self.text = dictionary["text"] as? String
        self.isComplete = dictionary["is_complete"] as? Bool
        if let createdOnString = dictionary["created_on"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            self.createdOn = formatter.date(from: createdOnString) as Date?
        }
        if let completedOnString = dictionary["completed_on"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            self.createdOn = formatter.date(from: completedOnString) as Date?
        }
        if let clientDict = dictionary["client"] as? NSDictionary{
            self.client = Client(dictionary: clientDict)
        }
        if let assistantDict = dictionary["assistant"] as? NSDictionary{
            self.assistant = Assistant(dictionary: assistantDict)
        }
        if let typeDict = dictionary["task_type"] as? NSDictionary{
            self.type = AssistantTaskType(dictionary: typeDict)
        }
    }
    
    class func tasks(array: [NSDictionary]) -> [Task]{
        var tasks = [Task]()
        for dictionary in array {
            let task = Task(dictionary: dictionary)
            tasks.append(task)
        }
        return tasks
    }

}
