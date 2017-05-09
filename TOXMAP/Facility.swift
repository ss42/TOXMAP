//
//  Facility.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)


import Foundation
import GoogleMaps
import ArcGIS


struct Facility {
    let number: NSString?
    let id: NSString?
    let name: String? 
    let street: NSString?
    let city: NSString?
    let state: NSString?
    let zipCode: NSString?
    let latitude: NSNumber?
    var longitude: NSNumber?
    let total:  Int?
    let current: Int?
    var chemical: Chemical?
    
    static var sharedInstance = [Facility]()
    static var searchInstance = [Facility]()
    private var featureTable:AGSServiceFeatureTable!

    //Use this if using chemicalSearch URL
    init(facility: AGSFeature){
        
        if let nm = facility.attributes["FNM"] as? String{
            self.name = nm.capitalized
            print(self.name!)
        }else{
            self.name = "No Name Provided"
        }
        if let num = facility.attributes["FACN"] as? NSString{
            self.number = num
        }else{
            self.number = "No Facility Number Provided"
        }
        if let stt = facility.attributes["FAD"] as? NSString{
            self.street = stt.capitalized as NSString
        }else{
            self.street = "No Street  Provided"
        }
        if let cty = facility.attributes["FCTY"] as? NSString{
            self.city = cty.capitalized as NSString
        }else{
            self.city = "No City Provided"
        }
        if let sta = facility.attributes["FST"] as? NSString{
            self.state = sta
        }else{
            self.state = "No State  Provided"
        }
        if let zip = facility.attributes["FZIP"] as? NSString{
            self.zipCode = zip
        }else{
            self.zipCode = "No Street  Provided"
        }
        if let fid = facility.attributes["FRSID"] as? NSString{
            self.id = fid
        }else{
            self.id = "No City Provided"
        }
        if let lng = facility.attributes["LONGD"] as? NSNumber{
            self.longitude = lng
        }else{
            self.longitude = 0
        }
        if let lat = facility.attributes["LATD"] as? NSNumber{
            self.latitude = lat
        }else{
            self.latitude = 0
        }
        if let totalRelease = facility.attributes["TOTALERELT"] as? Int{
            self.total = totalRelease
        }else{
            self.total = 0
        }
        if let currentRelease = facility.attributes["TOT_CURRENT"] as? Int{
            self.current = currentRelease
        }else{
            self.current = 0
        }
        Chemical.shared.chemicalAmount = facility.attributes[Chemical.shared.alias!] as? Int
        self.chemical = Chemical.shared
    }
    
    //Use this if using Facility URL
    init(facility1: AGSFeature){
        if let nm = facility1.attributes["fnm"] as? String{
            self.name = nm.capitalized
        }else{
            self.name = "No Name Provided"
        }
        if let num = facility1.attributes["facn"] as? NSString{
            self.number = num.capitalized as NSString
        }else{
            self.number = "No Facility Number Provided"
        }
        if let stt = facility1.attributes["fad"] as? NSString{
            self.street = stt.capitalized as NSString
        }else{
            self.street = "No Street  Provided"
        }
        if let cty = facility1.attributes["fcty"] as? NSString{
            self.city = cty.capitalized as NSString
        }else{
            self.city = "No City Provided"
        }
        if let sta = facility1.attributes["fst"] as? NSString{
            self.state = sta
        }else{
            self.state = "No State  Provided"
        }
        if let zip = facility1.attributes["fzip"] as? NSString{
            self.zipCode = zip
        }else{
            self.zipCode = "No Street  Provided"
        }
        if let fid = facility1.attributes["frsid"] as? NSString{
            self.id = fid
        }else{
            self.id = "No City Provided"
        }
        if let lng = facility1.attributes["lond"] as? NSNumber{
            self.longitude = lng
        }else{
            self.longitude = 0
        }
        if let lat = facility1.attributes["latd"] as? NSNumber{
            self.latitude = lat
        }else{
            self.latitude = 0
        }
        if let totalRelease = facility1.attributes["totalerelt"] as? Int{
            self.total = totalRelease
        }else{
            self.total = 0
        }
        if let currentRelease = facility1.attributes["tot_current"] as? Int{
            self.current = currentRelease
        }else{
            self.current = 0
        }
        Chemical.shared.chemicalAmount = facility1.attributes[Chemical.shared.alias!] as? Int
        self.chemical = Chemical.shared

    }

    init(number: NSString, name: String, street: NSString, city: NSString, state: NSString, zipCode: NSString, latitude: NSNumber, longitude: NSNumber, total: Int, current: Int, id: NSString, chemical: Chemical) {
        
        self.number = number
        self.name = name.capitalized
        self.street = street.capitalized as NSString?
        self.city = city.capitalized as NSString?
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
        self.total = total
        self.current = current
        self.id = id
        self.chemical = chemical
    }
    
    init(number: NSString, name: String, street: NSString, city: NSString, state: NSString, zipCode: NSString, latitude: NSNumber, longitude: NSNumber, total: Int, current: Int, id: NSString) {
        
        self.number = number
        self.name = name.capitalized
        self.street = street.capitalized as NSString?
        self.city = city.capitalized as NSString?
        self.state = state
        self.zipCode = zipCode
        self.latitude = latitude
        self.longitude = longitude
        self.total = total
        self.current = current
        self.id = id
    }
    

    func address()-> String{
        let fullAddress = String(describing: self.street!) + ", " + String(describing: self.city!) + ", " + String(describing: self.state!) + ", " + String(describing: self.zipCode!)
        return fullAddress
    }
  
}
