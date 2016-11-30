//
//  TaskTypeButton.swift
//  Assist
//
//  Created by christopher ketant on 11/29/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class CallTaskTypeButton: TaskTypeButton{
    override public var taskTypePermalink: String? {
        get{
            return "call"
        }
        set{
        
        }
    }
}

class ScheduleTaskTypeButton: TaskTypeButton{
    override var taskTypePermalink: String? {
        get{
            return "schedule"
        }
        set{
            
        }
    }
}

class EmailTaskTypeButton: TaskTypeButton{
    override var taskTypePermalink: String? {
        get{
            return "email"
        }
        set{
            
        }
    }
}


class ReminderTaskTypeButton: TaskTypeButton{
    override var taskTypePermalink: String? {
        get{
            return "reminder"
        }
        set{
            
        }
    }
}

class InquiryTaskTypeButton: TaskTypeButton{
    override var taskTypePermalink: String? {
        get{
            return "inquiry"
        }
        set{
            
        }
    }
}

class OtherTaskTypeButton: TaskTypeButton{
    override var taskTypePermalink: String? {
        get{
            return "other"
        }
        set{
            
        }
    }
}

class TaskTypeButton: UIButton {
    public var taskTypePermalink: String?
}

