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
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    private var spinner: UIActivityIndicatorView!
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
        self.tokenField(self.contactsTokenField, didChangeText: "a")
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
            break
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
        self.cancelButton.isEnabled = false
        self.saveButton.isEnabled = false
        self.saveButton.setTitle("", for: .normal)
        self.saveButton.addSubview(self.spinner)
        self.spinner.isHidden = false
        self.spinner.startAnimating()
        ContactsService.sharedInstance.searchContactsWith(text: text!) {
            (contacts: [CNContact]?, error: Error?) in
            if error == nil {
                self.filteredContacts = contacts!
                self.tableView.reloadData()
            }
            self.cancelButton.isEnabled = true
            self.saveButton.isEnabled = true
            self.saveButton.setTitle("Save", for: .normal)
            self.spinner.stopAnimating()
            self.spinner.removeFromSuperview()
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
        self.contactsTokenField.tintColor = UIColor.white
        self.contactsTokenField.toLabelTextColor = UIColor.white
        self.contactsTokenField.inputTextFieldTextColor = UIColor.white
        self.contactsTokenField.backgroundColor = UIColor(red: 24/255, green: 26/255, blue: 29/255, alpha: 1)
        self.contactsTokenField.setColorScheme(UIColor.white)
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
        self.spinner.hidesWhenStopped = true
        self.spinner.frame.origin.x = self.saveButton.frame.width/4
        self.spinner.frame.origin.y = self.saveButton.frame.height/4
        self.contactsTokenField.reloadData()
    }

}
