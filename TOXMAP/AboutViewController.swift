//
//  AboutViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 1/26/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.view.backgroundColor = CGGradient(colorsSpace: , colors: <#T##CFArray#>, locations: <#T##UnsafePointer<CGFloat>?#>)
        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])

        textView.delegate = self


        textView.attributedText = createText()

        textView.sizeToFit()
 
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textView.setContentOffset(CGPoint.zero, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     Makes the whole text with proper urls
     
     - parameter bar:
     
     - returns: NSMutableAttributedString (this was used so that custom url could be added)
     */
    func createText()-> NSMutableAttributedString{
        
        let toxmapurl = "https://toxmap.nlm.nih.gov/toxmap/"
        let dosisUrl = "https://sis.nlm.nih.gov/"
        let nlmURL = "https://www.nlm.nih.gov/"
        let epaTriURL = "https://www.epa.gov/toxics-release-inventory-tri-program"
        let moreToxURL = "https://toxmap.nlm.nih.gov/toxmap/faq/2009/08/what-is-toxmap.html"
        let dataURL = "https://toxmap.nlm.nih.gov/toxmap/faq/2009/08/what-data-sources-does-toxmap-use.html"
        let factURL = "https://www.nlm.nih.gov/pubs/factsheets/toxmap.html"
        let s1 = "Tox-App is a native mobile app inspired by TOXMAP®, a Geographic Information System (GIS) from the Division of Specialized Information Services of the US National Library of Medicine® (NLM).  TOXMAP helps users explore maps of EPA Toxics Release Inventory facilities, Superfund sites, coal power plants, and more, while overlaying map layers of US census, income, and health data. \n \n"
        let s2 = "Tox-App brings some of the TOXMAP experience to iPhone and iPad users. This application was developed by undergraduate interns, under the direction of US Government employees, to increase the accessibility of TOXMAP and TRI data for casual users as well as for educational and research purposes. The initial version of Tox-App provides some of the basic functions available through TOXMAP.  Specifically, it allows users to search for facilities that released any of 100 selected TRI chemicals in the most current TRI year, or browse for these facilities by state and county. \n \n"
        let s3 = "TOXMAP and Tox-App are resources funded by the US Federal Government; it does not allow advertising on the site or endorse any company or product. It also cannot respond to questions about individual medical cases, provide second opinions, or make specific recommendations regarding therapy. Those issues should be addressed directly with your healthcare provider.\n"
        let s4 = "Read more about TOXMAP and its data sources or check out the TOXMAP Fact Sheet."
        let addedString = NSMutableString()
        addedString.append(s1)
        addedString.append(s2)
        addedString.append(s3)
        addedString.append(s4)
        let myAttribute = [ NSFontAttributeName: UIFont(name: "CenturyGothic", size: 16.0)! ]
        
        let attributedString = NSMutableAttributedString(string: addedString as String, attributes: myAttribute)
   
        attributedString.setAsLink(textToFind: "TOXMAP", linkURL: toxmapurl)
        attributedString.setAsLink(textToFind: "Division of Specialized Information Services", linkURL: dosisUrl)
        attributedString.setAsLink(textToFind: "National Library of Medicine® (NLM)", linkURL: nlmURL)
        attributedString.setAsLink(textToFind: "Toxics Release Inventory ", linkURL: epaTriURL)
        attributedString.setAsLink(textToFind: "more about TOXMAP ", linkURL: moreToxURL)
        attributedString.setAsLink(textToFind: "data sources", linkURL: dataURL)
        attributedString.setAsLink(textToFind: "Fact Sheet", linkURL: factURL)
        return attributedString

    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("pressed")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL, options: [:])
        } else {
            // Fallback on earlier versions
            UIApplication.shared.openURL(URL)
        }
        return true
    }
}
