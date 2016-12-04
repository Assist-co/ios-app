//
//  MeetAssistantViewController.swift
//  Assist
//
//  Created by Bryce Aebi on 11/13/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class MeetAssistantViewController: UIViewController {
    @IBOutlet weak var letsGoButton: UIButton!

    @IBOutlet weak var assistantImageView: UIImageView!
    @IBAction func buttonPress(_ sender: AnyObject) {
        let slidingViewController = UIStoryboard(name: "Sliding", bundle: nil).instantiateViewController(withIdentifier: "SlidingViewController")
        
        
        if let svc = slidingViewController as? SlidingViewController {
            let homeNavigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController")
            if let homeController = homeNavigationController.childViewControllers.first as? SlidableViewController {
                homeController.slidingViewController = svc
            }
            
            let taskManagementNavigationController = UIStoryboard(name: "TaskManager", bundle: nil).instantiateViewController(withIdentifier: "TaskManagerNavigationController")
            if let taskController = taskManagementNavigationController.childViewControllers.first as? SlidableViewController {
                taskController.slidingViewController = svc
            }
            let calendarNavigationController = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarNavigationController")
            if let calendarController = calendarNavigationController.childViewControllers.first as? SlidableViewController {
                calendarController.slidingViewController = svc
            }

            svc.mainViewController = homeNavigationController
            svc.leftViewController = taskManagementNavigationController
            svc.rightViewController = calendarNavigationController
        }
        
        present(slidingViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assistantImageView.layer.cornerRadius = 20
        assistantImageView.clipsToBounds = true
        letsGoButton.layer.cornerRadius = 4
        letsGoButton.clipsToBounds = true
        letsGoButton.backgroundColor = UIColor(hexString: "#256e93ff")
        
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(hexString: "#181A1Dff")
        navigationController!.navigationBar.isTranslucent = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
