//
//  ContactsService.swift
//  Assist
//
//  Created by christopher ketant on 11/27/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import Contacts

class ContactsService: NSObject {
    public let contactStore = CNContactStore()
    public var isAccessGranted: Bool?
    public let shared = ContactsService()
    
    override init() {
        super.init()
        self.requestContactsAccess { (isAccessGranted: Bool, error: Error?) in
            self.isAccessGranted = isAccessGranted
        }
    }
    
    //MARK:- Search
    
    func searchContactsWith(string: String, completion: @escaping ([CNContact]) -> Void){
        let predicate = CNContact.predicateForContacts(matchingName: string)
        let keys = [CNContactFormatter.descriptorForRequiredKeys(for: CNContactFormatterStyle.fullName), CNContactEmailAddressesKey] as [Any]
        var contacts = [CNContact]()
        do {
            contacts = try self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keys as! [CNKeyDescriptor])
            completion(contacts)
        }catch {
            completion(contacts)
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
