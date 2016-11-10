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
    var type: TaskType?
    var text: String?
    var createdOn: Date?
    var deletedOn: Date?
    var canceledOn: Date?
    var deadlineOn: Date?
    var clientID: String?
    var assistantID: String?
    
    init(taskDict: NSDictionary) {
        super.init()
        // TODO
    }
}
