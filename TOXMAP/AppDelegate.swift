//
//  AppDelegate.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

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
        
        
        //printFonts()
        return true
    }

    func application(_ application: UIApplication,
                     open url: URL,
                             sourceApplication: String?,
                             annotation: Any) -> Bool {
      
        return true
    }
    
    
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }

    


}

