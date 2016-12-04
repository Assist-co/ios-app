//
//  Assistant.swift
//  Assist
//
//  Created by Hasham Ali on 11/20/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import Foundation
import SendBirdSDK

class Message: NSObject {
    
    var id: Int64?
    var senderId: String?
    var body: String?
    var createdAt: Date?
    var messageColor: UIColor? {
        get {
            return senderId == Client.currentID ? UIColor(hexString: "#256e93ff") : UIColor(hexString: "#ddddddff")
        }
    }
    
    override var description: String{
        return "Message: \(self.senderId!) \(self.body!)"
    }
    
    init(id: Int64, senderId: String, body: String, createdAt: Date) {
        self.id = id
        self.senderId = senderId
        self.body = body
        self.createdAt = createdAt
    }
    
    init(body: String) {
        self.senderId = Client.currentID
        self.body = body
        self.createdAt = Date()
    }
    
    init(sbdUserMessage: SBDUserMessage) {
        self.id = sbdUserMessage.messageId
        self.senderId = sbdUserMessage.sender?.userId
        self.body = sbdUserMessage.message
        self.createdAt =  Date(timeIntervalSince1970: TimeInterval(sbdUserMessage.createdAt / 1000))
    }
    
    func readableDate() -> String {
        let currentDate = Date()
        
        let seconds = Int(currentDate.timeIntervalSince(createdAt!))
        let minutes = seconds / 60
        let hours = minutes / 60
        
        if hours > 24 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.none
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: createdAt!)
        } else if hours > 0 {
            return "\(hours)h ago"
        } else if minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "\(seconds)s ago"
        }        
    }
}
