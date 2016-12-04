//
//  ContactsService.swift
//  Assist
//
//  Created by christopher ketant on 11/27/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import Contacts

class ContactsService: NSObject {
    let contactStore = CNContactStore()
    var isAccessGranted: Bool?
    static let sharedInstance = ContactsService()
    
    override init() {
        super.init()
        self.requestContactsAccess { (isAccessGranted: Bool, error: Error?) in
            self.isAccessGranted = isAccessGranted
        }
    }
    
    //MARK:- Search
    
    func searchContactsWith(text: String, completion: @escaping ([CNContact]?, Error?) -> Void){
        let predicate = CNContact.predicateForContacts(matchingName: text)
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactImageDataKey] as [Any]
        var contacts = [CNContact]()
        do {
            contacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keys as! [CNKeyDescriptor])
            completion(contacts, nil)
        }catch let error{
            completion(nil, error)
        }
    }
    
    //MARK:- Utils
    
    fileprivate func requestContactsAccess(completion: @escaping (Bool, Error?) -> Void){
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            self.isAccessGranted = true
            completion(true, nil)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completion(access, accessError)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.isAccessGranted = access
                            completion(access, accessError)
                        })
                    }
                }
            })
            
        default:
            self.isAccessGranted = false
            completion(false, nil)
        }
    }
}
