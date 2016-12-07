//
//  ContactsTableViewCell.swift
//  Assist
//
//  Created by christopher ketant on 12/4/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import VENTokenField

class ContactsTableViewCell: UITableViewCell {
    @IBOutlet weak var contactsTextView: VENTokenField!
    @IBOutlet weak var contactsPlaceholderLabel: UILabel!
    @IBOutlet weak var contactsImageView: UIImageView!

    override func awakeFromNib() {
        contactsTextView.tintColor = UIColor.white
        contactsTextView.toLabelTextColor = UIColor.white
        contactsTextView.inputTextFieldTextColor = UIColor.white
        contactsTextView.setColorScheme(UIColor.white)
    }
}
