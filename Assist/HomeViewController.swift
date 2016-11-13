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
    
    
    /** UIViewController Methods **/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNotifications()
        initMessagingClient()
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
            self.messagesTableView.reloadData()
            NotificationCenter.default.post(name: self.populateEndNotification, object: nil)
        })
    }
    
}
