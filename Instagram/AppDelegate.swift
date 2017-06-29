//
//  AppDelegate.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/26/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Parse.initialize(
            with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
                configuration.applicationId = "Instagram"
                configuration.clientKey = "helloinstagram"
                configuration.server = "https://sleepy-taiga-56600.herokuapp.com/parse"
            })
        )
        //User.registerSubclass()
        
        if PFUser.current() != nil {
            if let currentUser = PFUser.current() {
                print("Welcome back \(currentUser.username!) 😊")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeTabController = storyboard.instantiateViewController(withIdentifier: "HomeViewTabBarController") as! UITabBarController
                window?.rootViewController = homeTabController
            }
        }
        // Override point for customization after application launch.
        return true
    }

    
    func loggingOut() {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "loginViewController") as! UIViewController
                self.window?.rootViewController = loginViewController
                print("Logout successful")
            }
        }
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

