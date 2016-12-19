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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       // print(index)
        index = UserDefaults.standard.value(forKey: "index") as! Int?
        print(index)
        
        //print(Facility.sharedInstance[0].id)
        updateLabels(fac: Facility.sharedInstance[index!])
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
    

}
