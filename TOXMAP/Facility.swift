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
    let id: NSString?
    let name: String? //NSString?
    let street: NSString?
    let city: NSString?
    let state: NSString?
    let zipCode: NSString?
    let latitude: NSNumber?
    let longitude: NSNumber?
    let total:  Int?
    let current: Int?
    var chemical: [String: String]?
    
    static var sharedInstance = [Facility]()
    static var searchInstance = [Facility]()

    init(number: NSString, name: String, street: NSString, city: NSString, state: NSString, zipCode: NSString, latitude: NSNumber, longitude: NSNumber, total: Int, current: Int, id: NSString, chemical: [String: String]) {
        
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
extension Int{
    func addFormatting(number: Int)-> String{
        let num = number as NSNumber
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        let formated = fmt.string(from: num)
        return formated!
    }
}
