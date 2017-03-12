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
    struct URL {
        static let facilityURL = "https://toxmap.nlm.nih.gov/arcgis/rest/services/toxmap5/toc/MapServer/6"
        static let chemicalURL = "https://toxmap.nlm.nih.gov/arcgis/rest/services/toxmap5/vsfs_chemtable/MapServer/0"
    }
    
    struct Segues {
        static let stateToFacility = "stateToFacilitiesSegue"
        static let browseFacilityToDetail = "browseToDetailSegue"
        static let showInMap = "detailToShowMapSegue"
        static let browseToState = "browseStateSegue"
        static let searchToDetail = "browseToDetailSegue"
        static let browseToFacilities = "browseToFacilityList"
        static let facilityListToDetail = "FacilityListToDetailSegue"
        static let chemicalToFacility = "chemicalToFacilitySegue"
        static let searchToFacility = "searchResultSegue"
        static let stateToCounty = "stateToCountySegue"
        static let countyToFacility = "countyToFacilitySegue"
        static let homeToDetail = "markerToDetail"
        
    }
    struct CellIdentifier {
        static let chemicalCell = "chemicalCell"
        static let stateCell = "stateCell"
        static let browseCell = "browseCell"
        static let FacilityListCell = "FacilityCell"
        static let browseChemicalCell = "browseChemicalCell"
        
    }
    struct colors {
        static let secondaryColor = UIColor(red: 27/255, green: 214/255, blue: 183/255, alpha: 1)
        static let mainColor = UIColor(red: 25/255, green: 29/255, blue: 67/255, alpha: 1)
        static let lightColor = UIColor(red: 162/255, green: 246/255, blue: 267/255, alpha: 1)
    }
    /*
     
     Font Family Name = [Helvetica Neue]
     Font Names = [["HelveticaNeue-Italic", "HelveticaNeue-Bold", "HelveticaNeue-UltraLight", "HelveticaNeue-CondensedBlack", "HelveticaNeue-BoldItalic", "HelveticaNeue-CondensedBold", "HelveticaNeue-Medium", "HelveticaNeue-Light", "HelveticaNeue-Thin", "HelveticaNeue-ThinItalic", "HelveticaNeue-LightItalic", "HelveticaNeue-UltraLightItalic", "HelveticaNeue-MediumItalic", "HelveticaNeue"]]
     */
    

    struct State {
        static let stateFullName = ["ALABAMA","ALASKA","ARIZONA","ARKANSAS","CALIFORNIA","COLORADO","CONNECTICUT","D.C.", "DELAWARE","FLORIDA","GEORGIA","HAWAII","IDAHO","ILLINOIS","INDIANA","IOWA","KANSAS","KENTUCKY","LOUISIANA","MAINE","MARYLAND","MASSACHUSETTS","MICHIGAN","MINNESOTA","MISSISSIPPI","MISSOURI","MONTANA","NEBRASKA","NEVADA","NEW HAMPSHIRE","NEW JERSEY","NEW MEXICO","NEW YORK","NORTH CAROLINA","NORTH DAKOTA","OHIO","OKLAHOMA","OREGON","PENNSYLVANIA","RHODE ISLAND","SOUTH CAROLINA","SOUTH DAKOTA","TENNESSEE","TEXAS","UTAH","VERMONT","VIRGINIA","WASHINGTON","WEST VIRGINIA","WISCONSIN","WYOMING"]
        static let stateAbbreviation = ["AL","AK","AZ","AR","CA","CO","CT","DC","DE","FL","GA","GU","HI","IA","ID", "IL","IN","KS","KY","LA","MD","MA","ME","MH","MI","MN","MO","MS","MT","NC","ND","NE","NH","NJ","NM","NV","NY", "OH","OK","OR","PA","PR","PW","RI","SC","SD","TN","TX","UT","VA","VI","VT","WA","WI","WV","WY"]
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
extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
