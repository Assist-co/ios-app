//
//  MessageTableViewCell.swift
//  Assist
//
//  Created by Hasham Ali on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import SendBirdSDK

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var message: SBDUserMessage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        populateMessage()
    }
    
    private func populateMessage() {
        authorLabel.text = message?.sender?.nickname
        messageLabel.text = message?.message
        timestampLabel.text = String(describing: message?.createdAt)
    }

}
