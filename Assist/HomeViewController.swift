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

class HomeViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, MessageListener {
    
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
        addShadowToBar()
        
        messageTextField.delegate = self
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
    
    
    /** UITableViewDelegate Methods **/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages?[indexPath.row]
        let identifier = message?.senderId == Client.currentID ? "MessageTableViewCellYou" : "MessageTableViewCell";
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MessageTableViewCell
        cell.message = message
        
        // TODO: move styling code to saner place
        if indexPath.row == 0 {
            cell.topMargin.constant = 24
        } else {
            let lastMessage = messages?[indexPath.row - 1]
            let isMultiMessage = (abs((message?.createdAt?.timeIntervalSince1970)! - (lastMessage?.createdAt?.timeIntervalSince1970)!) < 60)
            if lastMessage?.senderId != message?.senderId || !isMultiMessage {
                cell.topMargin.constant = 8
            } else {
                cell.topMargin.constant = 4

            }
        }
        
        // TODO: move styling code to saner place
        if indexPath.row < (messages?.count)! - 1 {
            let nextMessage = messages?[indexPath.row + 1]
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    /** TextFieldDelegate Methods **/
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let message = self.messageTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        showMessageView(message: message)
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
            
            
            let lastRow = (self.messages?.count ?? 0) - 1
            if lastRow > 0 {
                let lastIndexPath = IndexPath(row: lastRow, section: 0)
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
            
            NotificationCenter.default.post(name: self.populateEndNotification, object: nil)
        })
    }
    
    func didReceiveMessage(message: Message?) {
        if let message = message {
            self.messages?.append(message)
            NotificationCenter.default.post(name: self.populateEndNotification, object: nil)
        }
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
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        UIView.animate(withDuration: duration) { () -> Void in
            self.messageToolbarConstraint.constant = self.messageToolbarBottomConstraintInitialValue!
            self.view.layoutIfNeeded()
        }
    }
    
    private func addShadowToBar() {
        let shadowView = UIView(frame: self.navigationController!.navigationBar.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        shadowView.layer.shadowRadius = 2
        view.addSubview(shadowView)
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
        callButton.setImage(UIImage(named: "phone_icon"), for: .normal)
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
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#111111ff")
        
        messageTextField.autocorrectionType = UITextAutocorrectionType.no
        messageTextField.borderStyle = UITextBorderStyle.none
        
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
}
