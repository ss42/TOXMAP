//
//  SecondViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import ArcGIS

var facilityURL = "https://toxmap.nlm.nih.gov/arcgis/rest/services/toxmap5/toc/MapServer/6"

class BrowseViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    private var featureTable:AGSServiceFeatureTable!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.featureTable = AGSServiceFeatureTable(url: URL(string: kMapServiceLayerURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        
        queryForState()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func queryForState() {
        
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = "fst='MA'"
        
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
                    // long = CLLocationDegrees(long!)
                    let lat = facility.attributes["LATD"] as? NSNumber
                    //lat = CLLocationDegrees(lat!)
                    //self.longitudes.append(long as! Double)
                    //self.latitudes.append(lat as! Double)
                    let totalerelt = facility.attributes["TOTALERELT"] as? NSNumber
                    print(totalerelt)
                    let totalCur = facility.attributes["TOT_CURRENT"] as? NSNumber
                    print(totalCur)
                    //var objectid = facility?.attribute(forKey: "OBJECTID") as? NSNumber
                    let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                    
                   // self.facilities.append(fac)
                    Facility.sharedInstance.append(fac)
                    print(facility)
                    print(Facility.sharedInstance[0].address())
                    
                }
                
                print(result?.featureEnumerator().allObjects.count)
                print("printing count")
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row 
        UserDefaults.standard.setValue(index, forKey: "index")
        performSegue(withIdentifier: "browseToDetail", sender: nil)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Facility.sharedInstance.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.chemicalCell)
        print("hellow")
        print(Facility.sharedInstance[indexPath.row].name as String!)
        cell?.textLabel?.text = Facility.sharedInstance[indexPath.row].name as String!
        return cell!
    }
   


}

