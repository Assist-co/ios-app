//
//  HomeViewController.swift
//  Assist
//
//  Created by Hasham Ali on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import SendBirdSDK
import MBProgressHUD

class HomeViewController: SlidableViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MessageListener, UIScrollViewDelegate {
    
    @IBOutlet weak var tableViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var messageToolbarConstraint: NSLayoutConstraint!
    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageToolbar: UIView!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var callButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var voiceButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var textButtonHeight: UIButton!
    
    private var messages: [Message]?
    private var messagesByDay: [(Date, [Message])]?
    private var messageToolbarBottomConstraintInitialValue: CGFloat?
    private var populateStartNotification = NSNotification.Name(rawValue: "populateMessagesStart")
    private var populateEndNotification = NSNotification.Name(rawValue: "populateMessagesEnd")
    private var shouldRefresh: Bool = false
    
    
    /** UIViewController Methods **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNotifications()
        initMessagingClient()
        styleElements()
        
        messageTextField.delegate = self
        messagesTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.messageToolbarBottomConstraintInitialValue = 0.0
        enableKeyboardHideOnTap()
        
        if shouldRefresh {
            shouldRefresh = false
            NotificationCenter.default.post(name: self.populateEndNotification, object: nil)
        }
    }
    
    func showMessageView(message: String?) {
        let storyboard: UIStoryboard = UIStoryboard(name: "MessageDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MessageDetailNavigation") as! UINavigationController
        let messageDetailVC = vc.childViewControllers[0] as! MessageDetailViewController
        messageDetailVC.delegate = self
        messageDetailVC.message = message!
        self.hideKeyboard()
        
        self.shouldRefresh = true
        self.show(vc, sender: self)
        self.hideKeyboard()
    }
    
    /** UIScrollViewDelegate Methods **/
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview!)
        if translation.y > 0 {
            self.hideKeyboard()
        }
    }
    
    /** UITableViewDelegate Methods **/
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableViewWidth = self.messagesTableView.bounds
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewWidth.size.width, height: self.messagesTableView.sectionHeaderHeight))
        headerView.backgroundColor = UIColor(hexString: "#25282Dff")
        
        var headerText = ""
        if let messagesByDay = messagesByDay {
            
            let date = messagesByDay[section].0
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                headerText = "Today"
            } else if calendar.isDateInYesterday(date) {
                headerText = "Yesterday"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.long
                headerText = dateFormatter.string(from: messagesByDay[section].0)
            }
        }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: label.font.fontName, size: 14)
        label.text = headerText.uppercased()
        label.textColor = UIColor(hexString: "#888888ff")
        label.textAlignment = .center
        headerView.addSubview(label)
        label.leftAnchor.constraint(equalTo: headerView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: headerView.rightAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        return headerView
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let messagesByDay = messagesByDay {
            return messagesByDay.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messagesByDay = messagesByDay {
            return messagesByDay[section].1.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        // remove bottom extra 20px space.
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        //let message = messages?[indexPath.row]
        let message = messagesByDay?[indexPath.section].1[indexPath.row]
        let identifier = message?.senderId == Client.currentID ? "MessageTableViewCellYou" : "MessageTableViewCell";
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageTableViewCell
        cell.message = message


        // TODO: move styling code to saner place
        if indexPath.row == 0 {
            cell.topMargin.constant = 24
        } else {
            //let lastMessage = messages?[indexPath.row - 1]
            let lastMessage = messagesByDay?[indexPath.section].1[indexPath.row - 1]
            let isMultiMessage = (abs((message?.createdAt?.timeIntervalSince1970)! - (lastMessage?.createdAt?.timeIntervalSince1970)!) < 60)
            if lastMessage?.senderId != message?.senderId || !isMultiMessage {
                cell.topMargin.constant = 8
            } else {
                cell.topMargin.constant = 1
            }
        }
        
        // TODO: move styling code to saner place
        if indexPath.row < (messagesByDay?[indexPath.section].1.count)! - 1 {
            let nextMessage = messagesByDay?[indexPath.section].1[indexPath.row + 1]
            let isMultiMessage = (abs((message?.createdAt?.timeIntervalSince1970)! - (nextMessage?.createdAt?.timeIntervalSince1970)!) < 60)
            if nextMessage?.senderId != message?.senderId || !isMultiMessage {
                cell.dateLabelHeight.constant = 16
                cell.dateLabelTopMargin.constant = 12
            } else {
                cell.dateLabelHeight.constant = 0
                cell.dateLabelTopMargin.constant = 0
            }
        } else {
            cell.dateLabelHeight.constant = 16
            cell.dateLabelTopMargin.constant = 12
        }

        return cell
    }
    
    
    /** TextFieldDelegate Methods **/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //textField.resignFirstResponder()
        let message = self.messageTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        MessagingClient.sharedInstance.postMessage(message: message!)
        self.didReceiveMessage(message: Message(body: message!))
        textField.text = ""
        return true
    }
    
    /** IBAction Methods **/
    
    @IBAction func onTextClicked(_ sender: UIButton) {
        self.messageTextField.becomeFirstResponder()
    }
    
    @IBAction func onPhoneTap(_ sender: AnyObject) {
        // TODO: replace number with assistant's number
        let phoneNumber = "1234567890"
        if let url = URL(string:"tel://\(phoneNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { (bool: Bool) in
                print("done call")
            }
        }
    }

    @IBAction func onTaskButtonTap(_ sender: AnyObject) {
        self.view.endEditing(true)
        slidingViewController.showLeftContent(duration: 0.25)
    }
    
    @IBAction func onCalendarButtonTap(_ sender: AnyObject) {
        self.view.endEditing(true)
        slidingViewController.showRightContent(duration: 0.25)
    }
    
    /** Internal Methods **/
    
    private func setupTableView() {
        messagesTableView.dataSource = self
        messagesTableView.estimatedRowHeight = 80
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.separatorInset = UIEdgeInsets.zero
        messagesTableView.tableFooterView = UIView()
        MessagingClient.sharedInstance.registerListener(listener: self)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(forName: populateStartNotification, object: nil, queue: OperationQueue.main, using: {
            (notification: Notification) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            MBProgressHUD.showAdded(to: self.view, animated: true)
        })
        
        NotificationCenter.default.addObserver(forName: populateEndNotification, object: nil, queue: OperationQueue.main, using: {
            (notification: Notification) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            self.messagesTableView.reloadData()
            
            
            let lastSection = (self.messagesByDay?.count)! - 1
            let lastRow = (self.messagesByDay?[lastSection].1.count)! - 1
            if lastRow > 0 {
                let lastIndexPath = IndexPath(row: lastRow, section: lastSection)
                self.messagesTableView.scrollToRow(at: lastIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
            }
        })
    }
    
    private func initMessagingClient() {
        NotificationCenter.default.post(name: populateStartNotification, object: nil)
        MessagingClient.sharedInstance.initWithAppId()
        MessagingClient.sharedInstance.login(onSuccess: {
            _ in
            self.populateTableView()
        }, onFailure: {
            _ in
        })
    }
    
    private func populateTableView() {
        NotificationCenter.default.post(name: populateStartNotification, object: nil)
        MessagingClient.sharedInstance.getMessages(onMessagesReceived: {
            (messages: [SBDUserMessage]) -> Void in
            let welcomeMessage = [Message(id: 1, senderId: Assistant.currentID, body: "Welcome, I'm your personal assistant! How can I help you?", createdAt: Date())]
            self.messages = welcomeMessage + messages.map({
                (m: SBDUserMessage) -> Message in
                return Message(sbdUserMessage: m)
            }).reversed()
            self.messagesByDay = self.groupMessagesByDate(inputMessages: self.messages!)
            
            NotificationCenter.default.post(name: self.populateEndNotification, object: nil)
        })
    }
    
    func didReceiveMessage(message: Message?) {
        if let message = message {
            self.messages?.append(message)
            if let messagesByDay = self.messagesByDay {
                if messagesByDay.count > 0 {
                    let lastDay = messagesByDay[messagesByDay.count - 1].0
                    if Calendar.current.isDateInToday(lastDay) {
                        self.messagesByDay?[messagesByDay.count - 1].1.append(message)
                    } else {
                        self.messagesByDay?.append((Date(), [message]))
                    }
                } else {
                    self.messagesByDay = [(Date(), [message])]
                }
            } else {
                messagesByDay = [(Date(), [message])]
            }
            NotificationCenter.default.post(name: self.populateEndNotification, object: nil)
        }
    }
    
    private func groupMessagesByDate(inputMessages: [Message]) -> [(Date,[Message])] {
        var messagesByDate: [(Date, [Message])] = []
        if inputMessages.count > 0 {
            var currDate: Date = inputMessages[0].createdAt!
            var messages: [Message] = []
            for message in inputMessages {
                if Calendar.current.isDate(message.createdAt!, inSameDayAs: currDate) {
                    messages.append(message)
                } else {
                    let messagesCopy = messages
                    messages = [message]
                    messagesByDate.append((currDate, messagesCopy))
                    currDate = message.createdAt!
                }
            }
            if messages != [] {
                messagesByDate.append((currDate, messages))
            }
        }
        return messagesByDate
    }
    
    // Add a gesture on the view controller to close keyboard when tapped
    private func enableKeyboardHideOnTap(){
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.hideKeyboard))
        
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func hideKeyboard() {
        self.view.endEditing(true)
        self.messageToolbar.isHidden = true
        self.messageTextField.text = ""
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        self.messageToolbar.isHidden = false
        UIView.animate(withDuration: duration) { () -> Void in
            self.messageToolbarConstraint.constant = keyboardFrame.size.height
            if (self.messages?.count)! > 3 {
                self.tableViewTopMargin.constant = -(keyboardFrame.size.height - 40)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        self.messageToolbar.isHidden = true
        UIView.animate(withDuration: duration) { () -> Void in
            self.messageToolbarConstraint.constant = self.messageToolbarBottomConstraintInitialValue!
            if (self.messages?.count)! > 3 {
                self.tableViewTopMargin.constant = 0
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func styleElements() {
        voiceButton.layer.cornerRadius = voiceButtonHeight.constant / 2
        voiceButton.backgroundColor = UIColor(hexString: "#256e93ff")
        voiceButton.setImage(UIImage(named: "voice_icon"), for: .normal)
        voiceButton.contentMode = UIViewContentMode.center
        voiceButton.layer.shadowColor = UIColor.gray.cgColor
        voiceButton.layer.shadowOpacity = 0.5
        voiceButton.layer.shadowOffset = CGSize.zero
        voiceButton.layer.shadowRadius = 5
        voiceButton.isHidden = !VoiceToTextClient.sharedInstance.isEnabled
        
        callButton.layer.cornerRadius = callButtonHeight.constant / 2
        callButton.setImage(UIImage(named: "phone"), for: .normal)
        callButton.contentMode = UIViewContentMode.center
        callButton.layer.shadowColor = UIColor.gray.cgColor
        callButton.layer.shadowOpacity = 0.3
        callButton.layer.shadowOffset = CGSize.zero
        callButton.layer.shadowRadius = 5
        
        textButton.layer.cornerRadius = callButtonHeight.constant / 2
        textButton.setImage(UIImage(named: "message_icon"), for: .normal)
        textButton.contentMode = UIViewContentMode.center
        textButton.layer.shadowColor = UIColor.gray.cgColor
        textButton.layer.shadowOpacity = 0.5
        textButton.layer.shadowOffset = CGSize.zero
        textButton.layer.shadowRadius = 5
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#181A1Dff")
        navigationController!.navigationBar.isTranslucent = false
        
        messageTextField.autocorrectionType = UITextAutocorrectionType.no
        messageTextField.borderStyle = UITextBorderStyle.none
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
