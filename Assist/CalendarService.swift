//
//  CalendarService.swift
//  Assist
//
//  Created by Hasham Ali on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import EventKit

class CalendarService: NSObject {
    
    static let sharedInstance = CalendarService()
    
    private var store: EKEventStore
    
    override init() {
        store = EKEventStore()
    }
    
    func createEvent(task: Task) {
        store.requestAccess(to: .event, completion: {
            (granted, error) in
            if !granted { return }
            
            if let startOn = task.startOn {
                if let endOn = task.endOn {
                    if let title = task.text {
                        let event = EKEvent(eventStore: self.store)
                        event.title = title
                        event.startDate = startOn
                        event.endDate = endOn
                        event.calendar = self.store.defaultCalendarForNewEvents
                        
                        do {
                            try self.store.save(event, span: EKSpan.thisEvent)
                            task.calendarId = event.eventIdentifier
                        } catch {
                            
                        }

                    }
                }
            }
            
        })
    }
    
    func removeEvent(task: Task) {
        store.requestAccess(to: .event, completion: {
            (granted, error) in
            if !granted { return }
            
            if let calendarId = task.calendarId {
                let eventToRemove = self.store.event(withIdentifier: calendarId)
                if eventToRemove != nil {
                    do {
                        try self.store.remove(eventToRemove!, span: .thisEvent)
                    } catch {
                        // Display error to user
                    }
                }
            }
        })
    }
    
}
