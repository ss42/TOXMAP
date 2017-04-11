//
//  CustomInfoWindow.swift
//  CustomInfoWindow
//
//  Created by Sanjay Shrestha on 1/26/17.
//  Copyright © 2017 NIH. All rights reserved.
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
    @IBOutlet weak var TRIYearTitle: PaddingLabel!
    @IBOutlet weak var TotalChemicalReleaseYear: PaddingLabel!
    
    

}


class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
