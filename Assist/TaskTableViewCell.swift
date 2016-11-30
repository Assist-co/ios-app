//
//  TaskTableViewCell.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    @IBOutlet weak var taskTypeLabel: UILabel!
    @IBOutlet weak var taskTextLabel: UILabel!
    @IBOutlet weak var completedOnLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var taskIcon: UIImageView!
    
    
    override func awakeFromNib() {
        taskIcon.layer.cornerRadius = 6
        taskIcon.clipsToBounds = true
        //taskIcon.backgroundColor = UIColor(hexString: "#256e93ff")
    }
}
