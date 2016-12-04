//
//  CalendarTableCellTableViewCell.swift
//  Assist
//
//  Created by Bryce Aebi on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class CalendarTableCellTableViewCell: UITableViewCell {

    @IBOutlet weak var startAtLabel: UIView!
    @IBOutlet weak var endAtLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var calendarEventBubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        calendarEventBubbleView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
