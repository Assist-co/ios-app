//
//  MessageBubbleTableViewCell.swift
//  Assist
//
//  Created by christopher ketant on 12/6/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

/*
 Superclass for message tableviewcells
 */
class MessageBubbleTableViewCell: UITableViewCell {
    @IBOutlet weak var bodyLabel: UILabel! = nil
    @IBOutlet weak var timestampLabel: UILabel! = nil
    @IBOutlet weak var topMargin: NSLayoutConstraint! = nil
    @IBOutlet weak var dateLabelHeight: NSLayoutConstraint! = nil
    //@IBOutlet weak var dateLabelTopMargin: NSLayoutConstraint! = nil
    @IBOutlet weak var dateLabelTopMargin: NSLayoutConstraint!
    var message: Message?

    @IBOutlet weak var iconTopMargin: NSLayoutConstraint!
}
