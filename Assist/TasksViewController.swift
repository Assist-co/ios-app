//
//  TasksViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import MBProgressHUD

enum TaskListType{
    case queued
    case completed
}

struct TasksData {
    var queuedTasks: [Task]?
    var completedTasks:[Task]?
}

class TasksViewController: UIViewController, UIScrollViewDelegate, TaskListViewControllerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    private var queuedTaskViewController: TaskListTableViewController!
    private var completedTaskViewController: TaskListTableViewController!
    private var currentTaskListType: TaskListType = .queued {
        didSet{
            switch currentTaskListType {
            case .completed:
                self.queuedTaskViewController.isShowing = false
                self.completedTaskViewController.isShowing = true
            default:
                self.queuedTaskViewController.isShowing = true
                self.completedTaskViewController.isShowing = false
            }
        }
    }
    private var tasksData: TasksData = TasksData()
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.loadData()
    }
    
    //MARK:- Action
    
    @IBAction func filterSelected(_ sender: UIButton) {
        if sender.tag == 100 {
            if self.currentTaskListType != .queued {
                UIView.transition(with: self.view, duration: 0.23, options: .transitionFlipFromRight, animations: {
                    // remove completed task list
                    self.completedTaskViewController.removeFromParentViewController()
                    self.completedTaskViewController.tableView.removeFromSuperview()
                    self.didMove(toParentViewController: self.completedTaskViewController)
                    // add queued task list
                    self.addChildViewController(self.queuedTaskViewController)
                    self.view.insertSubview(self.queuedTaskViewController.tableView, at: 0)
                    self.didMove(toParentViewController: self.queuedTaskViewController)
                }, completion: { (sucess: Bool) in
                    
                })
                self.currentTaskListType = .queued
            }
        }else{
            if self.currentTaskListType != .completed {
                UIView.transition(with: self.view, duration: 0.23, options: .transitionFlipFromLeft, animations: {
                    // remove queued task list
                    self.queuedTaskViewController.removeFromParentViewController()
                    self.queuedTaskViewController.tableView.removeFromSuperview()
                    self.didMove(toParentViewController: self.queuedTaskViewController)
                    // add completed task list
                    self.addChildViewController(self.completedTaskViewController)
                    self.view.insertSubview(self.completedTaskViewController.tableView, at: 0)
                    self.didMove(toParentViewController: self.completedTaskViewController)
                }, completion: { (success: Bool) in
                    
                })
                self.currentTaskListType = .completed
            }
        }
    }
    
    @IBAction func popViewController(_ sender: UIBarButtonItem) {
        _ = self.navigationController?.popViewController(animated: true)
    }

    //MARK:- TaskListViewControllerDelegate
    
    internal func refreshTasksLists(completion: @escaping (Bool, Error?) -> ()
        ) {
        TaskService.fetchTasksForClient { (tasks: [Task]?, error: Error?) in
            if error == nil{
                let (queued, completed) = self.filterTasks(tasks: tasks!)
                self.tasksData.queuedTasks = queued
                self.tasksData.completedTasks = completed
                self.reloadTaskLists()
                completion(true, nil)
            }else{
                completion(false, error)
            }
        }
    }
    
    //MARK:- Utils
    
    fileprivate func reloadTaskLists(){
        self.queuedTaskViewController.tasks = self.tasksData.queuedTasks
        self.queuedTaskViewController.tableView.reloadData()
        self.queuedTaskViewController.tableView.layoutIfNeeded()
        self.completedTaskViewController.tasks = self.tasksData.completedTasks
        self.completedTaskViewController.tableView.reloadData()
        self.completedTaskViewController.tableView.layoutIfNeeded()
    }
    
    fileprivate func loadData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TaskService.fetchTasksForClient { (tasks: [Task]?, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil{
                let (queued, completed) = self.filterTasks(tasks: tasks!)
                self.tasksData.queuedTasks = queued
                self.tasksData.completedTasks = completed
                self.reloadTaskLists()
            }else{
                #if DEBUG
                    // Only if server not running in development
                    let queued = [Task(dictionary: [:]),Task(dictionary: [:]),Task(dictionary: [:])]
                    let completed = [Task(dictionary: [:]),Task(dictionary: [:]),Task(dictionary: [:])]
                    self.tasksData.queuedTasks = queued
                    self.tasksData.completedTasks = completed
                    self.reloadTaskLists()
                #endif
            }
        }
    }
    
    fileprivate func filterTasks(tasks: [Task]) -> ([Task],[Task]){
        var queued: [Task] = []
        var completed: [Task] = []
        for task in tasks{
            if let state = task.state {
                switch state {
                case .ready:
                    queued.append(task)
                case .completed:
                    completed.append(task)
                default:
                    queued.append(task)
                }
            }
        }
        return (queued, completed)
    }
    
    fileprivate func setup(){
        let storyboard = UIStoryboard(name: "TaskManager", bundle: nil)
        self.queuedTaskViewController = storyboard.instantiateViewController(withIdentifier: "taskListTableViewController") as! TaskListTableViewController
        self.completedTaskViewController = storyboard.instantiateViewController(withIdentifier: "taskListTableViewController") as! TaskListTableViewController
        self.queuedTaskViewController.taskListDelegate = self
        self.completedTaskViewController.taskListDelegate = self
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        self.queuedTaskViewController.tableView.frame = CGRect(x: 0, y: 50, width: width, height: height - 50)
        self.completedTaskViewController.tableView.frame = CGRect(x: 0, y: 50, width: width, height: height - 50)
        self.addChildViewController(self.queuedTaskViewController)
        self.view .insertSubview(self.queuedTaskViewController.tableView, at: 0)
        self.didMove(toParentViewController: self.queuedTaskViewController)
        
//        self.scrollView!.contentSize = CGSize(width: 2*width, height: 0)
//        let viewControllers = [self.queuedTaskViewController, self.completedTaskViewController]
//        var idx = 0
//        for viewController in viewControllers {
//            self.addChildViewController(viewController!);
//            let originX = CGFloat(idx) * width;
//            viewController!.tableView.frame = CGRect(x: originX, y: 0, width: width, height: height);
//            scrollView!.addSubview(viewController!.view)
//            viewController!.didMove(toParentViewController: self)
//            idx += 1
//        }
    }
}
