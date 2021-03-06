//
//  MoreInfoViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 1/26/17.
//  Copyright © 2017 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)


import UIKit

class MoreInfoViewController: UIViewController {
    
    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var faq: UIButton!
    @IBOutlet weak var about: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createGradientLayer()
        navigationItem.title = "More Info"
        faq.backgroundColor = Constants.colors.secondaryColor
        about.backgroundColor = Constants.colors.secondaryColor
        
        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])
    }

   

    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
        self.view.bringSubview(toFront: faq)
        self.view.bringSubview(toFront: about)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
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


