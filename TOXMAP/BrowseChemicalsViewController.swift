//
//  BrowseChemicalsTableViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 2/18/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit
import ArcGIS
import SVProgressHUD

class BrowseChemicalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var chemicalSelected = ""
    private var featureTable:AGSServiceFeatureTable!
    
    var featureSet:AGSFeatureSet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List of Chemicals"
        tableView.reloadData()
        tableView.translatesAutoresizingMaskIntoConstraints = false

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if tableView.indexPathForSelectedRow != nil {
            let indexpath: NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
                tableView.deselectRow(at: indexpath as IndexPath, animated: true)
            }
        
    }
    
    
    
    /**
     Converts the Chemical Name to Alias and call Query function
     
     - parameter bar: Index of the chemical from the tableView
     - returns:
     */

    func convertToAlias(number: Int){
        
        chemicalSelected = Chemical.chemicalAlias[number]
        let chemAlias = "\(chemicalSelected)" + " > 0"
        self.query(whereString: chemAlias){(result: String) in
            SVProgressHUD.dismiss()
            UIApplication.shared.endIgnoringInteractionEvents()
            if Facility.sharedInstance.count != 0{
                self.performSegue(withIdentifier: Constants.Segues.chemicalToFacility, sender: nil)
            }
            else{
                self.showError("No Faclities Found", message: "Please try browsing different chemical")
            }
        }
        
    }
    
    // MARK: - QUERY function
    /**
     Query chemicals
     
     - parameter bar: wheretext - The actual input text to search
     
     - returns: completion handler and fills Facility Shared instance
     */
    func query(whereString: String, completion: @escaping (_ result: String) -> Void) {
        Facility.sharedInstance.removeAll()
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.chemicalURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        SVProgressHUD.show(withStatus: "Loading")
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = whereString
        print(queryParams.whereClause + " Where clause to search")
        
        self.featureTable.populateFromService(with: queryParams, clearCache: true, outFields: ["*"]) { result, error in
            if let error = error {
                print("populateFromServiceWithParameters error :: \(error.localizedDescription)")
            }
            else {
                for facility in (result?.featureEnumerator().allObjects)!{
                    let name = facility.attributes["FNM"] as? String
                    let facilityNumber = facility.attributes["FACN"] as? NSString
                    let street = facility.attributes["FAD"] as? NSString
                    let city = facility.attributes["FCTY"] as? NSString
                    let state = facility.attributes["FST"]as? NSString
                    let zipcode = facility.attributes["FZIP"] as? NSString
                    let facitlityID = facility.attributes["FRSID"] as? NSString
                    let long = facility.attributes["LONGD"] as? NSNumber
                    let lat = facility.attributes["LATD"] as? NSNumber
                    let totalerelt = facility.attributes["TOTALERELT"] as? Int
                    let totalCur = facility.attributes["TOT_CURRENT"] as? Int
                    let amount = facility.attributes[self.chemicalSelected] as? Int
                    let chemical = ["chemicalAlias": self.chemicalSelected, "amount": String(describing: amount!)]
                    let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!,  chemical: chemical )
                    Facility.sharedInstance.append(fac)
                }
                completion("done with query")
                
            }
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chemical.chemicalName.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.browseChemicalCell, for: indexPath)
        cell.textLabel?.text = Chemical.chemicalName[indexPath.row].capitalized
        return cell
    }
    // MARK: - Table view is Tapped or selected

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = Constants.colors.secondaryColor
        tableView.deselectRow(at: indexPath, animated: true)
        let manager = Manager()
        if !manager.isInternetAvailable(){
            showError("No Internet Connection", message: "Please try after the internet connection is back.")
        }
        convertToAlias(number: index)
    }
 



}
