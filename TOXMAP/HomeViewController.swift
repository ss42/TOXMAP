//
//  FirstViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import GoogleMaps
import ArcGIS


class HomeViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var topView: UIView!
    var maps: GMSMapView!
    
    //@IBOutlet weak var maps: GMSServices!
    private var featureTable:AGSServiceFeatureTable!

    var featureSet:AGSFeatureSet!
    var testArray: [String]!
    
    
    var longitudes = [Double]()
    var latitudes = [Double]()

    var selectedFacility: Facility?
    
    
    var facilities = [Facility]()
    var sendIndex: Int?
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    var matchedWords: [String] = []

    @IBOutlet weak var searchButton: UIButton!
    
    //let searchableChemicals: [String] = ["Asbestos","Benzene","Chromium compounds(except chromite ore mined in the transvaal region)","Ethylene oxide","Formaldehyde","Lead","Lead Compounds","Mercury","Mercury compounds","Nickel compounds"]
    let searchableChemicals = ChemicalList.chemicalName
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //navigationItem.title = "Home"
        
        
        
        searchTextField.delegate = self

        
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.chemicalURL)!)
       
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        
        
       
        let defaultLocation = GMSCameraPosition.camera(withLatitude: 41.140276,
                                              longitude: -100.760145,
                                              zoom: 3.2)
        self.maps = GMSMapView.map(withFrame: self.view.bounds, camera: defaultLocation)
      
        self.maps = GMSMapView(frame: self.view.frame)
        self.view.addSubview(self.maps)
        self.maps.delegate = self
        self.maps.camera = defaultLocation
        
        // Add 3 markers
        

        ////mapView.addSubview(tableView)
        view.addSubview(topView)
        //view.addSubview(searchButton)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        tableView.allowsSelection = true
        
        self.view.addGestureRecognizer(tap)


            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func begin(){
        // Create a GMSCameraPosition that tells the map to display the
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("viewdidappear")
    }
    
    @IBAction func listen(_ sender: AnyObject) {
        matchedWords = getMatchingWords(searchTextField.text!)
        print("Listening")
        if searchTextField.text == ""{
            print("empty")
            tableView.isHidden = true
        }
        else{
            print("tableview should show")
            view.bringSubview(toFront: tableView)
            tableView.isHidden = false
            //maps.isHidden = true
            view.addSubview(tableView)
        }
        
        tableView.reloadData()
    }
    @IBAction func finishedListening(_ sender: AnyObject) {
        maps.isHidden = false
        maps.clear()
      
    }
    
    @IBAction func search() {
        maps.clear()
        print("finished listening")
        if searchTextField.text != ""{
            let found = chemicalCheck(chemical: searchTextField.text!)
            print(found)
            if found.characters.count > 2{
                print("quering")
                queryForState(chemical: found)
                
            }
        }
        else{
            showError("Nothing to search", message: "Enter chemical name to search.")
        }
    }
    
    func chemicalCheck(chemical: String)-> String {
        var result: String?
        for i in 0...(searchableChemicals.count-1){
            
            if searchableChemicals[i] == chemical{
                result = "chem_" + "\(i + 1)" + " > 0"
                return result!
            }
            else{
                result = ""
                showError("NOT FOUND", message: "Chemical is not in the list")
                //show error result not found
            }
        }
        
        return result!
    }
        func queryForState(chemical: String) {

        let queryParams = AGSQueryParameters()
        queryParams.whereClause = chemical

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

                    let totalerelt = facility.attributes["TOTALERELT"] as? NSNumber
                    print(totalerelt)
                    let totalCur = facility.attributes["TOT_CURRENT"] as? NSNumber

                    let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                    
                    self.facilities.append(fac)
                    Facility.sharedInstance.append(fac)

                    
                }
                
                print(result?.featureEnumerator().allObjects.count ?? 00)
                print("printing count")
            }
            if self.facilities.count > 1{
                for i in 0...(self.facilities.count-1) {
                    let coordinates = CLLocationCoordinate2D(latitude: self.facilities[i].latitude as! CLLocationDegrees, longitude: self.facilities[i].longitude as! CLLocationDegrees)
                    let marker = GMSMarker(position: coordinates)
                    marker.map = self.maps
                    marker.icon = UIImage(named: "\(i)")
                    marker.userData = i
                    marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                    marker.accessibilityLabel = "\(i)"
                }
                let leftBound = CLLocationCoordinate2D(latitude: self.facilities[0].latitude as! CLLocationDegrees, longitude: self.facilities[0].longitude as! CLLocationDegrees)
                let rightBound = CLLocationCoordinate2D(latitude: self.facilities[self.facilities.count-1].latitude as! CLLocationDegrees, longitude: self.facilities[self.facilities.count-1].longitude as! CLLocationDegrees)
                // let calgary = CLLocationCoordinate2D(latitude: self.latitudes[self.latitudes.count-1],longitude: self.longitudes[self.longitudes.count-1])
                let bounds = GMSCoordinateBounds(coordinate: leftBound, coordinate: rightBound)
                let camera = self.maps.camera(for: bounds, insets: UIEdgeInsets())!
                self.maps.animate(toZoom: 6)
                self.maps.camera = GMSCameraPosition.camera(withTarget: leftBound, zoom: 14)
                
                
                self.maps.camera = camera
            }

        }

        
    }

    
    /*
    //if there's an error with the query display it to the user
    private func queryTask(_ queryTask: AGSQueryTask!, operation op: Operation!, didFailWithError error: NSError!) {
        
        //show error
        //UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Ok").show()
    }*/
    
    //MARK: GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel!)
        
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.address.text = facilities[index].address()// + ", " + facilities[index].city as String? + ", " + facilities[index].state as String? + ", " + facilities[index].zipCode as String?
        customInfoWindow.chemical.text =  facilities[index].number as String?
        customInfoWindow.facilityName.text = facilities[index].name as String?
        self.maps.bringSubview(toFront: customInfoWindow)
        return customInfoWindow
    
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("moredetails")
        //Optional Alert
        sendIndex = (marker.userData) as! Int!
        print(sendIndex!)
        self.selectedFacility = facilities[sendIndex!]
        //UserDefaults.standard.setValue(self.selectedFacility, forKey: "facility")
        performSegue(withIdentifier: "markerToDetail", sender: nil)
    }
    
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == "markerToDetail"{
            let vc = segue.destination as! DetailViewController
            
    
            vc.facilityToDisplay = selectedFacility
    
            //self.present(vc, animated: true, completion: nil)
            print("going to detail view")
        }
    }




}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getMatchingWords(_ searchWord: String) -> [String] {
        let word_to_match = searchWord.lowercased()
        var matching_words: [String] = []
        
        for suggestions in searchableChemicals {
            let lower = suggestions.lowercased()
            if lower.lowercased().range(of: word_to_match) != nil{
                matching_words.append(suggestions)
            }
        }
        
        return matching_words
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        cell.textLabel!.text = matchedWords[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(matchedWords[indexPath.row])
        searchTextField.text = matchedWords[indexPath.row]
        tableView.isHidden = true
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}
extension HomeViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        search()
        print("pressed Enter- shouldreturn")
        return true
    }
    
    

    func showError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "markerToDetail"{
//            let vc = segue.destination as! DetailViewController
//            print("sent")
//
//            vc.index = self.sendIndex
//
//            self.present(vc, animated: true, completion: nil)
//            print("going to detail view")
//        }
//    }





/*
 private func queryTask(_ queryTask: AGSQueryTask!, operation op: Operation!, didExecuteWithObjectIds objectIds: [AnyObject]!) {
 print("Hellow world")
 print("object ids")
 print(objectIds)
 }
 
 func queryTask(_ queryTask: AGSQueryTask!, operation op: Operation!, didExecuteWithFeatureSetResult featureSet: AGSFeatureSet!) {
 print(" world")
 //get feature, and load in to table
 self.featureSet = featureSet
 // var facilities = [AGSGraphic]()
 DispatchQueue.main.async(execute: {
 for item in featureSet.features{
 //facilities.append(item as! AGSGraphic)
 print(item)
 let facility = item as? AGSGraphic
 
 let name = facility?.attribute(forKey: "FNM") as? NSString
 let facilityNumber = facility?.attribute(forKey: "FACN") as? NSString
 let street = facility?.attribute(forKey: "FAD") as? NSString
 let countyName = facility?.attribute(forKey: "FCO") as? NSString
 let city = facility?.attribute(forKey: "FCTY") as? NSString
 let state = facility?.attribute(forKey: "FST") as? NSString
 let zipcode = facility?.attribute(forKey: "FZIP") as? NSString
 let facitlityID = facility?.attribute(forKey: "FRSID") as? NSString
 let long = facility?.attribute(forKey: "LONGD") as? NSNumber
 // long = CLLocationDegrees(long!)
 let lat = facility?.attribute(forKey: "LATD") as? NSNumber
 //lat = CLLocationDegrees(lat!)
 //self.longitudes.append(long as! Double)
 //self.latitudes.append(lat as! Double)
 let totalerelt = facility?.attribute(forKey: "TOTALERELT") as? NSNumber
 print(totalerelt)
 let totalCur = facility?.attribute(forKey: "TOT_CURRENT") as? NSNumber
 print(totalCur)
 //var objectid = facility?.attribute(forKey: "OBJECTID") as? NSNumber
 let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
 
 self.facilities.append(fac)
 Facility.sharedInstance.append(fac)
 
 
 print(item)
 }
 if self.facilities.count > 1{
 for i in 0...(self.facilities.count-1) {
 let coordinates = CLLocationCoordinate2D(latitude: self.facilities[i].latitude as! CLLocationDegrees, longitude: self.facilities[i].longitude as! CLLocationDegrees)
 let marker = GMSMarker(position: coordinates)
 marker.map = self.maps
 marker.icon = UIImage(named: "\(i)")
 marker.userData = i
 marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
 marker.accessibilityLabel = "\(i)"
 }
 let leftBound = CLLocationCoordinate2D(latitude: self.facilities[0].latitude as! CLLocationDegrees, longitude: self.facilities[0].longitude as! CLLocationDegrees)
 let rightBound = CLLocationCoordinate2D(latitude: self.facilities[self.facilities.count-1].latitude as! CLLocationDegrees, longitude: self.facilities[self.facilities.count-1].longitude as! CLLocationDegrees)
 // let calgary = CLLocationCoordinate2D(latitude: self.latitudes[self.latitudes.count-1],longitude: self.longitudes[self.longitudes.count-1])
 let bounds = GMSCoordinateBounds(coordinate: leftBound, coordinate: rightBound)
 let camera = self.maps.camera(for: bounds, insets: UIEdgeInsets())!
 self.maps.animate(toZoom: 6)
 self.maps.camera = GMSCameraPosition.camera(withTarget: leftBound, zoom: 2)
 
 
 self.maps.camera = camera
 }
 })
 //        self.featureTable.queryFeatures(with: queryParams, fields: .loadAll){ result, error in
 //            if let error = error {
 //                print(error.localizedDescription)
 //                //update selected features array
 //                self.selectedFeatures.removeAll(keepingCapacity: false)
 //            }
 //            else if let features = result?.featureEnumerator().allObjects {
 //                if features.count > 0 {
 //                    self.featureLayer.select(features)
 //                    //zoom to the selected feature
 //                    print("features")
 //                    print(features)
 //                }
 //                else {
 //                    //Show error
 //                    // SVProgressHUD.showErrorWithStatus("No state by that name", maskType: .Gradient)
 //                }
 //                //update selected features array
 //                self.selectedFeatures = features
 //            }
 //        }
 
 
 }*/

