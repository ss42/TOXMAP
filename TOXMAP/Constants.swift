//
//  Constants.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)


import Foundation
import UIKit


struct Constants {
    
    static let TRIYear = "2015"

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
        static let tutorialToMoreinfo = "tutorialToMoreinfo"
        
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
 

    struct State {
        static let stateFullName = ["ALABAMA","ALASKA","ARIZONA","ARKANSAS","CALIFORNIA","COLORADO","CONNECTICUT","D.C.", "DELAWARE","FLORIDA","GEORGIA","HAWAII","IDAHO","ILLINOIS","INDIANA","IOWA","KANSAS","KENTUCKY","LOUISIANA","MAINE","MARYLAND","MASSACHUSETTS","MICHIGAN","MINNESOTA","MISSISSIPPI","MISSOURI","MONTANA","NEBRASKA","NEVADA","NEW HAMPSHIRE","NEW JERSEY","NEW MEXICO","NEW YORK","NORTH CAROLINA","NORTH DAKOTA","OHIO","OKLAHOMA","OREGON","PENNSYLVANIA","RHODE ISLAND","SOUTH CAROLINA","SOUTH DAKOTA","TENNESSEE","TEXAS","UTAH","VERMONT","VIRGINIA","WASHINGTON","WEST VIRGINIA","WISCONSIN","WYOMING"]
        static let stateAbbreviation = ["AL","AK","AZ","AR","CA","CO","CT","DC","DE","FL","GA","HI","ID", "IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MO","MS","MT","NE","NV","NH","NJ","NM","NY","NC","ND", "OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
        static let menuState = ["ALL STATES","ALABAMA","ALASKA","ARIZONA","ARKANSAS","CALIFORNIA","COLORADO","CONNECTICUT","D.C.", "DELAWARE","FLORIDA","GEORGIA","HAWAII","IDAHO","ILLINOIS","INDIANA","IOWA","KANSAS","KENTUCKY","LOUISIANA","MAINE","MARYLAND","MASSACHUSETTS","MICHIGAN","MINNESOTA","MISSISSIPPI","MISSOURI","MONTANA","NEBRASKA","NEVADA","NEW HAMPSHIRE","NEW JERSEY","NEW MEXICO","NEW YORK","NORTH CAROLINA","NORTH DAKOTA","OHIO","OKLAHOMA","OREGON","PENNSYLVANIA","RHODE ISLAND","SOUTH CAROLINA","SOUTH DAKOTA","TENNESSEE","TEXAS","UTAH","VERMONT","VIRGINIA","WASHINGTON","WEST VIRGINIA","WISCONSIN","WYOMING"]

  }
    
}

