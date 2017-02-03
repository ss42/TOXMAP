//
//  Constants.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import Foundation
import UIKit


struct Constants {
    
    struct Segues {
        static let stateToFacility = "stateToFacilitiesSegue"
        static let browseFacilityToDetail = "browseToDetailSegue"
        static let showInMap = "detailToShowMapSegue"
        static let browseToState = "browseStateSegue"
        
    }
    struct CellIdentifier {
        static let chemicalCell = "chemicalCell"
        static let stateCell = "stateCell"
        static let browseCell = "browseCell"
        
    }
    struct colors {
        static let secondaryColor = UIColor(red: 27/255, green: 214/255, blue: 183/255, alpha: 1)
        static let mainColor = UIColor(red: 25/255, green: 29/255, blue: 67/255, alpha: 1)
    }
    
    struct chemicalList {
        //static let list = []
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
        ]
    }
    struct State {
        static let stateFullName = ["ALABAMA","ALASKA","ARIZONA","ARKANSAS","CALIFORNIA","COLORADO","CONNECTICUT","DELAWARE","FLORIDA","GEORGIA","HAWAII","IDAHO","ILLINOIS","INDIANA","IOWA","KANSAS","KENTUCKY","LOUISIANA","MAINE","MARYLAND","MASSACHUSETTS","MICHIGAN","MINNESOTA","MISSISSIPPI","MISSOURI","MONTANA","NEBRASKA","NEVADA","NEW HAMPSHIRE","NEW JERSEY","NEW MEXICO","NEW YORK","NORTH CAROLINA","NORTH DAKOTA","OHIO","OKLAHOMA","OREGON","PENNSYLVANIA","RHODE ISLAND","SOUTH CAROLINA","SOUTH DAKOTA","TENNESSEE","TEXAS","UTAH","VERMONT","VIRGINIA","WASHINGTON","WEST VIRGINIA","WISCONSIN","WYOMING"]
        static let stateAbbreviation = ["AK","AL","AR","AZ","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID", "IL","IN","KS","KY","LA","MD","MA","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY", "OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
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
        ]
    }
    
}
