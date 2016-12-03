//
//  Contact.swift
//  Assist
//
//  Created by christopher ketant on 11/30/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class Contact: NSObject {
    var id: Int!
    var firstName: String!
    var lastName: String!
    var email: String!
    var phone: String!
    override var description: String{
        return "Contact: \(self.firstName!) \(self.lastName!)"
    }
    
    init(dictionary: NSDictionary) {
        self.id = dictionary["id"] as? Int
        self.firstName = dictionary["first_name"] as? String
        self.lastName = dictionary["last_name"] as? String
        self.email = dictionary["email"] as? String
        self.phone = dictionary["phone"] as? String
    }
    
    class func contacts(array: [NSDictionary]) -> [Contact]{
        var contacts = [Contact]()
        for dictionary in array {
            let contact = Contact(dictionary: dictionary)
            contacts.append(contact)
        }
        return contacts
    }

}
