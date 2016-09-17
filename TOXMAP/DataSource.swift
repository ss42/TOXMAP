//
//  DataSource.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//
import UIKit

class DataSource
{
    // temporary local table of chemicals for testing purposes
    let chemicalTable: [String:String] =
    [ // key:value
        "Asbestos (friable)":"CHEM_1",
        "Benzene":"CHEM_2",
        "Chromium Compounds":"CHEM_3",
        "Ethylene Oxide":"CHEM_4",
        "Formaldehyde":"CHEM_5",
        "Lead":"CHEM_6",
        "Lead Compounds":"CHEM_7",
        "Mercury":"CHEM_8",
        "Mercury Compounds":"CHEM_9",
        "Nickel Compounds":"CHEM_10"
    ];
    let states: [String:String] =
    [
        "Alabama":"AL", "Alaska":"AK", "Arizona":"AZ", "Arkansas":"AR",
        "California":"CA", "Colorado":"CO", "Connecticut":"CT",
        "Delaware":"DE",
        "Florida":"FL",
        "Georgia":"GA",
        "Hawaii":"HI",
        "Idaho":"ID", "Illinois":"IL", "Indiana":"IN", "Iowa":"IA",
        "Kansas":"KS", "Kentucky":"KY",
        "Louisiana":"LA",
        "Maine":"ME","Maryland":"MD", "Massachusetts":"MA", "Michigan":"MI",
        "Minnesota":"MN", "Mississippi":"MS", "Missouri":"MO", "Montana":"MT",
        "Nebraska":"NE", "Nevada":"NV", "New Hampshire":"NH", "New Jersey":"NJ",
        "New Mexico":"NM", "New York":"NY", "North Carolina":"NC", "North Dakota":"ND",
        "Ohio":"OH", "Oklahoma":"OK", "Oregon":"OR",
        "Pennsylvania":"PA", "Rhode Island":"RI",
        "South Carolina":"SC", "South Dakota":"SD",
        "Tennessee":"TN", "Texas":"TX", "Utah":"UT",
        "Vermont":"VT", "Virginia":"VA",
        "Washington":"WA", "West Virginia":"WV", "Wisconsin":"WI", "Wyoming":"WY"
    ];
    
    let counties: [String] =
    [
        "county","county2"
    ];
    
//    
//    //var successfulSearches:!
//    var queryTask:AGSQueryTask!
//    var query:AGSQuery!
//    var featureSet:AGSFeatureSet!
    var chemical:String!
    var state:String!
    var county:String!
    let url = NSURL(string: "http://toxmap.nlm.nih.gov/arcgis/rest/services/toxmap5/vsfs_chemtable/MapServer/0")
    
    // globally accessable parameter specific to DataSource
    class var sharedManager: DataSource
    {
        struct Static {
            static let instance = DataSource()
        }
        return Static.instance
    }
}
