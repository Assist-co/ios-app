//
//  UIPlaceholderTextView.swift
//  Assist
//
//  Created by christopher ketant on 12/5/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class UIPlaceholderTextView: UITextView {
    var placeholder: String = ""
    var placeholderColor: UIColor = UIColor.lightGray
    private var placeholderLabel: UILabel!
    override var text: String!{
        didSet(newText){
            self.text = newText
            self.textChanged(notification: nil)
        }
    }
    private let animationDuration = 0.15
    

    override func draw(_ rect: CGRect) {
        if self.placeholder.characters.count > 0 {
            if self.placeholderLabel == nil {
                self.placeholderLabel = UILabel()
                self.placeholderLabel.frame = CGRect(x: 3, y: 6,
                                                     width: self.bounds.size.width,
                                                     height: 0)
                self.placeholderLabel.numberOfLines = 0
                self.placeholderLabel.backgroundColor = UIColor.clear
                self.placeholderLabel.textColor = self.placeholderColor
                self.placeholderLabel.tag = 999
                self.placeholderLabel.alpha = 0
                self.addSubview(self.placeholderLabel)
            }
            self.placeholderLabel.text = self.placeholder
            self.placeholderLabel.sizeToFit()
            self.sendSubview(toBack: self.placeholderLabel)
        }
        if self.text.characters.count == 0
            && self.placeholder.characters.count > 0 {
            self.viewWithTag(999)?.alpha = 1
        }
        super.draw(rect)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textChanged(notification:)),
                                               name: .UITextViewTextDidChange,
                                               object: nil)
    }
    
    internal func textChanged(notification: Notification?){
        if self.placeholder.characters.count != 0 {
            UIView.animate(withDuration: self.animationDuration, animations: {
                if self.text.characters.count == 0{
                    self.viewWithTag(999)?.alpha = 1
                }else{
                    self.viewWithTag(999)?.alpha = 0
                }
            })
        }

    }

}
