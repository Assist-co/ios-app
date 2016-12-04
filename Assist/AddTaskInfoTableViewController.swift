//
//  AddTaskMetadataViewController.swift
//  Assist
//
//  Created by christopher ketant on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import MapKit
import Contacts
import VENTokenField

protocol TaskInfoDelegate: class {
    func addContacts(contacts: [CNContact])
    func addLocation(mapItem: MKMapItem)
}

struct TaskInfo {
    var location: MKMapItem?
    var contacts: [CNContact] = []
}

class AddTaskInfoTableViewController: UITableViewController, TaskInfoDelegate, VENTokenFieldDelegate, VENTokenFieldDataSource {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var contactsTokenField: VENTokenField!
    private var taskInfo = TaskInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK:- Action
    
    @IBAction func dismiss(barButton: UIBarButtonItem){
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func save(barButton: UIBarButtonItem){
    
    }
    
    @IBAction func addMetadata(button: UIButton) {
        if button.tag == 100 {
            // add contacts
            self.performSegue(withIdentifier: "addContactsSegue", sender: self)
        }else{
            // add location
            self.performSegue(withIdentifier: "addLocationSegue", sender: self)
        }
    }
    
    //MARK:- VENTokenFieldDatasource
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(self.taskInfo.contacts.count)
    }
    
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        let contact = self.taskInfo.contacts[Int(index)]
        return "\(contact.givenName) \(contact.familyName)"
    }
    
    //MARK:- TaskInfoDelegate
    
    func addLocation(mapItem: MKMapItem) {
        self.taskInfo.location = mapItem
        let placemark = mapItem.placemark
        var address = ""
        if placemark.subThoroughfare != nil{
            address += placemark.subThoroughfare!
        }
        if placemark.thoroughfare != nil{
            address += placemark.thoroughfare!
            address += ", "
        }
        if placemark.locality != nil{
            address += " "
            address += placemark.locality!
        }
        if address.characters.count > 0 {
            let text = "\(mapItem.placemark.name!) \(address)"
            let attrText = NSMutableAttributedString(string: text, attributes: [:])
            let locInt = (mapItem.placemark.name?.characters.count)!
            let lengthInt = address.characters.count
            attrText.addAttribute(NSForegroundColorAttributeName,
                                  value: UIColor.darkGray,
                                  range: NSRange(location: locInt, length:lengthInt))
            self.locationTextField.attributedText = attrText
        }else{
            self.locationTextField.text = placemark.name!
        }
    }
    
    func addContacts(contacts: [CNContact]) {
        self.taskInfo.contacts = contacts
        self.contactsTokenField.reloadData()
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        self.contactsTokenField.delegate = self
        self.contactsTokenField.dataSource = self
        self.contactsTokenField.toLabelText = "To:"
        self.contactsTokenField.reloadData()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationSegue" {
            let vc = segue.destination as! AddTaskLocationViewController
            vc.taskInfoDelegate = self
        }else if segue.identifier == "addContactsSegue" {
            let vc = segue.destination as! AddTaskContactsViewController
            vc.taskInfoDelegate = self
            vc.selectedContacts = self.taskInfo.contacts
        }
    }
    

}
