//
//  TaskListViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

protocol TaskListViewControllerDelegate: class {
    func refreshTasksLists(completion: @escaping (Bool, Error?) -> Void)
}

class TaskListTableViewController: UITableViewController {
    internal var tasks: [Task]! = []
    internal var isShowing: Bool?
    private var selectedTask: Task?
    weak var taskListDelegate: TaskListViewControllerDelegate?
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
    }
    
    //MARK:- TableView Datasource
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as! TaskTableViewCell
        let task = self.tasks[indexPath.row]
        cell.taskTextLabel.text = task.text
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        if let createdOn = task.createdOn {
            cell.createdOnLabel.text = formatter.string(from: createdOn)
        }
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(TaskListTableViewController.taskLongPressGesture(_:)))
        cell.addGestureRecognizer(longPressGesture)
        cell.tag = indexPath.row
        return cell
    }
    
    //MARK:- TableView Delegate
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTask = self.tasks[indexPath.row]
        self.performSegue(withIdentifier: "taskListToDetailSegue", sender: self)
    }
    
    //MARK:- Action
    
    @objc fileprivate func taskLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let cell = sender.view as! TaskTableViewCell
        let task: Task?  = self.tasks[cell.tag]
        let actionController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteTaskAction = UIAlertAction(title: "Delete Task", style: .destructive) { (action: UIAlertAction) in
            DispatchQueue.main.async { self.refreshControl?.beginRefreshing() }
            self.refreshControl?.beginRefreshing()
            TaskService.deleteTask(taskID: task!.id!, completion: { (sucess: Bool, error: Error?) in
                DispatchQueue.main.async {
                    if error == nil{
                        self.taskListDelegate?.refreshTasksLists(completion: { (sucess: Bool, error: Error?) in
                            self.refreshControl?.endRefreshing()
                        })
                    }else{
                    
                    }
                    
                }
            })
        }
        let muteTaskAction = UIAlertAction(title: "Mute Task", style: .default) { (action: UIAlertAction) in
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionController.addAction(deleteTaskAction)
        actionController.addAction(muteTaskAction)
        actionController.addAction(cancelAction)
        self.present(actionController, animated: true) {
            
        }
    }
    
    
    internal func refreshTasks(){
        self.taskListDelegate?.refreshTasksLists(completion: { (sucess: Bool, error: Error?) in
            if error == nil{
            
            }else{
            
            }
            self.refreshControl?.endRefreshing()
        })
    }
    
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(TaskListTableViewController.refreshTasks), for: UIControlEvents.valueChanged)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskListToDetailSegue" {
            let vc = segue.destination as! TaskDetailViewController
            vc.task = self.selectedTask!
        }
    }
}
