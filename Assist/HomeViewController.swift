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

class HomeViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var messagesTableView: UITableView!
    
    private var messages: [SBDUserMessage]?
    private var populateStartNotification = NSNotification.Name(rawValue: "populateMessagesStart")
    private var populateEndNotification = NSNotification.Name(rawValue: "populateMessagesEnd")
    
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var callButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var voiceButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var textButtonHeight: UIButton!
    
    /** UIViewController Methods **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNotifications()
        initMessagingClient()
        styleButtons()
        addShadowToBar()
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func addShadowToBar() {
        let shadowView = UIView(frame: self.navigationController!.navigationBar.frame)
        shadowView.backgroundColor = UIColor.white
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        shadowView.layer.shadowRadius = 2
        view.addSubview(shadowView)
    }
    
    func styleButtons() {
        voiceButton.layer.cornerRadius = voiceButtonHeight.constant / 2
        voiceButton.backgroundColor = UIColor(hexString: "#5cd65cFF")
        voiceButton.setImage(UIImage(named: "voice_icon"), for: .normal)
        voiceButton.contentMode = UIViewContentMode.center
        voiceButton.layer.shadowColor = UIColor.gray.cgColor
        voiceButton.layer.shadowOpacity = 0.5
        voiceButton.layer.shadowOffset = CGSize.zero
        voiceButton.layer.shadowRadius = 5
        
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
    }
    
    
    /** UITableViewDelegate Methods **/
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messagesTableView.dequeueReusableCell(withIdentifier: "MessageTableViewCell", for: indexPath) as! MessageTableViewCell
        cell.message = messages?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }

    
    /** IBAction Methods **/
    
    @IBAction func onTextClicked(_ sender: UIButton) {
        
    }
    
    
    /** Internal Methods **/
    
    private func setupTableView() {
        messagesTableView.dataSource = self
        messagesTableView.estimatedRowHeight = 80
        messagesTableView.rowHeight = UITableViewAutomaticDimension
        messagesTableView.separatorInset = UIEdgeInsets.zero
        messagesTableView.tableFooterView = UIView()
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
            self.messages = messages
            NotificationCenter.default.post(name: self.populateEndNotification, object: nil)
        })
    }
    
}
