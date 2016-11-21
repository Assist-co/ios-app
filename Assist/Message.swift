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
    var messageColor: UIColor {
        get {
            return senderId == Client.currentID ? Message.UIColorFromRGB(rgbValue: 0x2ed159) : Message.UIColorFromRGB(rgbValue: 0xd4d7db)
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
    
    init(sbdUserMessage: SBDUserMessage) {
        self.id = sbdUserMessage.messageId
        self.senderId = sbdUserMessage.sender?.userId
        self.body = sbdUserMessage.message
        self.createdAt =  Date(timeIntervalSince1970: TimeInterval(sbdUserMessage.createdAt / 1000))
    }
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func readableDate() -> String {
        let currentDate = NSDate()
        
        let seconds = Int(currentDate.timeIntervalSince(createdAt!))
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        let months = weeks / 4
        let years = months / 12
        
        if years > 0 {
            return "\(years)y"
        } else if weeks > 0 {
            return "\(weeks)w"
        } else if days > 0 {
            return "\(days)d"
        } else if hours > 0 {
            return "\(hours)h"
        } else if minutes > 0 {
            return "\(minutes)m"
        } else {
            return "\(seconds)s"
        }
    }
}
