//
//  Client.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Client: NSObject {
    #if DEBUG
    static var currentUser: Client? = Client(dictionary: ["id": 2, "first_name":"Johnny", "last_name": "Appleseed", "email": "jappleseed@apple.com", "phone":"13477925956", "date_of_birth": "1991-04-25", "profession": "engineer", "gender": "male"] )
    static var currentUserID: Int? = 2
    #else
    static var currentUser: Client?
    static var currentUserID: Int?
    #endif
    var id: Int!
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
    var createdOn: Date!
    var profilePicURL: URL?
    
    // for testing messaging api
    static let currentID:String = "testclient"
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? Int
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.email = dictionary["email"] as? String
        self.password = dictionary["password"] as? String
        self.phone = dictionary["phone"] as? String
        
        if let dateOfBirthString = dictionary["date_of_birth"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
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
        if let createdOnString = dictionary["created_on"] as? String{
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            self.createdOn = formatter.date(from: createdOnString) as Date?
        }
        
    }
}
