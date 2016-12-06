//
//  TagListView.swift
//  Assist
//
//  Created by christopher ketant on 12/2/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class TagsTrayView: UIView {
    @IBOutlet weak var scheduleTaskButton: TaskTypeButton!
    @IBOutlet weak var emailTaskButton: TaskTypeButton!
    @IBOutlet weak var reminderTaskButton: TaskTypeButton!
    @IBOutlet weak var callTaskButton: TaskTypeButton!
    @IBOutlet weak var inquiryTaskButton: TaskTypeButton!
    @IBOutlet weak var otherTaskButton: TaskTypeButton!
    @IBOutlet weak var scheduleIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var reminderIcon: UIImageView!
    @IBOutlet weak var phoneCallIcon: UIImageView!
    @IBOutlet weak var inquiryIcon: UIImageView!
    @IBOutlet weak var otherIcon: UIImageView!


    
    override func awakeFromNib() {
        scheduleIcon.layer.cornerRadius = 6
        emailIcon.layer.cornerRadius = 6
        reminderIcon.layer.cornerRadius = 6
        phoneCallIcon.layer.cornerRadius = 6
        inquiryIcon.layer.cornerRadius = 6
        otherIcon.layer.cornerRadius = 6
        
        scheduleIcon.image = #imageLiteral(resourceName: "calendar")
        emailIcon.image = #imageLiteral(resourceName: "mail")
        phoneCallIcon.image = #imageLiteral(resourceName: "phone_small")
        reminderIcon.image = #imageLiteral(resourceName: "clock")
        inquiryIcon.image = #imageLiteral(resourceName: "magnifying_glass")
        otherIcon.image = #imageLiteral(resourceName: "other")
    

        reminderIcon.backgroundColor = UIColor(hexString: "#FFCA28ff")
        phoneCallIcon.backgroundColor = UIColor(hexString: "#ED5E5Eff")
        scheduleIcon.backgroundColor = UIColor(hexString: "#66BB6Aff")
        otherIcon.backgroundColor = UIColor(hexString: "#AC7339ff")
        inquiryIcon.backgroundColor = UIColor(hexString: "#7E57C2ff")
        emailIcon.backgroundColor = UIColor(hexString: "#42A5F5ff")
    }
}
