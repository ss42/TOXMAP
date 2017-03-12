//
//  CustomInfoWindow.swift
//  CustomInfoWindow
//
//  Created by Malek T. on 12/13/15.
//  Copyright © 2015 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class CustomInfoWindow: UIView {

    @IBOutlet weak var view: UIView!{
        didSet{
            layer.borderWidth = 1
            layer.borderColor = Constants.colors.lightColor.cgColor
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }
    }
    @IBOutlet weak var facilityName: UILabel!
    @IBOutlet var address: UILabel!
    @IBOutlet weak var chemicalName: UILabel!
    @IBOutlet weak var chemicalAmount: UILabel!
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
   
    @IBAction func moreDetails() {
        
        print("hello world")
    }

}
