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
    var queuedTasksByDate: [(Date, [Task])]?
    var completedTasksByDate: [(Date, [Task])]?
}

class TasksViewController: UIViewController, UIScrollViewDelegate, TaskListViewControllerDelegate {
    @IBOutlet weak var emptyStateLabel: UILabel!
    @IBOutlet weak var taskListContainer: UIView!
    @IBOutlet weak var queuedButton: UIButton!
    @IBOutlet weak var completedButton: UIButton!
    
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
                self.completedButton.backgroundColor = UIColor(hexString: "#EFEFF4ff")
                self.queuedButton.backgroundColor = UIColor(hexString: "#256E93ff")
                self.completedButton.setTitleColor(UIColor.darkGray, for: .normal)
                self.queuedButton.setTitleColor(UIColor.white, for: .normal)
                
                UIView.transition(with: self.taskListContainer, duration: 0.5, options: .transitionFlipFromRight, animations: {

                    // remove completed task list
                    self.completedTaskViewController.removeFromParentViewController()
                    self.completedTaskViewController.tableView.removeFromSuperview()
                    self.didMove(toParentViewController: self.completedTaskViewController)
                    // add queued task list
                    self.addChildViewController(self.queuedTaskViewController)
                    self.taskListContainer.insertSubview(self.queuedTaskViewController.tableView, at: 0)
                    self.didMove(toParentViewController: self.queuedTaskViewController)
                    // check for empty state
                    if self.queuedTaskViewController.tasks.isEmpty {
                        print("queued is empty")
                        self.queuedTaskViewController.tableView.isHidden = true
                        //self.emptyStateLabel.isHidden = false
                    }else{
                        print("queued is full")
                        self.queuedTaskViewController.tableView.isHidden = false
                        //self.emptyStateLabel.isHidden = true
                    }
                }, completion: { (sucess: Bool) in

                })
                self.currentTaskListType = .queued
            }
        }else{
            self.completedButton.backgroundColor = UIColor(hexString: "#256E93ff")
            self.queuedButton.backgroundColor = UIColor(hexString: "#EFEFF4ff")
            self.queuedButton.setTitleColor(UIColor.darkGray, for: .normal)
            self.completedButton.setTitleColor(UIColor.white, for: .normal)

            if self.currentTaskListType != .completed {
                UIView.transition(with: self.taskListContainer, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                    // remove queued task list
                    self.queuedTaskViewController.removeFromParentViewController()
                    self.queuedTaskViewController.tableView.removeFromSuperview()
                    self.didMove(toParentViewController: self.queuedTaskViewController)
                    // add completed task list
                    self.addChildViewController(self.completedTaskViewController)
                    self.taskListContainer.insertSubview(self.completedTaskViewController.tableView, at: 0)
                    self.didMove(toParentViewController: self.completedTaskViewController)
                    // check for empty state
                    if self.completedTaskViewController.tasks.isEmpty {
                        self.completedTaskViewController.tableView.isHidden = true
                        //self.emptyStateLabel.isHidden = false
                    }else{
                        self.completedTaskViewController.tableView.isHidden = false
                        //self.emptyStateLabel.isHidden = true
                    }
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
                
                let queuedTasksByDate = self.groupTasksByDate(inputTasks: queued)
                let completedTasksByDate = self.groupTasksByDate(inputTasks: completed)
                
                self.tasksData.queuedTasks = queued
                self.tasksData.completedTasks = completed
                self.tasksData.queuedTasksByDate = queuedTasksByDate
                self.tasksData.completedTasksByDate = completedTasksByDate
                
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
        self.queuedTaskViewController.tasksByDay = self.tasksData.queuedTasksByDate
        self.queuedTaskViewController.tableView.reloadData()
        self.queuedTaskViewController.tableView.layoutIfNeeded()
        self.completedTaskViewController.tasks = self.tasksData.completedTasks
        self.completedTaskViewController.tasksByDay = self.tasksData.completedTasksByDate
        self.completedTaskViewController.tableView.reloadData()
        self.completedTaskViewController.tableView.layoutIfNeeded()
    }
    
    private func groupTasksByDate(inputTasks: [Task]) -> [(Date,[Task])] {
        var tasksByDate: [(Date, [Task])] = []
        if inputTasks.count > 0 {
            var currDate: Date = inputTasks[0].createdOn!
            var tasks: [Task] = []
            for task in inputTasks {
                if Calendar.current.isDate(task.createdOn!, inSameDayAs: currDate) {
                    tasks.append(task)
                } else {
                    let tasksCopy = tasks
                    tasks = [task]
                    tasksByDate.append((currDate, tasksCopy))
                    currDate = task.createdOn!
                }
            }
            if tasks != [] {
                tasksByDate.append((currDate, tasks))
            }
        }
        return tasksByDate
    }
    
    fileprivate func loadData(){
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        TaskService.fetchTasksForClient { (tasks: [Task]?, error: Error?) in
            MBProgressHUD.hide(for: self.view, animated: true)
            if error == nil {
                let (queued, completed) = self.filterTasks(tasks: tasks!)

                let queuedTasksByDate = self.groupTasksByDate(inputTasks: queued)
                let completedTasksByDate = self.groupTasksByDate(inputTasks: completed)
                
                self.tasksData.queuedTasks = queued
                self.tasksData.completedTasks = completed
                self.tasksData.queuedTasksByDate = queuedTasksByDate
                self.tasksData.completedTasksByDate = completedTasksByDate
                
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

        let bounds = self.taskListContainer.bounds
        let width = bounds.size.width
        let height = bounds.size.height
        self.queuedTaskViewController.tableView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.completedTaskViewController.tableView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.addChildViewController(self.queuedTaskViewController)
        self.taskListContainer.insertSubview(self.queuedTaskViewController.tableView, at: 0)
        self.didMove(toParentViewController: self.queuedTaskViewController)
    }
}
