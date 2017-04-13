//
//  FAQViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 1/26/17.
//  Copyright © 2017 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)


import UIKit

class FAQViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var faqText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        faqText.delegate = self
        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])

        
        faqText.delegate = self
        
        
        faqText.attributedText = createText()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        faqText.setContentOffset(CGPoint.zero, animated: false)
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
        let toxmapHomeurl = "https://toxmap.nlm.nih.gov/"
        let dosisUrl = "https://sis.nlm.nih.gov/"
        let nlmURL = "https://www.nlm.nih.gov/"
        let toxicURL = "https://www.epa.gov/toxics-release-inventory-tri-program"
        let nationalAnaURL = "https://www.epa.gov/trinationalanalysis"
        let s1 = "What is Tox-App? \n \n Tox-App is a native mobile app inspired by TOXMAP®, a Geographic Information System (GIS) from the Division of Specialized Information Services of the US National Library of Medicine® (NLM).  Tox-App brings some of the TOXMAP experience to iPhone and iPad users. This application was developed by undergraduate interns, under the direction of US Government employees, to increase the availability of TOXMAP and TRI data for casual users as well as for educational and research purposes. The initial version of Tox-App provides some of the basic functions available through TOXMAP.  Specifically, it allows users to search for facilities that released any of 100 selected TRI chemicals in the most current TRI year, or browse for these facilities by state.\n \n"
        let s2 = "What is the Toxics Release Inventory (TRI)?\n \nThe Toxics Release Inventory (TRI) is a publicly available database that contains information on toxic chemical releases and other waste management activities reported annually by certain covered industry groups as well as federal facilities.  It requires facilities in certain industries which manufacture, process, or use significant amounts of toxic chemicals, to report annually on their releases of these chemicals. The reports contain information about the types and amounts of toxic chemicals that are released each year to the air, water, land and by underground injection, as well as information on the quantities of toxic chemicals sent to other facilities for further waste management.\n \n"
        let s3 = "Does Tox-App show all sources of toxic chemicals released into the environment?\n \nTox-App, like TOXMAP, only shows reported on-site releases—those chemicals that are not treated, recycled, or transferred off-site.  Moreover, Tox-App only considers a subset of all TRI chemicals required to be reported by the EPA.  These chemicals were selected based on several criteria:  they were especially dangerous to humans or the environment, were reported more often to TRI, and/or were searched more often by TOXMAP users.\n \n"
        let s4 = "The chemical or facility I’m looking for isn’t listed. Why?\n \n Tox-App only considers a subset of all TRI chemicals required to be reported by the EPA, and only shows chemical releases for the most current TRI year.  Further, it only shows facilities that released at least one of these chemicals.  Chemicals were selected based on several criteria—they were especially dangerous to humans or the environment, were reported more often to TRI, and/or were searched more often by TOXMAP users.  Refer to the web-based TOXMAP for all TRI chemicals, facilities, and years, but note that this version is not optimized for viewing on mobile devices.\n \n"
        let s5 = "There are TRI releases near my neighborhood. Is my health at risk?\n \n There is currently no standard approach to assess overall human health risk. People are exposed to chemicals in our environment via in the air we breathe, the water we drink, the houses we live in, and the food we eat. The toxicity of a substance depends on many factors: the dosage, exposure route; species, age, sex, metabolism, etc. TRI release estimates are one resource that can be used to evaluate exposure or calculate potential risks to human health and the environment. However, it is essential to understand that they do not, by themselves, represent risk.\n \n"
        let s6 = "Will Tox-App be updated? Will it be available on other mobile platforms? Is the data current?\n  \n Tox-App will be updated at least annually with the most current, final TRI data available from the EPA as part of its National Analysis.  Future versions of the app may also involve additional mobile platforms and functionality.\n"
        let addedString = NSMutableString()
        addedString.append(s1)
        addedString.append(s2)
        addedString.append(s3)
        addedString.append(s4)
        addedString.append(s5)
        addedString.append(s6)

        let myAttribute = [ NSFontAttributeName: UIFont(name: "CenturyGothic", size: 16.0)! ]
        
        let attributedString = NSMutableAttributedString(string: addedString as String, attributes: myAttribute)
        
        attributedString.setAsLink(textToFind: "TOXMAP", linkURL: toxmapurl)
        attributedString.setAsLink(textToFind: "Division of Specialized Information Services", linkURL: dosisUrl)
        attributedString.setAsLink(textToFind: "National Library of Medicine® (NLM)", linkURL: nlmURL)
        attributedString.setAsLink(textToFind: "Toxics Release Inventory ", linkURL: toxicURL)
        attributedString.setAsLink(textToFind: "National Analysis", linkURL: nationalAnaURL)
        attributedString.setAsLink(textToFind: "web-based TOXMAP", linkURL: toxmapHomeurl)
        attributedString.makeBold(textToFind: "What is Tox-App?")
        attributedString.makeBold(textToFind: "What is the Toxics Release Inventory (TRI)?")
        attributedString.makeBold(textToFind: "Does Tox-App show all sources of toxic chemicals released into the environment?")
        attributedString.makeBold(textToFind: "The chemical or facility I’m looking for isn’t listed. Why?")
        attributedString.makeBold(textToFind: "There are TRI releases near my neighborhood. Is my health at risk?")
        attributedString.makeBold(textToFind: "Will Tox-App be updated? Will it be available on other mobile platforms? Is the data current?")
        return attributedString
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
            UIApplication.shared.open(URL, options: [:])
        return true
    }
}

extension NSMutableAttributedString {
    /**
     Search the word in the text to replace with URL
     
     - parameter bar: Text to make that url
     
     - returns: bool
     */
    public func setAsLink(textToFind:String, linkURL:String)  {
        
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
            
        }
        
    }
    public func makeBold(textToFind: String){
        let foundRange = self.mutableString.range(of: textToFind)
        let boldFontAttribute = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17.0)]
        if foundRange.location != NSNotFound {
            self.addAttributes(boldFontAttribute, range: foundRange)
            self.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: foundRange)

        }
    }
    
    func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont(name: "CenturyGothic", size: 16)!]
        let boldString = NSMutableAttributedString(string:"\(text)", attributes: attrs)
        self.append(boldString)
        return self
    }
}
