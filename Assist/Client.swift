//
//  Client.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Client: NSObject {
    
    // TODO: Replace calls to this with real current client id. 
    // This is only for testing Sendbird messaging.
    static var current_id:String = "testclient"
    
    var id: String?
    var phone: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var isActive: Bool?
    var createdOn: Date?
    var updatedOn: Date?
    var gender: String?
    var primaryAssistantID: String?
    var profilePicURL: URL?
    var dateOfBirth: Date?
    var profession: String?
    
    init(clientDict: NSDictionary) {
        self.id = clientDict["id"] as? String
        self.phone = clientDict["phone"] as? String
        self.firstName = clientDict["first_name"] as? String
        self.lastName = clientDict["last_name"] as? String
        self.email = clientDict["email"] as? String
        self.primaryAssistantID = clientDict["primary_assistant_id"] as? String
        // self.profilePicURL = clientDict["profile_pic"] as? URL
        self.gender = clientDict["gender"] as? String
        // self.createdOn = clientDict["created_on"] as? Date
        // self.updatedOn = clientDict["updated_on"] as? Date
        self.profession = clientDict["profession"] as? String
        // self.dateOfBirth = clientDict["date_of_birth"] as? Date
    }
}
