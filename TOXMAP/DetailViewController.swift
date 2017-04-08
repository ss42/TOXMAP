//
//  DetailViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 12/18/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
   // @IBOutlet weak var tableView: UITableView!
    
    var titles = ["Facility Name", "Address", "FRS ID", "Facility ID", "Latitude", "Total chemicals releases (all years)", "Total chemicals releases (2015)"]

    var facilityDetail = [String]()
    
    
    @IBOutlet weak var chemicalReleaseLabel: UILabel!
    @IBOutlet weak var chemicalNameLabel: UILabel!
    
    @IBOutlet weak var chemicalReleaseAmount: UILabel!
    
    @IBOutlet weak var facilityNameLabel: UILabel!
    @IBOutlet weak var facilityIDLabel: UILabel!
    @IBOutlet weak var facilityNumberLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var facilityAddressLabel: UILabel!
    @IBOutlet weak var facilityCurrentReleaseLabel: UILabel!
    @IBOutlet weak var facilityTotalReleaseLabel: UILabel!
    var index: Int?
    
    var facilityToDisplay: Facility?
    var navTitle = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])
        updateLabels(fac: facilityToDisplay!)
        navigationItem.title = navTitle
        

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Updates labels in View
     
     - parameter bar: Facility
     
     - returns: 
     */
    func updateLabels(fac: Facility){
        let coordinate = coordinateString(latitude: fac.latitude as! Double, longitude: fac.longitude as! Double)

        facilityNameLabel.text = fac.name as String?
        facilityIDLabel.text = fac.id as String?
        facilityNumberLabel.text = fac.number as String?
        latitudeLabel.text = coordinate
        facilityCurrentReleaseLabel.text = String(describing: fac.current!) + " pounds"
        facilityTotalReleaseLabel.text = String(describing: fac.total!) + " pounds"
        facilityAddressLabel.text = fac.address()
        chemicalReleaseLabel.text = "Total chemical release " + "(\(Constants.TRIYear))"
        if let chemical = fac.chemical?["amount"]{
            chemicalReleaseAmount.text = chemical + " pounds"
            let alias: String = (fac.chemical!["chemicalAlias"]!)
            let chemicalIndex = Chemical.chemicalAlias.index(of: alias)
            chemicalNameLabel.text = "Release Amount (\(Constants.TRIYear)):"
            navTitle = Chemical.chemicalName[chemicalIndex!].capitalized
            //Chemical.chemicalName[chemicalIndex!] +
        }
        else{
            chemicalReleaseAmount.isHidden = true
            chemicalNameLabel.isHidden = true
        }
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
    func coordinateString(latitude:Double, longitude:Double) -> String {
        var latSeconds = Int(latitude * 3600)
        let latDegrees = latSeconds / 3600
        latSeconds = abs(latSeconds % 3600)
        let latMinutes = latSeconds / 60
        latSeconds %= 60
        var longSeconds = Int(longitude * 3600)
        let longDegrees = longSeconds / 3600
        longSeconds = abs(longSeconds % 3600)
        let longMinutes = longSeconds / 60
        longSeconds %= 60
        return String(format:"%d°%d'%d\"%@ %d°%d'%d\"%@",
                      abs(latDegrees),
                      latMinutes,
                      latSeconds,
                      {return latDegrees >= 0 ? "N" : "S"}(),
                      abs(longDegrees),
                      longMinutes,
                      longSeconds,
                      {return longDegrees >= 0 ? "E" : "W"}() )
    }
    

}
