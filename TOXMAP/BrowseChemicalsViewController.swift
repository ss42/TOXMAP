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
    private var featureTable:AGSServiceFeatureTable!
    
    var featureSet:AGSFeatureSet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List of Chemicals"
        tableView.reloadData()
        tableView.translatesAutoresizingMaskIntoConstraints = false


        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.chemicalURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func convertToAlias(number: Int){
        let chemAlias = "chem_" + "\(number + 1)" + " > 0"

        
        
        self.query(whereText: chemAlias){(result: String) in
            print(result)
            //self.tableView.reloadData()
            SVProgressHUD.dismiss()
            UIApplication.shared.endIgnoringInteractionEvents()
            //Segue to next view controller
            if Facility.sharedInstance.count != 0{
                self.performSegue(withIdentifier: Constants.Segues.chemicalToFacility, sender: nil)

            }
            else{
                self.showError("No Faclities Found", message: "Please try browsing different chemical")
            }
            
        }
        
        
    }
    func query(whereText: String, completion: @escaping (_ result: String) -> Void) {
        Facility.sharedInstance.removeAll()
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = whereText
        SVProgressHUD.show(withStatus: "Loading")
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        
        UIApplication.shared.beginIgnoringInteractionEvents()

        self.featureTable.populateFromService(with: queryParams, clearCache: true, outFields: ["*"]) { result, error in
            if let error = error {
                print("populateFromServiceWithParameters error :: \(error.localizedDescription)")
            }
            else {
                //the resulting features should be displayed on the map
                //you can print the count of features
                for facility in (result?.featureEnumerator().allObjects)!{
                    
                    
                    
                    let name = facility.attributes["FNM"] as? NSString
                    let facilityNumber = facility.attributes["FACN"] as? NSString
                    let street = facility.attributes["FAD"] as? NSString
                    //let countyName = facility.attributes["FCO"] as? NSString
                    let city = facility.attributes["FCTY"] as? NSString
                    let state = facility.attributes["FST"]as? NSString
                    let zipcode = facility.attributes["FZIP"] as? NSString
                    let facitlityID = facility.attributes["FRSID"] as? NSString
                    let long = facility.attributes["LONGD"] as? NSNumber
                    let lat = facility.attributes["LATD"] as? NSNumber
                    let totalerelt = facility.attributes["TOTALERELT"] as? Int
                    let totalCur = facility.attributes["TOT_CURRENT"] as? Int
                    let fac = Facility(number: facilityNumber!, name: name! as String, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                    
                    Facility.sharedInstance.append(fac)
                    
                    self.tableView.reloadData()
                    
                }
                completion("Finished loading data")
            }
        }
    }
    
    func showError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ChemicalList.chemicalName.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.browseChemicalCell, for: indexPath)
        


        cell.textLabel?.text = ChemicalList.chemicalName[indexPath.row]

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = Constants.colors.secondaryColor

        convertToAlias(number: index)
    }
 



}
