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
            styleKeyboardToolbar(barButton: sendMessageButtonBuilder())
        } else {
            taskTagSelected = pressedButton
            pressedButton.backgroundColor = UIColor(hexString: "#5cd65c25")
            pressedButton.layer.borderColor = UIColor(hexString: "#29a329FF")?.cgColor
            pressedButton.setTitleColor(UIColor(hexString: "#29a329FF"), for: UIControlState.normal)
            styleKeyboardToolbar(barButton: createTaskButtonBuilder())
        }
    }

    @IBAction func onCancel(_ sender: AnyObject) {
        textView.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        
        styleKeyboardToolbar(barButton: sendMessageButtonBuilder())
        styleElements()
        
        textView.becomeFirstResponder()
    }
    
    func styleElements() {
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
        
        for button in [schedulingButton, emailButton, reminderButton, phoneButton, inquiryButton, otherButton] {
            button?.layer.borderWidth = 1
            button?.layer.borderColor = UIColor.lightGray.cgColor
            button?.layer.cornerRadius = 4
        }
    }
    
    func sendMessageButtonBuilder() -> UIBarButtonItem {
        let button =  UIButton(type: .custom)
        button.backgroundColor = UIColor.lightGray
        //button.addTarget(self, action: Selector("buttonAction"), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 126, height: 31)
        button.layer.cornerRadius = 4
        let label = UILabel(frame: CGRect(x: 3, y: 5, width: 117, height: 20))
        label.font = UIFont(name: "SanFrancisco", size: 10)
        label.text = "Send Message"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor =   UIColor.clear
        button.addSubview(label)
        return UIBarButtonItem(customView: button)
    }
    
    func createTaskButtonBuilder() -> UIBarButtonItem {
        let button =  UIButton(type: .custom)
        button.backgroundColor = UIColor(hexString: "#40bf40FF")
        //button.addTarget(self, action: Selector("buttonAction"), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 106, height: 31)
        button.layer.cornerRadius = 4
        let label = UILabel(frame: CGRect(x: 3, y: 5, width: 97, height: 20))
        label.font = UIFont(name: "SanFrancisco", size: 10)
        label.text = "Create Task"
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor =   UIColor.clear
        button.addSubview(label)
        return UIBarButtonItem(customView: button)
    }
    
    func styleKeyboardToolbar(barButton: UIBarButtonItem) {
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
