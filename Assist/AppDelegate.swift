//
//  AppDelegate.swift
//  Assist
//
//  Created by Bryce Aebi on 11/9/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "OnboardingFlow", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "OnboardingFlow")
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        // *************** Sample usage of API *************** \\
        
//        AuthService.signUpClient(
//        signUpDict: [
//            "email": "cketant@apple.com" as AnyObject, "password": "testing" as AnyObject, "first_name": "johnny" as AnyObject,
//            "last_name": "appleseed" as AnyObject, "phone": "+17182330403" as AnyObject, "profession": "engineer" as AnyObject,
//            "gender": "male" as AnyObject, "date_of_birth": "1991-04-25" as AnyObject]
//        ) {
//            (response: Dictionary<String, AnyObject>?, error: Error?) in
//            print(response!)
//        }
//        AuthService.loginClient(
//        email: "jappleseed@apple.com",
//        password: "testing") { (response: Dictionary<String, AnyObject>?, error: Error?) in
//            print(response!)
//        }
//        OptionService.fetchGenders { (genders: [Gender]?, error: Error?) in
//            print(genders!)
//        }
//        OptionService.fetchProfessions { (professions: [Profession]?, error: Error?) in
//            print(professions!)
//        }
//        OptionService.fetchAssistantTaskTypes { (types: [AssistantTaskType]?, error: Error?) in
//            print(types!)
//        }
//        ClientService.fetchClient(clientID: 2) { (client: Client?, error: Error?) in
//            print(client!)
//        }
//        TaskService.fetchTasksForClient(clientID: 2) { (tasks: [Task]?, error: Error?) in
//            print(tasks!)
//        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

