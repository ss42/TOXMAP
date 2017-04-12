//
//  AppDelegate.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)

import UIKit
import GoogleMaps
import SystemConfiguration

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var facility : Facility?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBtZODW1gC347mSYRvM8C41gotelIpfvxA")
//("AIzaSyDUpHZhqjIw9Sf07yO78l8vS4Xz5BQHcAo")
        if(UserDefaults.standard.bool(forKey: "firstTime"))
        {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
        }
        else
        {
            // This is the first launch ever
            UserDefaults.standard.set(true, forKey: "firstTime")
            UserDefaults.standard.synchronize()
        }

        UINavigationBar.appearance().barTintColor = Constants.colors.secondaryColor
        UINavigationBar.appearance().tintColor = Constants.colors.mainColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:Constants.colors.mainColor]

        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                             sourceApplication: String?,
                             annotation: Any) -> Bool {
      
        return true
    }

}

