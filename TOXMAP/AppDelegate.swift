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
        GMSServices.provideAPIKey("AIzaSyANa3C4UDOdPvsYB8yZeYdl-3c8wTWPqwA")

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

