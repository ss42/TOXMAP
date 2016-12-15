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
            //layer.borderColor = CGColor
            layer.cornerRadius = 5
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
    @IBInspectable
    var borderWidth: CGFloat{
        get {
            return layer.borderWidth
        }
        set(newBoarderWidth){
            layer.borderWidth = newBoarderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor?{
        get {
            return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue != 0
        }
    }

}
