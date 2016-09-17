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
    let number: String?
    let id: String?
    let name: String?
    let street: String?
    let city: String?
    let state: String?
    let zipCode: Int?
    let county: String?
    let fips: Int?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let total: Float?
    let current: String?
    let chemical: [Chemical]?
    
    init(number: String, id: String, name: String, street: String, city: String, county: String, state: String, zipCode: Int, fips: Int, latitude: CLLocationDegrees, longitude: CLLocationDegrees, total: Float, current: String, chemical: [Chemical]) {
        
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
