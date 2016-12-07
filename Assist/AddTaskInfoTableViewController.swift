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
    var startDate: Date?
    var endDate: Date?
}

fileprivate enum DatePickerType {
    case start
    case end
    case none
}

class AddTaskInfoTableViewController: UITableViewController, TaskInfoDelegate, VENTokenFieldDelegate, VENTokenFieldDataSource, UIPickerViewDelegate {
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var locationImageVIew: UIImageView!
    @IBOutlet weak var contactsImageView: UIImageView!
    private var taskInfo = TaskInfo(){
        didSet{
            if taskInfo.location == nil &&
                taskInfo.contacts.isEmpty &&
                taskInfo.startDate == nil {
                self.saveBarButton.isEnabled = false
            }else{
                self.saveBarButton.isEnabled = true
            }
        }
    }
    private var currDatePickerShowing: DatePickerType = .none
    private var prevDatePickerShowing: DatePickerType = .none
    private var selectedDateIndexPath: IndexPath?
    private var startsDateCell: UITableViewCell?
    private var endsDateCell: UITableViewCell?
    private var selectedStartsDate: Date? {
        didSet{
            self.taskInfo.startDate = selectedStartsDate
        }
    }
    private var selectedEndsDate: Date? {
        didSet{
            self.taskInfo.endDate = selectedEndsDate
        }
    }
    private var isStartDateEmpty: Bool = true
    private var isEndDateEmpty: Bool = true
    var taskTypePermalink: String!
    var taskDataDelegate: TaskDataDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK:- Action
    
    @IBAction func dismiss(barButton: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(barButton: UIBarButtonItem){
        self.taskInfo.startDate = self.selectedStartsDate
        self.taskInfo.endDate = self.selectedEndsDate
        self.taskDataDelegate?.setTaskInfo(taskInfo: self.taskInfo)
        self.dismiss(animated: true, completion: nil)
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

    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let cell = self.tableView.cellForRow(at: self.selectedDateIndexPath!)
        cell?.detailTextLabel?.text = self.dateFormatForDate(date: sender.date)
        if cell?.tag == 300 {
            self.selectedStartsDate = sender.date
        }else{
            self.selectedEndsDate = sender.date
        }
    }
    
    //MARK:- UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        if cell.tag == 300 {
            if self.currDatePickerShowing == .none {
                self.currDatePickerShowing = .start
                self.prevDatePickerShowing = .none
            }else if self.currDatePickerShowing == .start {
                self.prevDatePickerShowing = .start
                self.currDatePickerShowing = .none
            }else if self.currDatePickerShowing == .end {
                self.prevDatePickerShowing = .end
                self.currDatePickerShowing = .start
            }
        }else if cell.tag == 400 {
            if self.currDatePickerShowing == .none {
                self.currDatePickerShowing = .end
                self.prevDatePickerShowing = .none
            }else if self.currDatePickerShowing == .end {
                self.prevDatePickerShowing = .end
                self.currDatePickerShowing = .none
            }else if self.currDatePickerShowing == .start {
                self.prevDatePickerShowing = .start
                self.currDatePickerShowing = .end
            }
        }
        if cell.tag == 300 || cell.tag == 400 {
            self.selectedDateIndexPath = indexPath
            self.manageDatePickerRow()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            // contacts
            return 48.0
        }else if indexPath.section == 2 {
            // date
            if self.currDatePickerShowing != .none {
                if self.currDatePickerShowing == .start && indexPath.row == 1{
                    return 150
                }else if self.currDatePickerShowing == .end && indexPath.row == 2{
                    return 150
                }
            }
        }
        return 48.0
    }
    
    //MARK: UITableViewDatasource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 1
        }else{
            if self.currDatePickerShowing != .none {
                return 3
            }else{
                return 2
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // contacts
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell", for: indexPath) as! ContactsTableViewCell
            cell.contactsTextView.dataSource = self
            cell.contactsTextView.delegate = self
            cell.contactsTextView.reloadData()
            cell.contactsTextView.toLabelText = nil
            cell.contactsTextView.toLabel.text = ""
            cell.contactsTextView.placeholderText = ""
            cell.contactsTextView.tintColor = UIColor.white
            cell.contactsTextView.toLabelTextColor = UIColor.white
            cell.contactsTextView.inputTextFieldTextColor = UIColor.white
            cell.contactsTextView.setColorScheme(UIColor.white)
            if self.taskInfo.contacts.count > 0 {
                cell.contactsPlaceholderLabel.isHidden = true
            }else{
                cell.contactsPlaceholderLabel.isHidden = false
            }
            cell.contactsImageView.tintColor = UIColor(red: 37/255, green: 110/255, blue: 147/255, alpha: 1)
            return cell
        }
        else if indexPath.section == 1 {
            // location
            let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! LocationTableViewCell
            if self.taskInfo.location != nil {
                cell.locationPlaceholderLabel.isHidden = true
                cell.locationTextView.attributedText = self.locationText()
            }else{
                cell.locationPlaceholderLabel.isHidden = false
                cell.locationTextView.attributedText = nil
            }
            cell.locationImageView.tintColor = UIColor(red: 37/255, green: 110/255, blue: 147/255, alpha: 1)
            return cell
        }
        else {
            // dates
            if self.currDatePickerShowing != .none {
                let cell = tableView.dequeueReusableCell(withIdentifier: "datePickerCell",
                                                         for: indexPath) as! DateTimeTableViewCell
                cell.datePicker.backgroundColor = UIColor(hexString: "#2C2F34ff")
                cell.datePicker.tintColor = UIColor.white
                cell.datePicker.setValue(UIColor.white, forKeyPath: "textColor")
                cell.datePicker.setValue(false, forKey: "highlightsToday")
                if indexPath.row == 1 && self.isStartDateEmpty{
                    self.isStartDateEmpty = false
                    if self.isEndDateEmpty {
                        self.selectedStartsDate = Date()
                    }else{
                        self.selectedStartsDate = self.selectedEndsDate?.addingTimeInterval(-(60 * 60 * 1))
                    }
                    cell.datePicker.date = self.selectedStartsDate!
                    let startsDateIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                    let dateCell = tableView.cellForRow(at: startsDateIndexPath)! as UITableViewCell
                    dateCell.detailTextLabel?.text = self.dateFormatForDate(date: self.selectedStartsDate!)
                }else if indexPath.row == 1 && !self.isStartDateEmpty{
                    cell.datePicker.date = self.selectedStartsDate!
                }else if indexPath.row == 2 && self.isEndDateEmpty{
                    self.isEndDateEmpty = false
                    if self.isStartDateEmpty {
                        self.selectedEndsDate = Date().addingTimeInterval((60 * 60 * 1))
                    }else{
                        self.selectedEndsDate = self.selectedStartsDate?.addingTimeInterval((60 * 60 * 1))
                    }
                    cell.datePicker.date = self.selectedEndsDate!
                    let endsDateIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                    let dateCell = tableView.cellForRow(at: endsDateIndexPath)! as UITableViewCell
                    dateCell.detailTextLabel?.text = self.dateFormatForDate(date: self.selectedEndsDate!)
                }else{
                    if let endsDate = self.selectedEndsDate {
                        cell.datePicker.date = endsDate
                    }
                }
                cell.datePicker.tintColor = UIColor(red: 37/255, green: 110/255, blue: 147/255, alpha: 1)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
                if indexPath.row == 0 {
                    cell.textLabel?.text = "Desired Start"
                    cell.tag = 300
                    if let startsDate = self.selectedStartsDate {
                        cell.detailTextLabel?.text = self.dateFormatForDate(date: startsDate)
                    }
                }else if indexPath.row == 1 {
                    cell.textLabel?.text = "Desired End"
                    cell.tag = 400
                    if let endsDate = self.selectedEndsDate {
                        cell.detailTextLabel?.text = self.dateFormatForDate(date: endsDate)
                    }
                }
                return cell
            }
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
        self.tableView.reloadData()
    }
    
    func addContacts(contacts: [CNContact]) {
        self.taskInfo.contacts = contacts
        self.tableView.reloadData()
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#181A1Dff")
        navigationController!.navigationBar.isTranslucent = false

    }
    
    fileprivate func manageDatePickerRow(){
        var insertIndexPath: IndexPath?
        var deleteIndexPath: IndexPath?
        switch self.currDatePickerShowing {
        case .start:
            insertIndexPath = IndexPath(row: 1, section: 2)
        case .end:
            insertIndexPath = IndexPath(row: 2, section: 2)
        default: break
        }
        
        switch self.prevDatePickerShowing {
        case .start:
            deleteIndexPath = IndexPath(row: 1, section: 2)
        case .end:
            deleteIndexPath = IndexPath(row: 2, section: 2)
        default: break
        }

        self.tableView.beginUpdates()
        if insertIndexPath != nil{
            self.tableView.insertRows(at: [insertIndexPath!], with: .fade)
        }
        if deleteIndexPath != nil{
            self.tableView.deleteRows(at: [deleteIndexPath!], with: .fade)
        }
        self.tableView.endUpdates()
    }
    
    fileprivate func locationText() -> NSMutableAttributedString{
        let mapItem = self.taskInfo.location!
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
        let text = "\(mapItem.placemark.name!) \n" +
        "\(address)"
        let attrText = NSMutableAttributedString(string: text, attributes: [:])
        let titlelocInt = 0
        let titleLengthInt = mapItem.placemark.name!.characters.count
        attrText.addAttribute(NSForegroundColorAttributeName,
                               value: UIColor(red: 239/255, green: 239/255, blue: 244/255, alpha: 1),
                               range: NSRange(location: titlelocInt, length:titleLengthInt))
        if address.characters.count > 0 {
            let subLocInt = (mapItem.placemark.name?.characters.count)! + 2
            let subLengthInt = address.characters.count
            attrText.addAttribute(NSForegroundColorAttributeName,
                                  value: UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1),
                                  range: NSRange(location: subLocInt, length:subLengthInt))
        }
        return attrText
    }
    
    fileprivate func dateFormatForDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
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
