//
//  MessageTableViewTaskCellTableViewCell.swift
//  Assist
//
//  Created by christopher ketant on 12/6/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class MessageTaskTableViewCell: MessageBubbleTableViewCell {
    @IBOutlet weak var taskButton: MessageTaskButton!
    @IBOutlet weak var taskImageView: UIImageView!
    
    override func draw(_ rect: CGRect) {
        var bubbleSpace: CGRect!
        
        // start the bubble from the task button or label
        bubbleSpace = CGRect(x: bodyLabel.frame.minX - 8.0,
                             y: bodyLabel.frame.minY - 8,
                             width: bodyLabel.frame.width + 16,
                             height: (bodyLabel.bounds.height + 16))

        let bubblePath = UIBezierPath(roundedRect: bubbleSpace, cornerRadius: 6.0)
        let color = message?.messageColor
        color?.setStroke()
        color?.setFill()
        bubblePath.stroke()
        bubblePath.fill()
        
        
        let iconHeight = self.taskImageView.frame.size.height
        let messageHeight = self.bodyLabel.frame.size.height
        if self.isAdjacentMessage {
            self.iconTopMargin.constant = (messageHeight/2 - iconHeight/2) + 2
        } else {
            self.iconTopMargin.constant = (messageHeight/2 - iconHeight/2) + 8

        }
    }
    
    override var message: Message? {
        didSet {
            populateMessage()
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func chooseImageForTaskType(typePermalink: String?){
        if let permalink = typePermalink{
            switch permalink {
            case "call":
                self.taskImageView.image = #imageLiteral(resourceName: "phone_small")
                self.taskImageView.backgroundColor = UIColor(hexString: "#ED5E5Eff")
            case "schedule":
                self.taskImageView.image = #imageLiteral(resourceName: "calendar")
                self.taskImageView.backgroundColor = UIColor(hexString: "#66BB6Aff")
            case "email":
                self.taskImageView.image = #imageLiteral(resourceName: "mail")
                self.taskImageView.backgroundColor = UIColor(hexString: "#42A5F5ff")
            case "inquiry":
                self.taskImageView.image = #imageLiteral(resourceName: "magnifying_glass")
                self.taskImageView.backgroundColor = UIColor(hexString: "#7E57C2ff")
            case "reminder":
                self.taskImageView.image = #imageLiteral(resourceName: "clock")
                self.taskImageView.backgroundColor = UIColor(hexString: "#FFCA28ff")
            default:
                self.taskImageView.image = #imageLiteral(resourceName: "other")
                self.taskImageView.backgroundColor = UIColor(hexString: "#AC7339ff")
            }
        }else{
            self.taskImageView.image = #imageLiteral(resourceName: "other")
            self.taskImageView.backgroundColor = UIColor(hexString: "#AC7339ff")
        }
        self.taskImageView.layer.cornerRadius = 6
    }
    
    private func populateMessage() {
        bodyLabel.text = message?.body
        timestampLabel.text = message?.readableDate()
    }
}
