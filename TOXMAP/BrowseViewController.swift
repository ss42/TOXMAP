//
//  SecondViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import ArcGIS
import SVProgressHUD



class BrowseViewController: UIViewController, UITextFieldDelegate {

    private var featureTable:AGSServiceFeatureTable!
    
    var searchMode = true
    private var facility: Facility?


    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var searchSegment: ADVSegmentedControl!
    
    @IBOutlet weak var searchField: UITextField!{
        didSet{
            searchField.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchSegment.items = ["Facilities", "County", "State"]
        searchSegment.font = UIFont(name: "Muli-Light", size: 16)
        searchSegment.borderColor = Constants.colors.mainColor
        searchSegment.selectedIndex = 0
        searchSegment.addTarget(self, action: #selector(BrowseViewController.segmentValueChanged(_:)), for: .valueChanged)
        
        navigationItem.title = "Explore"

        

        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
  
        
        
    }

    func segmentValueChanged(_ sender: AnyObject?){
        if self.searchSegment.selectedIndex == 0{
            searchField.placeholder = "Search by facilities"
        }
        else if self.searchSegment.selectedIndex == 1{
            searchField.placeholder = "Search by County"
        }
        else {
            searchField.placeholder = "Search by State"
        }
        
        

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        view.endEditing(true)
        cancelButton.isHidden = true
        searchField.text = ""
    }

    
    @IBAction func searchPressed() {
        cancelButton.isHidden = true
        if searchField.text != ""{
            
            let searchText = searchField.text!.uppercased()
            if searchSegment.selectedIndex == 0{
                let searchString = "fnm='\(searchText)'"
                self.query(whereString: searchString){(result: String) in
                    print(result)
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if Facility.sharedInstance.count != 0{
                        self.facility = Facility.sharedInstance[0]
                        self.performSegue(withIdentifier: Constants.Segues.searchToDetail, sender: nil)
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.showError("\(self.searchField.text!) not found", message: "Please try with another search item")
                        }
                    }
                    
                    
                }

                
            }
            else if searchSegment.selectedIndex == 1{
                let searchString = "fco='\(searchText)'"
                //Need work here
                self.query(whereString: searchString){(result: String) in
                    print(result)
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if Facility.sharedInstance.count != 0{
                        self.performSegue(withIdentifier: Constants.Segues.searchToFacility, sender: nil)
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.showError("\(self.searchField.text!) not found", message: "Please try with another search item")
                        }
                    }
                }
            }
            else{
                let stateName = stateChecker(stateName: searchText)
                let searchString = "fst='\(stateName)'"
                
                self.query(whereString: searchString){(result: String) in
                    print(result)
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if Facility.sharedInstance.count != 0{
                        self.performSegue(withIdentifier: Constants.Segues.searchToFacility, sender: nil)
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.showError("\(self.searchField.text!) not found", message: "Please try  another search term.")
                        }
                    }
                }
            }
        }
        else {
            //showError("No text", message: "Enter facilities or county to search")
        }
    }
    func dismissKeyboard() {
        cancelButton.isHidden = true
        view.endEditing(true)
    }
    func showError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func stateChecker(stateName: String)-> String{
        
        if stateName.characters.count == 2{
            if stateName == "dc" || stateName == "DC" || stateName == "D.c"{
            return "DC"
            }
            else{
                return stateName.uppercased()
            }
        }
        else{
            if stateName.lowercased() == "washington dc" || stateName.lowercased() == "washington d.c" || stateName.lowercased() == "washington d.c," {
                return "DC"
            }
            for state in Constants.State.stateFullName{
                if stateName.uppercased() == state{
                    return Constants.State.stateAbbreviation[Constants.State.stateFullName.index(of: stateName.uppercased())!]
                }
            }
            return stateName.uppercased()
        }
    }
    
    @IBAction func browseByChemicals(_ sender: Any) {
        
        
        
    }
    
    
    @IBAction func browseByState(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.browseToState, sender: nil)
      

    }
    
    @IBAction func textListening(_ sender: Any) {
        if let count = searchField.text?.characters.count{
            cancelButton.isHidden = false

        }

    }
    
    
    func query(whereString: String, completion: @escaping (_ result: String) -> Void) {
        Facility.sharedInstance.removeAll()
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.facilityURL)!)
        
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
                print("Not Found in error")
                
                print("populateFromServiceWithParameters error :: \(error.localizedDescription)")
            }
            else {
                //the resulting features should be displayed on the map
                //you can print the count of features
                print(result?.featureEnumerator().allObjects.count ?? 0)
                
                for facility in (result?.featureEnumerator().allObjects)!{
                    
                    let name = facility.attributes["fnm"] as! String
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
                    let totalerelt = facility.attributes["totalerelt"] as? Int
                    
                    let totalCur = facility.attributes["tot_current"] as? Int
                    
                    //var objectid = facility?.attribute(forKey: "OBJECTID") as? NSNumber
                    let fac = Facility(number: facilityNumber!, name: name, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                    
                    print(fac.name ?? "no name")
                    Facility.sharedInstance.append(fac)
                    
                    
                        
                    
                }
                Facility.sharedInstance.sort{$0.name! < $1.name!}


                
                print("Not found before completion")
                completion("done with query")
                
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("pressed Enter- did end")

        view.endEditing(true)
    }
    //makes the textfield empty when trying to search again
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchField.text = ""
        //cancelButton.isHidden = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        searchPressed()
        print("pressed Enter- shouldreturn")
        return true
    }

    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.searchToDetail{
            let vc = segue.destination as! DetailViewController
            vc.facilityToDisplay = facility
            
            
        }
    }


    


}

