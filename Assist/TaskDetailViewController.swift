//
//  TaskDetailViewController.swift
//  Assist
//
//  Created by christopher ketant on 11/27/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    public var task: Task?
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    //MARK:- UITableViewDatasource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskDetailCell", for: indexPath) as! TaskDetailTableViewCell
        cell.taskTextLabel.text = self.task?.text
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        if let createdOn = self.task?.createdOn {
            cell.createdOnLabel.text = formatter.string(from: createdOn)
        }
        return cell
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 180
        self.tableView.reloadData()
    }

}
