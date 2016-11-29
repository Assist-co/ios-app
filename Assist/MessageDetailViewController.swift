//
//  MessageDetailViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController {
    @IBOutlet weak var textViewShadow: UIView!

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var profilePicHeight: NSLayoutConstraint!
    
    @IBOutlet weak var schedulingButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var reminderButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var inquiryButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    @IBOutlet weak var profilePicShadow: UIView!
    
    var taskTagSelected: UIButton?
    var toolBar: UIToolbar!
    var createTaskBarButton: UIBarButtonItem!
    var sendMessageBarButton: UIBarButtonItem!
    var message = ""
    var delegate: MessageListener?
    
    /** UIViewController Methods **/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Remove extraneous newline
        textView.deleteBackward()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))

        self.createTaskBarButton = createTaskButtonBuilder()
        self.sendMessageBarButton = sendMessageButtonBuilder()
        
        styleKeyboardToolbar(barButton: self.sendMessageBarButton)
        
        styleElements()
        
        textView.text = message
        textView.becomeFirstResponder()
    }
    
    
    /** IBAction Methods **/
    
    // Respond to user selecting a tag
    @IBAction func taskTagButtonTap(_ sender: AnyObject) {
        let buttons = [
            schedulingButton,
            emailButton,
            reminderButton,
            phoneButton,
            inquiryButton,
            otherButton
        ]
        for button in buttons {
            if button != sender as? UIButton {
                button?.backgroundColor = UIColor.white
                button?.titleLabel?.textColor = UIColor.gray
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    button?.layer.borderColor = UIColor.lightGray.cgColor
                })
            }
        }
        
        let pressedButton = sender as! UIButton
        if taskTagSelected == pressedButton {
            taskTagSelected = nil
            pressedButton.backgroundColor = UIColor.white
            pressedButton.setTitleColor(UIColor.gray, for:UIControlState.normal)
            pressedButton.layer.borderColor = UIColor.lightGray.cgColor
            styleKeyboardToolbar(barButton: self.sendMessageBarButton)
        } else {
            taskTagSelected = pressedButton
            pressedButton.backgroundColor = UIColor(hexString: "#5cd65c25")
            pressedButton.layer.borderColor = UIColor(hexString: "#29a329FF")?.cgColor
            pressedButton.setTitleColor(UIColor(hexString: "#29a329FF"), for: UIControlState.normal)
            styleKeyboardToolbar(barButton: self.createTaskBarButton)
        }
    }

    @IBAction func onCancel(_ sender: AnyObject) {
        textView.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }

    /** Private methods **/
    
    private func styleElements() {
        toolBar.barStyle = UIBarStyle.default
        
        self.automaticallyAdjustsScrollViewInsets = false
        textView.layer.cornerRadius = 4
        textView.contentSize = self.textView.bounds.size
        textView.autocorrectionType = .no
        
        textViewShadow.layer.cornerRadius = 4
        textViewShadow.layer.shadowColor = UIColor.gray.cgColor
        textViewShadow.layer.shadowOpacity = 0.15
        textViewShadow.layer.shadowOffset = CGSize.zero
        textViewShadow.layer.shadowRadius = 3
        
        profilePic.layer.cornerRadius = profilePicHeight.constant / 2
        profilePic.clipsToBounds = true

        profilePicShadow.layer.shadowColor = UIColor.lightGray.cgColor
        profilePicShadow.layer.shadowOpacity = 0.8
        profilePicShadow.layer.shadowOffset = CGSize.zero
        profilePicShadow.layer.shadowRadius = 2
        profilePicShadow.layer.cornerRadius = profilePicHeight.constant / 2
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#111111ff")
        
        for button in [schedulingButton, emailButton, reminderButton, phoneButton, inquiryButton, otherButton] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.lightGray.cgColor
            button?.layer.cornerRadius = 4
        }
    }
    
    @objc private func createTaskAction(button: UIButton) {
        // TODO: use correct values for createTask
        TaskService.createTask(taskDict: [:]) { (task: Task?, error: Error?) in
            if let error = error {
                // TODO: show client appropriate error
                print(error.localizedDescription)
            } else {
                // TODO: Post message to messaging api
                self.view.endEditing(true)
                self.dismiss(animated: true)
            }
        }
    }

    @objc private func sendMessageAction(button: UIButton) {
        MessagingClient.sharedInstance.postMessage(message: textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
        delegate?.didReceiveMessage(message: Message(body: textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)))
        self.view.endEditing(true)
        self.dismiss(animated: true)
    }
    
    private func sendMessageButtonBuilder() -> UIBarButtonItem {
        let button =  UIButton(type: .custom)
        button.backgroundColor = UIColor.lightGray
        button.frame = CGRect(x: 0, y: 0, width: 126, height: 31)
        button.layer.cornerRadius = 4
        let label = UILabel(frame: CGRect(x: 3, y: 5, width: 117, height: 20))
        label.text = "Send Message"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor =   UIColor.clear
        button.addTarget(self, action: #selector(sendMessageAction(button:)), for: .touchUpInside)
        button.addSubview(label)
        return UIBarButtonItem(customView: button)
    }
    
    private func createTaskButtonBuilder() -> UIBarButtonItem {
        let button =  UIButton(type: .custom)
        button.backgroundColor = UIColor(hexString: "#40bf40FF")
        button.frame = CGRect(x: 0, y: 0, width: 106, height: 31)
        button.layer.cornerRadius = 4
        let label = UILabel(frame: CGRect(x: 3, y: 5, width: 97, height: 20))
        label.text = "Create Task"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor =   UIColor.clear
        button.addTarget(self, action: #selector(createTaskAction(button:)), for: .touchUpInside)
        button.addSubview(label)
        return UIBarButtonItem(customView: button)
    }
    
    private func styleKeyboardToolbar(barButton: UIBarButtonItem) {
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpacer.width = -12;
        
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            barButton,
            negativeSpacer
        ]
        toolBar.sizeToFit()
        textView.inputAccessoryView = toolBar
    }

}
