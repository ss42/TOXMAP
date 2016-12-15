//
//  Facility.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import Foundation
import GoogleMaps


class Facility {
    let number: NSString?
   // let id: NSNumber?
    let name: NSString?
    let street: NSString?
    let city: NSString?
    let state: NSString?
    let zipCode: NSString?
    //let county: NSString?
   // let fips: NSNumber?
    let latitude: NSNumber?
    let longitude: NSNumber?
    let total: NSNumber?
    let current: NSNumber?
   // let chemical: [String]?
    /*
    init(number: NSNumber, id: NSNumber, name: NSString, street: NSString, city: NSString, county: NSString, state: NSString, zipCode: NSNumber, fips: NSNumber, latitude: NSNumber, longitude: NSNumber, total: NSNumber, current: NSNumber, chemical: [String]) {
        
        self.number = number
        self.name = name
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.county = county
        self.fips = zipCode
        self.latitude = latitude
        self.longitude = longitude
        self.total = total
        self.current = current
        self.id = id
        self.chemical = chemical
    }*/
    init(number: NSString, name: NSString, street: NSString, city: NSString, state: NSString, zipCode: NSString, latitude: NSNumber, longitude: NSNumber, total: NSNumber, current: NSNumber) {
        
        self.number = number
        self.name = name
        self.street = street
        self.city = city
        self.state = state
        self.zipCode = zipCode
       //self.county = county
        
        self.latitude = latitude
        self.longitude = longitude
        self.total = total
        self.current = current
        //self.id = id
        //self.chemical = chemical
    }
    func address()-> String{
        let fullAddress = String(describing: self.street!) + ", " + String(describing: self.city!) + ", " + String(describing: self.state!) + ", " + String(describing: self.zipCode!)
        return fullAddress
    }
  
}
