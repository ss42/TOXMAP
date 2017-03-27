//
//  ADVSegmentedControl.swift
//  Mega
//
//  Created by Tope Abayomi on 01/12/2014.
//  Copyright (c) 2014 App Design Vault. All rights reserved.
//

import UIKit

@IBDesignable class ADVSegmentedControl: UIControl {
    
    fileprivate var labels = [UILabel]()
    var thumbView = UIView()
    
    var items: [String] = ["Item 1", "Item 2"] {
        didSet {
            setupLabels()
        }
    }
    
    var selectedIndex : Int = 0 {
        didSet {
            displayNewSelectedIndex()
        }
    }
    
    @IBInspectable var selectedLabelColor : UIColor = Constants.colors.secondaryColor {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var unselectedLabelColor : UIColor = Constants.colors.secondaryColor {
        didSet {
            setSelectedColors()
        }
    }
    
    @IBInspectable var thumbColor : UIColor = UIColor.white {
        didSet {
            setSelectedColors()
        }
    }
    
    
    /*@IBInspectable var borderColor : UIColor = UIColor.whiteColor() {
        didSet {
            layer.borderColor = borderColor.CGColor
        }
    }
    */
    @IBInspectable var font : UIFont! = UIFont.systemFont(ofSize: 12) {
        didSet {
            setFont()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView(){
        
        //layer.cornerRadius = frame.height / 2
        layer.borderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
        layer.borderWidth = 2  //changed from 2
        
        backgroundColor = UIColor.white
        
        setupLabels()
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
        
        insertSubview(thumbView, at: 0)
    }
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor.black//(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        //old school frame way of doing things
        //        horizontalBarView.frame = CGRectMake(<#T##x: CGFloat##CGFloat#>, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        
        //new school way of laying out our views
        //in ios9
        //need x, y, width, height constraints
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    func setupLabels(){
        
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepingCapacity: true)
        
        for index in 1...items.count {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 70, height: 10))
            label.text = items[index - 1]
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            label.font = UIFont(name: "Open-sans", size: 18)
            label.textColor = index == 1 ? selectedLabelColor : unselectedLabelColor
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            labels.append(label)
        }
        
        addIndividualItemConstraints(labels, mainView: self, padding: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = CGRect(x: 0, y: 0, width: 70, height: 1)  //self.bounds
        let newWidth = selectFrame.width / CGFloat(items.count)
        selectFrame.size.width = newWidth
        selectFrame.size.height = 1  //changed from 1
        thumbView.frame = selectFrame
        thumbView.backgroundColor = thumbColor


        displayNewSelectedIndex()
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        
        if calculatedIndex != nil {
            selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    func displayNewSelectedIndex(){
        for (index, item) in labels.enumerated() {
            item.textColor = unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = selectedLabelColor
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            
            self.thumbView.frame = label.frame
           // self.setupHorizontalBar()
            print("selected")
            
            }, completion: nil)
    }
    
    func addIndividualItemConstraints(_ items: [UIView], mainView: UIView, padding: CGFloat) {
        
        let constraints = mainView.constraints
        
        for (index, button) in items.enumerated() {
            
            let topConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
            
            let bottomConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
            
            var rightConstraint : NSLayoutConstraint!
            
            if index == items.count - 1 {
                
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: -padding)
                
            }else{
                
                let nextButton = items[index+1]
                rightConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: nextButton, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: -padding)
            }
            
            
            var leftConstraint : NSLayoutConstraint!
            
            if index == 0 {
                
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: mainView, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: padding)
                
            }else{
                
                let prevButton = items[index-1]
                leftConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: prevButton, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: padding)
                
                let firstItem = items[0]
                
                let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: firstItem, attribute: .width, multiplier: 1.0  , constant: 0)
                
                mainView.addConstraint(widthConstraint)
            }
            
            mainView.addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
        }
    }
    
    func setSelectedColors(){
        for item in labels {
            item.textColor = unselectedLabelColor
        }
        
        if labels.count > 0 {
            labels[0].textColor = selectedLabelColor
        }
        
        thumbView.backgroundColor =  thumbColor
    }
    
    func setFont(){
        for item in labels {
            item.font = font
        }
    }
}
class UnderlinedLabel: UILabel {
 
    @IBInspectable var leftLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var rightLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var bottomLine: Bool = false { didSet{ drawLines() } }
    @IBInspectable var topLine: Bool = false { didSet{ drawLines() } }
 
    func drawLines(){
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = Constants.colors.mainColor.cgColor
            border.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
            border.borderWidth = width
            layer.addSublayer(border)
    }
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    @IBInspectable var addPadding: CGFloat = 0 {
        didSet{
            self.padding = UIEdgeInsets(top: 2, left: addPadding, bottom: 2, right: 8)

        }
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
 }


