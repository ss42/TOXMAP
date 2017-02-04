//
//  SecondViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import ArcGIS



class BrowseViewController: UIViewController, UITextFieldDelegate {

    private var featureTable:AGSServiceFeatureTable!
    
    var searchMode = true
    
    @IBOutlet weak var searchSegment: UISegmentedControl!
    
    @IBOutlet weak var searchField: UITextField!{
        didSet{
            searchField.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.facilityURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BrowseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    @IBAction func searchPressed(_ sender: Any) {
        if searchField.text != ""{
            let searchText = searchField.text!.uppercased()
            if searchSegment.selectedSegmentIndex == 0{
                let searchString = "fnm='\(searchText)'"
                self.query(whereString: searchString){(result: String) in
                    print(result)
                    self.performSegue(withIdentifier: Constants.Segues.browseToFacilities, sender: nil)
                    
                }

                
            }
            else{
                let searchString = "fco='\(searchText)'"
                
                self.query(whereString: searchString){(result: String) in
                    print(result)
                    self.performSegue(withIdentifier: Constants.Segues.browseToFacilities, sender: nil)
                    
                }

                
            }

            

            
        }
        else {
            //show error of no text in textfield
        }
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    @IBAction func browseByChemicals(_ sender: Any) {
    }
    
    
    @IBAction func browseByState(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.browseToState, sender: nil)
      

    }
    func query(whereString: String, completion: @escaping (_ result: String) -> Void) {
        
        
        
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = whereString
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
                    
                    print(fac.name ?? "no name")
                    Facility.searchInstance.append(fac)
                    
                    
                        
                    
                }
                completion("done")
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    //makes the textfield empty when trying to search again
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchField.text = ""
    }

    
    





}

