//
//  BrowseStateViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 1/26/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit
import ArcGIS

class BrowseStateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var featureTable:AGSServiceFeatureTable!
    var activityIndicator = UIActivityIndicatorView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Browsing by STATE"
      //  self.navigationController?.navigationBar.topItem?.title = "Browsing by STATE"
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.chemicalURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertToAlias(number: Int){
        let state = Constants.State.stateAbbreviation[number]
        let alias =  "fst='\(state)'"

        
        self.query(whereText: alias){(result: String) in
            print(result)
            //self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            //Segue to next view controller
            self.performSegue(withIdentifier: Constants.Segues.stateToFacility, sender: nil)

        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        activityIndicator.startAnimating()

//        print(index)
//        
//            UserDefaults.standard.setValue(index, forKey: "index")
        convertToAlias(number: index)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.State.stateFullName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.stateCell)
        cell?.textLabel?.text = Constants.State.stateFullName[indexPath.row]
        return cell!
        
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == Constants.Segues.stateToFacility{
//            let vc = segue.destination as! FacilitiesTableViewController
//            let indexPath:NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
//            vc.stateQueryText = Constants.State.stateAbbreviation[indexPath.row]
//            print(vc.stateQueryText)
//            
//        }
//    }
    
    func query(whereText: String, completion: @escaping (_ result: String) -> Void) {
        Facility.sharedInstance.removeAll()
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = whereText
        
        self.featureTable.populateFromService(with: queryParams, clearCache: true, outFields: ["*"]) { result, error in
            if let error = error {
                print("populateFromServiceWithParameters error :: \(error.localizedDescription)")
            }
            else {
                //the resulting features should be displayed on the map
                //you can print the count of features
                for facility in (result?.featureEnumerator().allObjects)!{
                    
                    
                    
                    let name = facility.attributes["FNM"] as? NSString
                    print(name)
                    let facilityNumber = facility.attributes["FACN"] as? NSString
                    let street = facility.attributes["FAD"] as? NSString
                    //let countyName = facility.attributes["FCO"] as? NSString
                    let city = facility.attributes["FCTY"] as? NSString
                    let state = facility.attributes["FST"]as? NSString
                    let zipcode = facility.attributes["FZIP"] as? NSString
                    let facitlityID = facility.attributes["FRSID"] as? NSString
                    let long = facility.attributes["LONGD"] as? NSNumber
                    let lat = facility.attributes["LATD"] as? NSNumber
                    let totalerelt = facility.attributes["TOTALERELT"] as? NSNumber
                    let totalCur = facility.attributes["TOT_CURRENT"] as? NSNumber
                    let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                    
                    Facility.sharedInstance.append(fac)
                    
                    self.tableView.reloadData()
                    
                }
                completion("Finished loading data")
            }
        }
    }
    
    
    
}
