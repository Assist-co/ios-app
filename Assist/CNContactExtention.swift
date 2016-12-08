//
//  CNContactExtention.swift
//  Assist
//
//  Created by christopher ketant on 12/5/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import Foundation
import Contacts

extension CNContact {
    
    func serialize(clientID: Int) -> [String:Any]{
        var attrs: [String:Any] = ["client_id": clientID as Any]
        if self.givenName.characters.count > 0 {
            attrs["first_name"] = self.givenName as Any
        }
        if self.familyName.characters.count > 0 {
            attrs["last_name"] = self.familyName as Any
        }
        if let email = self.emailAddresses.first {
            attrs["email"] = email.value as Any
        }
        if let number = self.phoneNumbers.first {
            attrs["phone"] = number.value.stringValue as Any
        }
        return attrs
    }
}
