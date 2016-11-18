//
//  TaskListViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class TaskListTableViewController: UITableViewController {
    
    internal var tasks: [Task]! = []
    internal var isShowing: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as! TaskTableViewCell
        let task = self.tasks[indexPath.row]
        cell.taskTextLabel.text = task.text
        return cell
    }
    
    fileprivate func setup(){
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
    }

}
