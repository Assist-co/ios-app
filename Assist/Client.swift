//
//  Client.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Client: NSObject {
    var id: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var is_active: Bool?
    var created_on: Date?
    var gender: String?
    var primaryAssistantID: String?
    var profilePicURL: URL?
    
    init(dictionary: NSDictionary) {
        
    }
}
