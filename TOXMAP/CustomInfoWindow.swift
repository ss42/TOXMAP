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
            layer.borderColor = UIColor.blue.cgColor
            layer.cornerRadius = 4
            //layer.masksToBounds =
        }
    }
    @IBOutlet weak var facilityName: UILabel!
    @IBOutlet var chemical: UILabel!
    @IBOutlet var address: UILabel!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
   

}
