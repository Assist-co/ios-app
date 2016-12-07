//
//  MessagingClient.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import SendBirdSDK


struct SendbirdConstants {
    
    static let APP_ID: String = "10B33A08-3E6C-409A-A735-8EA933FD8042"
    static let CHANNEL_ID: String = "assistant_chat"
    static let MESSAGE_LIMIT: Int = 30
    static let DEFAULT_ASSISTANT_ID: String = "assistant_id"
    
}

protocol MessageListener {
    
    func didReceiveMessage(message: Message?)
    
}

class MessagingClient: NSObject, SBDChannelDelegate {
    
    static let sharedInstance = MessagingClient()
    
    private var currentUser: SBDUser?
    private var currentChannel: SBDGroupChannel?
    private var previousMessageQuery: SBDPreviousMessageListQuery?
    private var listener: MessageListener?
    
    func initWithAppId() {
        SBDMain.initWithApplicationId(SendbirdConstants.APP_ID)
    }
    
    func registerListener(listener: MessageListener) {
        self.listener = listener
    }
    
    func login(onSuccess: @escaping (() -> Void), onFailure: @escaping ((SBDError) -> Void)) {
        SBDMain.connect(withUserId: Client.currentID, completionHandler: {
            (user: SBDUser?, error: SBDError?) -> Void in
            if let user = user {
                self.currentUser = user
                self.initChannelWithAssistant(assistantId: SendbirdConstants.DEFAULT_ASSISTANT_ID, onSuccess: onSuccess)
            } else if let error = error {
                onFailure(error)
            }
        })
    }
    
    func initChannelWithAssistant(assistantId: String, onSuccess: @escaping (() -> Void)) {
        if let userId = currentUser?.userId {
            SBDGroupChannel.createChannel(withUserIds: [userId, assistantId], isDistinct: true, completionHandler: {
                (channel: SBDGroupChannel?, error: SBDError?) -> Void in
                if let channel = channel {
                    self.currentChannel = channel
                    SBDMain.add(self, identifier: SendbirdConstants.CHANNEL_ID)
                    onSuccess()
                }
            })
        }
    }
    
    func getMessages(onMessagesReceived: @escaping (([SBDUserMessage]) -> Void)) {
        if previousMessageQuery == nil {
            previousMessageQuery = currentChannel?.createPreviousMessageListQuery()
        }
        
        previousMessageQuery?.loadPreviousMessages(withLimit: SendbirdConstants.MESSAGE_LIMIT, reverse: true, completionHandler: {
            (messages: [SBDBaseMessage]?, error: SBDError?) -> Void in
            if let messages = messages {
                onMessagesReceived(messages as! [SBDUserMessage])
            }
        })
    }
    
    func postMessage(message: String) {
        currentChannel?.sendUserMessage(message, completionHandler: {
            (userMessage: SBDUserMessage?, error: SBDError?) -> Void in
            self.listener?.didReceiveMessage(message: Message(sbdUserMessage: userMessage!))
        })
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if let message = message as? SBDUserMessage {
            listener?.didReceiveMessage(message: Message(sbdUserMessage: message))
        }
    }
    
    
}
