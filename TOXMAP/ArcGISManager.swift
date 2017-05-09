//
//  ArcGISManager.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 5/8/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit
import ArcGIS
import SVProgressHUD
import SystemConfiguration

enum ArcGISURLType: String {
    case facilityURL = "https://toxmap.nlm.nih.gov/arcgis/rest/services/toxmap5/toc/MapServer/6"
    case chemicalURL = "https://toxmap.nlm.nih.gov/arcgis/rest/services/toxmap5/vsfs_chemtable/MapServer/0"
}

class ArcGISManager: UIViewController {
    
     fileprivate var featureTable:AGSServiceFeatureTable!

    
    
    /**
     Query chemicals to the URL
     
     - parameter bar: wheretext - The actual input text to search
     
     - returns: completion handler and fills Facility  Search Shared instance
     */
    func query(whereString: String, url: String, chemicalSearch: Bool, completion: @escaping (_ result: String) -> Void) {
        featureTable = AGSServiceFeatureTable(url: URL(string: url)!)
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        Facility.sharedInstance.removeAll()
        SVProgressHUD.show(withStatus: "Loading")
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = whereString
        let manager = ArcGISManager()
        if !manager.isInternetAvailable(){
            SVProgressHUD.dismiss()
            UIApplication.shared.endIgnoringInteractionEvents()
            showError("No Internet Connection", message: "Please try after the internet connection is back.")
        }
        self.featureTable.populateFromService(with: queryParams, clearCache: true, outFields: ["*"]) { result, error in
            if error != nil {
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.showError("Could not perform search.", message: "Please try again later.")
            }
            else {
                for facility in (result?.featureEnumerator().allObjects)!{
                    if chemicalSearch{
                        let fac = Facility(facility: facility)
                        Facility.sharedInstance.append(fac)

                    }
                    else{
                        let fac = Facility(facility1: facility)
                        Facility.sharedInstance.append(fac)

                    }
                }
                UIApplication.shared.endIgnoringInteractionEvents()
                SVProgressHUD.dismiss()

                completion("done with query")
            }
        }
    }
    
    /**
     Checks internet connection of the app
     
     - parameter:
     
     - returns: Bool
     */
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
