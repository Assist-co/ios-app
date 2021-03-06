//
//  CreateTaskViewController.swift
//  Assist
//
//  Created by christopher ketant on 12/2/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

protocol TaskDataDelegate: class {
    func setTaskInfo(taskInfo: TaskInfo)
}

class CreateTaskViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate, TaskDataDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UIPlaceholderTextView!
    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    private var spinner: UIActivityIndicatorView!
    private var barButtonSpinner: UIBarButtonItem!
    private var postBarButton: UIBarButtonItem!
    private var createTaskToolBarView: CreateTaskToolBarView!
    private var tagsTrayView: TagsTrayView!
    private var isFirstAppearance: Bool = true
    private var isTagsTrayShowing: Bool = false
    private var tagsTrayViewOriginCenter: CGPoint!
    private var selectedTaskTypeButton: TaskTypeButton?
    private var trayFrictionVal = 0
    private let trayFrictionConstant = 4
    private var taskTagButtons: [TaskTypeButton] = []
    private var taskInfo: TaskInfo?
    var message: String?{
        didSet{
            if let text = message {
                if let textView = self.textView {
                    if text.characters.count > 0 {
                        textView.text = text
                        self.postBarButton.isEnabled = true
                    }
                }
            }
        }
    }
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
        
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#181A1Dff")
        navigationController!.navigationBar.isTranslucent = false
        
        if let message = self.message {
            if message.characters.count > 0 {
                self.textView.text = message
                self.postBarButton.isEnabled = true
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = self.view.frame.size
        self.scrollView.contentSize.height = self.scrollView.contentSize.height
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.createTaskToolBarView != nil{
            if self.isTagsTrayShowing {
                self.createTaskToolBarView.isHidden = true
            }else{
                self.createTaskToolBarView.isHidden = false
            }
        }
    }
    
    //MARK:- UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.isTagsTrayShowing{
            self.dismissTagsTrayView()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.postBarButton.isEnabled = textView.text.characters.count > 0
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
    
    //MARK:- TaskDataDelegate
    
    func setTaskInfo(taskInfo: TaskInfo) {
        self.taskInfo = taskInfo
    }
    
    //MARK:- Action
    
    func toolBarPressed(button: UIButton){
        self.createTaskToolBarView.backgroundColor = UIColor.groupTableViewBackground
        if !self.isTagsTrayShowing {
            UIView.animate(withDuration: 0.4, delay: 0.01, options: .allowAnimatedContent, animations: {
                self.createTaskToolBarView.alpha = 0
            }, completion: { (success: Bool) in
                self.createTaskToolBarView.isHidden = true
            })
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
                button.superview?.backgroundColor = UIColor.clear
            } else {
                button.superview?.backgroundColor = UIColor(hexString: "#666666ff")
            }
        }
        self.performSegue(withIdentifier: "addTaskInfoSegue", sender: self)
    }
    
    @IBAction func dismissCreateTask(barButton: UIBarButtonItem){
        self.createTaskToolBarView.isHidden = true
        self.createTaskToolBarView.alpha = 0
        self.textView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    func postTask(barButton: UIBarButtonItem){
        if self.selectedTaskTypeButton != nil {
            self.postSpinner(isSpinning: true)
            TaskService.createTask(taskDict: self.buildTaskPostObject()
            ) { (task: Task?, error: Error?) in
                self.postSpinner(isSpinning: false)
                if error != nil {
                    let alert = UIAlertController(title: "Error",
                                                  message: "Please try again later.",
                                                  preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                        if self.isTagsTrayShowing{
                            self.createTaskToolBarView.isHidden = true
                        }
                    })
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if self.taskInfo!.contacts.count > 0 {
                        TaskService.addContactsToTask(taskID: task!.id!,
                                                      contactDicts: self.buildContactsPostObject(), completion: { (task: Task?, error: Error?) in
                                                        self.notifyListeners(task: task!)
                                                        self.dismiss(animated: true)
                        })
                    }else{
                        self.notifyListeners(task: task!)
                        self.dismiss(animated: true)
                    }
                }
            }
        }else{
            MessagingClient.sharedInstance.postMessage(message: self.textView.text)
            self.dismiss(animated: true, completion: nil)
        }
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
    
    fileprivate func postSpinner(isSpinning: Bool){
        if isSpinning {
            self.cancelBarButton.isEnabled = false
            self.textView.isUserInteractionEnabled = false
            self.navigationItem.rightBarButtonItem = self.barButtonSpinner
            self.createTaskToolBarView.isUserInteractionEnabled = false
            self.spinner.startAnimating()
        }else{
            self.cancelBarButton.isEnabled = true
            self.textView.isUserInteractionEnabled = true
            self.spinner.stopAnimating()
            self.navigationItem.rightBarButtonItem = self.postBarButton
            self.createTaskToolBarView.isUserInteractionEnabled = true
            self.spinner.stopAnimating()
        }
    }
    
    fileprivate func buildTaskPostObject() -> [String:Any]{
        var taskDictionary: [String:Any] = ["client_id": Client.currentUserID! as Any,
                                            "text": self.textView.text as Any]
        if let taskTypeButton = self.selectedTaskTypeButton {
            taskDictionary["task_type"] = taskTypeButton.taskTypePermalink! as Any
        }
        if let taskInfo = self.taskInfo {
            if let loc = taskInfo.location{
                taskDictionary["location"] = "(\(loc.placemark.coordinate.latitude),\(loc.placemark.coordinate.longitude))" as Any
            }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let startsDate = self.taskInfo?.startDate {
                taskDictionary["start_on"] = formatter.string(from: startsDate)
            }
            if let endsDate = self.taskInfo?.endDate {
                taskDictionary["end_on"] = formatter.string(from: endsDate)
            }
        }
        return taskDictionary
    }
    

    fileprivate func buildContactsPostObject() -> [String:Any]{
        var contacts = [[String:Any]]()
        for contact in taskInfo!.contacts {
            contacts.append(contact.serialize(clientID: Client.currentUserID!) as [String : Any])
        }
        return ["contacts":contacts as Any]
    }
    
    fileprivate func notifyListeners(task: Task){
        MessagingClient.sharedInstance.postTaskMessage(task: task)
        CalendarService.sharedInstance.createEvent(task: task)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "newTaskCreated"),
                                        object: task as Any)
    }
    
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
        self.textView.resignFirstResponder()
        // Show tray
        UIView.animate(withDuration: 0.5, animations: {
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
        UIView.animate(withDuration: 0.4, animations: {
            let y = (self.view.frame.size.height + 1)
            self.tagsTrayView.frame = CGRect(x: 0,
                                             y: y,
                                             width: self.tagsTrayView.frame.size.width,
                                             height: self.tagsTrayView.frame.size.height)
            self.tagsTrayViewOriginCenter = self.tagsTrayView.center
            self.createTaskToolBarView.alpha = 1
        }) { (success: Bool) in
            self.tagsTrayView.removeFromSuperview()
            self.isTagsTrayShowing = false
        }

    }
    
    fileprivate func setup(){
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.spinner.hidesWhenStopped = true
        self.barButtonSpinner = UIBarButtonItem(customView: self.spinner)
        self.postBarButton = UIBarButtonItem(title: "Post",
                                             style: .done,
                                             target: self,
                                             action: #selector(postTask(barButton:)))
        self.postBarButton.tintColor = UIColor(hexString: "#EBEBF1ff")
        self.navigationItem.rightBarButtonItem = self.postBarButton
        self.tagsTrayView = UINib(nibName: "TagsTrayView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! TagsTrayView
        self.tagsTrayView.frame.size.width = self.view.frame.size.width
        self.textView.frame.size.height = 0
        self.textView.placeholder = "Enter task"
        if self.textView.text.characters.count == 0 {
            self.postBarButton.isEnabled = false
        }else{
            self.postBarButton.isEnabled = true
        }
        self.taskTypeButtonsBuilder()
        self.textView.becomeFirstResponder()
    }
    
    fileprivate func toolBarBuilder() -> UIView {
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
        if segue.identifier == "addTaskInfoSegue" {
            let nav = segue.destination as! UINavigationController
            let vc = nav.viewControllers.first as! AddTaskInfoTableViewController
            vc.taskDataDelegate = self
            vc.taskTypePermalink = self.selectedTaskTypeButton?.taskTypePermalink
        }
    }

}
