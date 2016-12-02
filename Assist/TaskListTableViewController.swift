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
    var tasksByDay: [(Date, [Task])]?
    internal var isShowing: Bool?
    private var selectedTask: Task?
    weak var taskListDelegate: TaskListViewControllerDelegate?

    @IBOutlet var taskTable: UITableView!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        self.taskTable.layoutMargins = UIEdgeInsets.zero
        self.taskTable.separatorInset = UIEdgeInsets.zero
        self.taskTable.separatorColor = UIColor(hexString: "#444444ff")
    }
    
    //MARK:- TableView Datasource
    
     public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let tasksByDay = tasksByDay {
            
            let date = tasksByDay[section].0
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return "Today"
            } else if calendar.isDateInYesterday(date) {
                return "Yesterday"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.long
                return dateFormatter.string(from: tasksByDay[section].0)
            }
        } else {
            return ""
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    public override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        if let tasksByDay = tasksByDay {
            return tasksByDay.count
        } else {
            return 0
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tasksByDay = tasksByDay {
            return tasksByDay[section].1.count
        } else {
            return 0
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        // remove bottom extra 20px space.
        return CGFloat.leastNormalMagnitude
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as! TaskTableViewCell

        cell.layoutMargins = UIEdgeInsets.zero
        let task = self.tasksByDay?[indexPath.section].1[indexPath.row]
        cell.taskTextLabel.text = task?.type?.display
        let cellType = task?.type?.display
        if cellType == "Reminder" {
            cell.taskIcon.image = #imageLiteral(resourceName: "clock")
            cell.taskIcon.backgroundColor = UIColor(hexString: "#FFCA28ff")
        } else if cellType == "Call" {
            cell.taskIcon.image = #imageLiteral(resourceName: "phone_small")
            cell.taskIcon.backgroundColor = UIColor(hexString: "#ED5E5Eff")
        } else if cellType == "Schedule" {
            cell.taskIcon.image = #imageLiteral(resourceName: "calendar_small")
            cell.taskIcon.backgroundColor = UIColor(hexString: "#66BB6Aff")
        } else if cellType == "Other" {
            cell.taskIcon.image = #imageLiteral(resourceName: "other")
            cell.taskIcon.backgroundColor = UIColor(hexString: "#AC7339ff")
        } else if cellType == "Inquiry" {
            cell.taskIcon.image = #imageLiteral(resourceName: "magnifying_glass")
            cell.taskIcon.backgroundColor = UIColor(hexString: "#7E57C2ff")
        } else if cellType == "Email" {
            cell.taskIcon.image = #imageLiteral(resourceName: "mail")
            cell.taskIcon.backgroundColor = UIColor(hexString: "#42A5F5ff")
        }
        
        cell.taskDescriptionLabel.text = task?.text
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        cell.createdOnLabel.text = formatter.string(from: (task?.createdOn)!)
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.addTarget(self, action: #selector(TaskListTableViewController.taskLongPressGesture(_:)))
        cell.addGestureRecognizer(longPressGesture)
        cell.tag = indexPath.row
        return cell
    }
    
    //MARK:- TableView Delegate
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.selectedTask = self.tasks[indexPath.row]
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
