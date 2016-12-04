//
//  CreateTaskViewController.swift
//  Assist
//
//  Created by christopher ketant on 12/2/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    private var createTaskToolBarView: CreateTaskToolBarView!
    private var tagsTrayView: TagsTrayView!
    private var isFirstAppearance: Bool = true
    private let placeholderText = "Enter task here!"
    private var isTagsTrayShowing: Bool = false
    private var tagsTrayViewOriginCenter: CGPoint!
    private var selectedTaskTypeButton: TaskTypeButton?
    private var trayFrictionVal = 0
    private let trayFrictionConstant = 4
    private var taskTagButtons: [TaskTypeButton] = []
    override var canBecomeFirstResponder: Bool{
        get{
            return true
        }
    }
    override var inputAccessoryView: UIView{
        get{
            return self.toolBarBuilder()
        }
    }
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = self.view.frame.size;
        self.scrollView.contentSize.height = self.scrollView.contentSize.height
    }
    
    //MARK:- UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && !self.isFirstAppearance {
            textView.text = nil
            textView.textColor = UIColor.black
        }else{
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            self.isFirstAppearance = false
        }
        if self.isTagsTrayShowing{
            self.dismissTagsTrayView()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range, with: text)
        if (updatedText?.isEmpty)! {
            
            textView.text = self.placeholderText
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    //MARK:- UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && !scrollView.isDragging {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentOffset.y = 0
            }, completion: { (success: Bool) in
                
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && !scrollView.isDragging {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentOffset.y = 0
            }, completion: { (success: Bool) in
                
            })
        }

    }
    
    //MARK:- Action
    
    func toolBarPressed(button: UIButton){
        self.createTaskToolBarView.backgroundColor = UIColor.groupTableViewBackground
        if !self.isTagsTrayShowing {
            self.showTagsTrayView()
        }
    }
    
    func toolBarHighlighted(button: UIButton){
        self.createTaskToolBarView.backgroundColor = UIColor.lightGray
    }
    
    func taskTagButtonPressend(taskButton: TaskTypeButton){
        self.selectedTaskTypeButton = taskButton
        for button in self.taskTagButtons{
            if button != taskButton {
                taskButton.backgroundColor = UIColor.clear
            }else{
                taskButton.backgroundColor = UIColor.red
            }
        }
        self.performSegue(withIdentifier: "addTaskMetadataSegue", sender: self)
    }
    
    @IBAction func dismissCreateTask(barButton: UIBarButtonItem){
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func postTask(barButton: UIBarButtonItem){
    
    }
    
    //MARK:- UIGestureRecognizer 
    
    func tagListPanGesture(recognizer: UIPanGestureRecognizer){
        let translation = recognizer.translation(in: self.view)
        if recognizer.state == .began {
            self.tagsTrayViewOriginCenter = self.tagsTrayView.center
        }else if recognizer.state == .changed {
            if self.trayFrictionVal == self.trayFrictionConstant {
                UIView.animate(withDuration: 0.5, animations: {
                    self.tagsTrayView.center = CGPoint(x: self.tagsTrayViewOriginCenter.x,
                                                       y: self.tagsTrayViewOriginCenter.y + translation.y)
                }, completion: { (isComplete: Bool) in
                })
                self.trayFrictionVal = 0
            }else{
                self.trayFrictionVal += 1
            }
        }else if recognizer.state == .ended {
            UIView.animate(withDuration: 0.1, animations: {
                self.tagsTrayView.center = self.tagsTrayViewOriginCenter
            }, completion: { (isComplete: Bool) in
            })
        }
    }
    
    //MARK:- Utils
    
    fileprivate func showTagsTrayView(){
        self.textView.resignFirstResponder()
        // Hide toolbar
        UIView.animate(withDuration: 0.3, animations: {
            self.createTaskToolBarView.alpha = 0
        }) { (success: Bool) in
            self.createTaskToolBarView.isHidden = success
        }
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(tagListPanGesture(recognizer:)))
        self.tagsTrayView.addGestureRecognizer(panGesture)
        self.tagsTrayView.frame = CGRect(x: 0,
                                         y: self.view.frame.size.height + 1,
                                         width: self.tagsTrayView.frame.size.width,
                                         height: self.tagsTrayView.frame.size.height)
        self.view.addSubview(self.tagsTrayView)
        self.view.bringSubview(toFront: self.tagsTrayView)
        // Show tray
        UIView.animate(withDuration: 0, animations: {
            let y = (self.view.frame.size.height - self.tagsTrayView.frame.size.height)
            self.tagsTrayView.frame = CGRect(x: 0,
                                             y: y,
                                             width: self.tagsTrayView.frame.size.width,
                                             height: self.tagsTrayView.frame.size.height)
            self.tagsTrayViewOriginCenter = self.tagsTrayView.center
        }) { (success: Bool) in
            self.isTagsTrayShowing = true
        }
    }
    
    fileprivate func dismissTagsTrayView(){
        UIView.animate(withDuration: 0.3, animations: {
            let y = (self.view.frame.size.height + 1)
            self.tagsTrayView.frame = CGRect(x: 0,
                                             y: y,
                                             width: self.tagsTrayView.frame.size.width,
                                             height: self.tagsTrayView.frame.size.height)
            self.tagsTrayViewOriginCenter = self.tagsTrayView.center
            self.createTaskToolBarView.isHidden = false
        }) { (success: Bool) in
            self.tagsTrayView.removeFromSuperview()
            self.isTagsTrayShowing = false
        }

    }
    
    fileprivate func setup(){
        self.tagsTrayView = UINib(nibName: "TagsTrayView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! TagsTrayView
        self.tagsTrayView.frame.size.width = self.view.frame.size.width
        self.textView.text = self.placeholderText
        self.textView.textColor = UIColor.lightGray
        self.textView.frame.size.height = 0
        self.taskTypeButtonsBuilder()
        self.textView.becomeFirstResponder()
    }
    
    fileprivate func toolBarBuilder() -> UIView{
        self.createTaskToolBarView = UINib(nibName: "CreateTaskToolBarView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! CreateTaskToolBarView
        self.createTaskToolBarView.frame.size.width = self.view.frame.size.width
        self.createTaskToolBarView.backgroundColor = UIColor.groupTableViewBackground
        self.createTaskToolBarView.selectButton.addTarget(self, action: #selector(toolBarPressed(button:)), for: .touchUpInside)
        self.createTaskToolBarView.selectButton.addTarget(self, action: #selector(toolBarHighlighted(button:)), for: .touchDown)
        return self.createTaskToolBarView
    }
    
    fileprivate func taskTypeButtonsBuilder(){
        let stackView = self.tagsTrayView.subviews.first
        for view in (stackView?.subviews)!{
            for subView in view.subviews {
                if subView is TaskTypeButton {
                    self.taskTagButtons.append(subView as! TaskTypeButton)
                }
            }
        }
        for button in self.taskTagButtons{
            button.addTarget(self,
                             action: #selector(taskTagButtonPressend(taskButton:)),
                             for: .touchUpInside)
        }

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTaskMetadataSegue" {
            
        }
    }

}
