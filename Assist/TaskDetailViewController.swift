//
//  TaskDetailViewController.swift
//  Assist
//
//  Created by christopher ketant on 11/27/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import MapKit

class TaskDetailViewController: UIViewController, MKMapViewDelegate {
    public var task: Task?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var taskIcon: UIImageView!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var taskDescription: UILabel!
    @IBOutlet weak var taskType: UILabel!

    var delegate: TaskListTableViewController?
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.styleView()
        self.populateOutlets()
        
        if task?.type?.permalink == "schedule" {
            let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
            let region =
            MKCoordinateRegionMakeWithDistance(
            initialLocation.coordinate, 2000, 2000)
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude)
            mapView.addAnnotation(annotation)
            mapView.setRegion(region, animated: true)
            mapView.layer.cornerRadius = 4
            mapView.clipsToBounds = true
            mapView.isHidden = false
        } else {
            mapView.isHidden = true
        }
    }
    
    //MARK:- IB Outlet Methods
    
    @IBAction func onBackTap(_ sender: AnyObject) {
        self.dismiss(animated: true) { 
            
        }
    }
    
    @IBAction func onCancelTaskTap(_ sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Are you sure you want to delete this task?", message: "This cannot be undone", preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Delete Task", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            TaskService.deleteTask(taskID: self.task!.id!, completion: { (sucess: Bool, error: Error?) in
                DispatchQueue.main.async {
                    if error == nil{
                        
                    }else{
                        
                    }
                }
            })
            self.dismiss(animated: true, completion: { 
                self.delegate?.refreshTasks()
            })
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    private func populateOutlets() {
        taskDescription.text = task?.text
        taskType.text = task?.type?.display
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        if let createdOn = task?.createdOn {
            createdOnLabel.text = formatter.string(from: createdOn)
        }
        
        let cellType = task?.type?.permalink
        if cellType == "reminder" {
            taskIcon.image = #imageLiteral(resourceName: "clock")
            taskIcon.backgroundColor = UIColor(hexString: "#FFCA28ff")
        } else if cellType == "call" {
            taskIcon.image = #imageLiteral(resourceName: "phone_small")
            taskIcon.backgroundColor = UIColor(hexString: "#ED5E5Eff")
        } else if cellType == "schedule" {
            taskIcon.image = #imageLiteral(resourceName: "calendar_small")
            taskIcon.backgroundColor = UIColor(hexString: "#66BB6Aff")
        } else if cellType == "other" {
            taskIcon.image = #imageLiteral(resourceName: "other")
            taskIcon.backgroundColor = UIColor(hexString: "#AC7339ff")
        } else if cellType == "inquiry" {
            taskIcon.image = #imageLiteral(resourceName: "magnifying_glass")
            taskIcon.backgroundColor = UIColor(hexString: "#7E57C2ff")
        } else if cellType == "email" {
            taskIcon.image = #imageLiteral(resourceName: "mail")
            taskIcon.backgroundColor = UIColor(hexString: "#42A5F5ff")
        }
    }
    
    private func styleView() {
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#181A1Dff")
        navigationController!.navigationBar.isTranslucent = false
        taskIcon.layer.cornerRadius = 6
        taskIcon.clipsToBounds = true
    }

}
