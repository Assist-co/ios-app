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
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    var message: SBDUserMessage? {
        didSet {
            populateMessage()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func populateMessage() {
        authorLabel.text = message?.sender?.nickname
        bodyLabel.text = message?.message
        if let timestamp = message?.createdAt {
            timestampLabel.isHidden = false
            timestampLabel.text = String(describing: timestamp)
        } else {
            timestampLabel.isHidden = true
        }
    }

}
