//
//  FAQViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 1/26/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var faqText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        faqText.delegate = self
        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])

        
        // You must set the formatting of the link manually
       // let attributedString = NSMutableAttributedString(string:"xyz")
        
       // attributedString.setAsLink(textToFind: "stackoverflow", linkURL: "http://stackoverflow.com")
        
        // Set the 'click here' substring to be the link
        //attributedString.setAttributes(linkAttributes, range: NSMakeRange(5, 10))
        //faqText.attributedText = attributedString

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
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

extension NSMutableAttributedString {
    
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
