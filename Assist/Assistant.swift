//
//  Assistant.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Assistant: NSObject {
    
    var firstName: String?
    var lastName: String?
    var profilePicURL: URL?
    
    init(assistantDict: NSDictionary) {
        super.init()
        self.firstName = assistantDict["first_name"] as? String
        self.lastName = assistantDict["last_name"] as? String
        // self.profilePicURL = assistantDict["profile_pic"]
    }
}
