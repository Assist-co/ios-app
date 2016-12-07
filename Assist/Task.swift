//
//  Task.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

enum TaskState{
    case ready
    case executing
    case completed
    case terminated
}
class Task: NSObject {
    
    var id: Int?
    var type: AssistantTaskType?
    var text: String?
    var createdOn: Date?
    var completedOn: Date?
    var startOn: Date?
    var endOn: Date?
    var calendarId: String?
    var client: Client?
    var assistant: Assistant?
    var contacts: [Contact]?
    var isComplete: Bool? = false
    var state: TaskState? = .ready
    var location: String? // Format: (1.2323423423,-33333.3333)
    
    override var description: String{
        return "Task: \(self.id!)"
    }
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? Int
        self.text = dictionary["text"] as? String
        self.location = dictionary["location"] as? String
        self.isComplete = dictionary["is_complete"] as? Bool
        if let createdOnString = dictionary["created_on"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            self.createdOn = formatter.date(from: createdOnString) as Date?
        }
        if let completedOnString = dictionary["completed_on"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            self.completedOn = formatter.date(from: completedOnString) as Date?
        }
        if let startOnString = dictionary["start_on"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            self.startOn = formatter.date(from: startOnString) as Date?
        }
        if let endOnString = dictionary["end_on"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            self.endOn = formatter.date(from: endOnString) as Date?
        }
        
        self.calendarId = dictionary["calendar_id"] as? String
        
        if let clientDict = dictionary["client"] as? NSDictionary{
            self.client = Client(dictionary: clientDict)
        }
        if let assistantDict = dictionary["assistant"] as? NSDictionary{
            self.assistant = Assistant(dictionary: assistantDict)
        }
        if let typeDict = dictionary["task_type"] as? NSDictionary{
            self.type = AssistantTaskType(dictionary: typeDict)
        }
        if let state = dictionary["state"] {
            switch state as! String {
            case "ready":
                self.state = .ready
            case "executing":
                self.state = .executing
            case "completed":
                self.state = .completed
            case "terminates":
                self.state = .terminated
            default:
                self.state = .ready
            }
        }
        if let contactsArr = dictionary["contacts"] as? Array<NSDictionary>{
            self.contacts = Contact.contacts(array: contactsArr)
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
