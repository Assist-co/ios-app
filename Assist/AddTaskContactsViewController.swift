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
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //MARK:- UITableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    //MARK:- VENTokenFieldDelegate
    
    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
        
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        
    }
    
    //MARK:- VENTokenFieldDatasource
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(self.filteredContacts.count)
    }
    
    func tokenFieldCollapsedText(_ tokenField: VENTokenField) -> String {
        return "\(self.filteredContacts.count) Contacts"
    }
    
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        return "Contact"
    }
    
    //MARK:- Actions
    
    @IBAction func dismiss(button: UIButton){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveContacts(button: UIButton){
    
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.contactsTokenField.delegate = self
        self.contactsTokenField.dataSource = self
        self.contactsTokenField.placeholderText = "First name, last name, email"
        self.contactsTokenField.toLabelText = "To:"
    }

}
