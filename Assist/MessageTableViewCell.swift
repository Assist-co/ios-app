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

    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var topMargin: NSLayoutConstraint!
    @IBOutlet weak var dateLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabelTopMargin: NSLayoutConstraint!


    
    override func draw(_ rect: CGRect) {
                
        let bubbleSpace = CGRect(x: bodyLabel.frame.minX - 10.0, y: bodyLabel.frame.minY - 10.0, width: bodyLabel.bounds.width + 20.0, height: bodyLabel.bounds.height + 20.0)
        
        _ = UIBezierPath(roundedRect: bubbleSpace, byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomRight], cornerRadii: CGSize(width: 20.0, height: 20.0))
        
        let bubblePath = UIBezierPath(roundedRect: bubbleSpace, cornerRadius: 6.0)
        let color = message?.messageColor
        color?.setStroke()
        color?.setFill()
        bubblePath.stroke()
        bubblePath.fill()
    }
    
    var message: Message? {
        didSet {
            populateMessage()
            self.setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        

    }
    
    private func populateMessage() {
        bodyLabel.text = message?.body
        timestampLabel.text = message?.readableDate()
    }

}
