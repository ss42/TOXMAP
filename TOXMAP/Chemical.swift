//
//  Chemical.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import Foundation


class Chemical {
    let chemicalName: String?
    let chemicalID: String?
    let chemicalCASNum: String?
    
    init(chemicalName: String, chemicalID: String, chemicalCASNum: String){
        self.chemicalID = chemicalID
        self.chemicalName = chemicalName
        self.chemicalCASNum = chemicalCASNum
    }
    
    
}
