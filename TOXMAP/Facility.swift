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
    let number: NSNumber?
    let id: NSNumber?
    let name: NSString?
    let street: NSString?
    let city: NSString?
    let state: NSString?
    let zipCode: NSNumber?
    let county: NSString?
    let fips: NSNumber?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let total: NSNumber?
    let current: NSNumber?
    let chemical: [Chemical]?
    
    init(number: NSNumber, id: NSNumber, name: NSString, street: NSString, city: NSString, county: NSString, state: NSString, zipCode: NSNumber, fips: NSNumber, latitude: CLLocationDegrees, longitude: CLLocationDegrees, total: NSNumber, current: NSNumber, chemical: [Chemical]) {
        
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
    }
    
}
