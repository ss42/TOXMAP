//
//  DetailViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 12/18/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var facilityIDLabel: UILabel!
    @IBOutlet weak var facilityNumberLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var facilityAddressLabel: UILabel!
    @IBOutlet weak var facilityCurrentReleaseLabel: UILabel!
    @IBOutlet weak var facilityTotalReleaseLabel: UILabel!
    var index: Int?
    
    var facilityToDisplay: Facility?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // print(index)
 //       index = UserDefaults.standard.value(forKey: "index") as! Int?
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.facility = facilityToDisplay
 //       print(facilityToDisplay?.city)
        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])
        updateLabels(fac: facilityToDisplay!)
        //updateLabels(fac: Facility.sharedInstance[index!])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateLabels(fac: Facility){
        facilityNameLabel.text = fac.name as String?
        facilityIDLabel.text = fac.id as String?
        facilityNumberLabel.text = fac.number as String?
        latitudeLabel.text = String(describing: fac.latitude!)
        longitudeLabel.text = String(describing:fac.longitude!)
        facilityCurrentReleaseLabel.text = String(describing: fac.current!)
        facilityTotalReleaseLabel.text = String(describing: fac.total!)
        facilityAddressLabel.text = fac.address()
        
        
        
    
    }
    @IBAction func showInMap(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.showInMap , sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.showInMap{
            let vc = segue.destination as! ShowInMapViewController
            vc.facilityToMap = facilityToDisplay
            
            
        }
    }
    

}
