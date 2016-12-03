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
    private var isFirstAppearance: Bool = false
    private let placeholderText = "Enter task here!"
    private var isTagsTrayShowing: Bool = false
    private var tagsTrayViewOriginCenter: CGPoint!
    private var selectedTaskTypeButton: TaskTypeButton?
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
        taskButton.backgroundColor = UIColor.clear
        self.selectedTaskTypeButton = taskButton
        if taskButton is ScheduleTaskTypeButton {
            
        }else if taskButton is EmailTaskTypeButton {
        
        }else if taskButton is ReminderTaskTypeButton {
            
        }else if taskButton is CallTaskTypeButton {
            
        }else if taskButton is InquiryTaskTypeButton {
            
        }else if taskButton is OtherTaskTypeButton {
            
        }
    }
    
    func taskTagButtonHighlighted(taskButton: TaskTypeButton){
        taskButton.backgroundColor = UIColor.lightGray
    }
    
    //MARK:- UIGestureRecognizer 
    
    func tagListPanGesture(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .began {
            self.tagsTrayViewOriginCenter = self.tagsTrayView.center
        }else if recognizer.state == .changed {
            let translation = recognizer.translation(in: self.view)
            self.tagsTrayView.center = CGPoint(x: self.tagsTrayViewOriginCenter.x,
                                              y: self.tagsTrayViewOriginCenter.y + translation.y)
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
        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(tagListPanGesture(recognizer:)))
        self.tagsTrayView.addGestureRecognizer(panGesture)
        self.tagsTrayView.frame = CGRect(x: 0,
                                         y: self.view.frame.size.height + 1,
                                         width: self.tagsTrayView.frame.size.width,
                                         height: self.tagsTrayView.frame.size.height)
        self.view.addSubview(self.tagsTrayView)
        self.view.bringSubview(toFront: self.tagsTrayView)
        self.createTaskToolBarView.isHidden = true
        UIView.animate(withDuration: 0.3, animations: {
            
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
        self.tagsTrayView.scheduleTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonPressend(taskButton:)),
                                                       for: .touchUpInside)
        self.tagsTrayView.scheduleTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonHighlighted(taskButton:)),
                                                       for: .touchDown)
        self.tagsTrayView.emailTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonPressend(taskButton:)),
                                                       for: .touchUpInside)
        self.tagsTrayView.emailTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonHighlighted(taskButton:)),
                                                       for: .touchDown)
        self.tagsTrayView.reminderTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonPressend(taskButton:)),
                                                       for: .touchUpInside)
        self.tagsTrayView.reminderTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonHighlighted(taskButton:)),
                                                       for: .touchDown)
        self.tagsTrayView.inquiryTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonPressend(taskButton:)),
                                                       for: .touchUpInside)
        self.tagsTrayView.inquiryTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonHighlighted(taskButton:)),
                                                       for: .touchDown)
        self.tagsTrayView.otherTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonPressend(taskButton:)),
                                                       for: .touchUpInside)
        self.tagsTrayView.otherTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonHighlighted(taskButton:)),
                                                       for: .touchDown)
        self.tagsTrayView.callTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonPressend(taskButton:)),
                                                       for: .touchUpInside)
        self.tagsTrayView.callTaskButton.addTarget(self,
                                                       action: #selector(taskTagButtonHighlighted(taskButton:)),
                                                       for: .touchDown)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
