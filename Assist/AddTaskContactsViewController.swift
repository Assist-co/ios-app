//
//  AddTaskContactsViewController.swift
//  Assist
//
//  Created by christopher ketant on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import VENTokenField
import Contacts

class AddTaskContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, VENTokenFieldDataSource, VENTokenFieldDelegate {
    @IBOutlet weak var contactsTokenField: VENTokenField!
    @IBOutlet weak var tableView: UITableView!
    private var filteredContacts: [CNContact] = []
    var selectedContacts: [CNContact] = []
    weak var taskInfoDelegate: TaskInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contactsTokenField.becomeFirstResponder()
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredContacts.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = self.filteredContacts[indexPath.row]
        self.selectedContacts.append(contact)
        self.filteredContacts.remove(at: indexPath.row)
        self.tableView.reloadData()
        self.contactsTokenField.reloadData()
    }
    
    //MARK:- UITableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell",
                                                 for: indexPath) as UITableViewCell
        let contact = self.filteredContacts[indexPath.row]
        cell.textLabel?.text = "\(contact.givenName) \(contact.familyName)"
        for email in contact.emailAddresses {
            cell.detailTextLabel?.text = email.value as String
        }
        if cell.detailTextLabel?.text == nil {
            for number in contact.phoneNumbers {
                cell.detailTextLabel?.text = number.value.stringValue as String
            }
        }
        if let imageData = contact.imageData {
            cell.imageView?.image = UIImage(data: imageData)
        }
        return cell
    }
    
    //MARK:- VENTokenFieldDelegate
    
    func tokenField(_ tokenField: VENTokenField, didChangeText text: String?) {
        ContactsService.sharedInstance.searchContactsWith(text: text!) {
            (contacts: [CNContact]?, error: Error?) in
            if error == nil {
                self.filteredContacts = contacts!
                self.tableView.reloadData()
            }
        }

    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        self.selectedContacts.remove(at: Int(index))
        self.contactsTokenField.reloadData()
    }
    
    //MARK:- VENTokenFieldDatasource
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(self.selectedContacts.count)
    }
    
    func tokenFieldCollapsedText(_ tokenField: VENTokenField) -> String {
        return "\(self.selectedContacts.count) Contacts"
    }
    
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        let contact = self.selectedContacts[Int(index)]
        return "\(contact.givenName) \(contact.familyName)"
    }
    
    //MARK:- Actions
    
    @IBAction func dismiss(button: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveContacts(button: UIButton){
        self.taskInfoDelegate?.addContacts(contacts: self.selectedContacts)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.contactsTokenField.delegate = self
        self.contactsTokenField.dataSource = self
        self.contactsTokenField.placeholderText = "First name, last name, email"
        self.contactsTokenField.toLabelText = "To:"
        _ = ContactsService.sharedInstance
        self.contactsTokenField.reloadData()
    }

}