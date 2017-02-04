//
//  FacilitiesTableViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import ArcGIS


class FacilitiesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var stateQueryText: String = ""
    private var featureTable:AGSServiceFeatureTable!
    private var facility: Facility?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Facility.sharedInstance.removeAll()
        print(stateQueryText + " State in facilities view controller")
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.facilityURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        if stateQueryText != ""{
            queryForState(state: stateQueryText)

        }
        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Facility.sharedInstance.removeAll()
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.facilityURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        
        queryForState(state: stateQueryText)
        tableView.reloadData()
        print("super init")
    }
    
    func queryForState(state: String) {
        print("quering state")
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = "fst='\(state)'"
        print(queryParams.whereClause + " Where clause to search")
        
        self.featureTable.populateFromService(with: queryParams, clearCache: true, outFields: ["*"]) { result, error in
            if let error = error {
                
                print("populateFromServiceWithParameters error :: \(error.localizedDescription)")
            }
            else {
                //the resulting features should be displayed on the map
                //you can print the count of features
                print(result?.featureEnumerator().allObjects.count ?? 0)
                
                    for facility in (result?.featureEnumerator().allObjects)!{
                        
                        let name = facility.attributes["fnm"] as? NSString
                        let facilityNumber = facility.attributes["facn"] as? NSString
                        let street = facility.attributes["fad"] as? NSString
                        //let countyName = facility.attributes["FCO"] as? NSString
                        let city = facility.attributes["fcty"] as? NSString
                        let state = facility.attributes["fst"]as? NSString
                        let zipcode = facility.attributes["fzip"] as? NSString
                        let facitlityID = facility.attributes["frsid"] as? NSString
                        let long = facility.attributes["longd"] as? NSNumber
                        // long = CLLocationDegrees(long!)
                        let lat = facility.attributes["latd"] as? NSNumber
                        //lat = CLLocationDegrees(lat!)
                        //self.longitudes.append(long as! Double)
                        //self.latitudes.append(lat as! Double)
                        let totalerelt = facility.attributes["totalerelt"] as? NSNumber
                        
                        let totalCur = facility.attributes["tot_current"] as? NSNumber
                        
                        //var objectid = facility?.attribute(forKey: "OBJECTID") as? NSNumber
                        let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                        
                        // self.facilities.append(fac)
                        Facility.sharedInstance.append(fac)
                       
                        
                    }
               
                
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            facility = Facility.sharedInstance[indexPath.row]
            performSegue(withIdentifier: Constants.Segues.browseFacilityToDetail , sender: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Facility.sharedInstance.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.chemicalCell)
            cell?.textLabel?.text = Facility.sharedInstance[indexPath.row].name as String!
            return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.browseFacilityToDetail{
            let vc = segue.destination as! DetailViewController
            vc.facilityToDisplay = facility
            
            
        }
    }

}
