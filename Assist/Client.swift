//
//  Client.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Client: NSObject {
    
    var id: String!
    var firstName: String!
    var lastName: String!
    var password: String!
    var email: String!
    var phone: String!
    override var description: String{
        return "Client: \(self.firstName!) \(self.lastName!)"
    }

    var profession: Profession?
    var isActive: Bool? = true
    var gender: Gender?
    var primaryAssistant: Assistant?
    var dateOfBirth: Date!
    var profilePicURL: URL?
    
    init(dictionary: NSDictionary) {
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.email = dictionary["email"] as? String
        self.password = dictionary["password"] as? String
        self.phone = dictionary["phone"] as? String
        
        if let dateOfBirthString = dictionary["date_of_birth"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
            self.dateOfBirth = formatter.date(from: dateOfBirthString) as Date?
        }
        
        if let professionDict = dictionary["profession"] as? NSDictionary{
            self.profession = Profession(dictionary: professionDict)
        }
        if let genderDict = dictionary["gender"] as? NSDictionary{
            self.gender = Gender(dictionary: genderDict)
        }
        if let assistantDict = dictionary["primary_assistant"] as? NSDictionary{
            self.primaryAssistant = Assistant(dictionary: assistantDict)
        }

        
    }
}
