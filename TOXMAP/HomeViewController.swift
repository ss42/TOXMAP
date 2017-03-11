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
import SVProgressHUD


class HomeViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet weak var topView: UIView!
    var maps: GMSMapView!
    
    //@IBOutlet weak var maps: GMSServices!
    private var featureTable:AGSServiceFeatureTable!

    var featureSet:AGSFeatureSet!
    var testArray: [String]!
    
    
    var longitudes = [Double]()
    var latitudes = [Double]()

    @IBOutlet weak var listChemicalButton: UIButton!
    var selectedFacility: Facility?
    
    
   // var facilities = [Facility]()
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
       // maps.delegate = self
        
       

        //navigationItem.title = "Home"
        
        listChemicalButton.imageView?.contentMode = .scaleAspectFill
        
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
    
    @IBAction func showListofChemicalButtonPressed(_ sender: Any) {
        print("show list")
        matchedWords = searchableChemicals

        view.bringSubview(toFront: tableView)

        tableView.isHidden = false
        view.addSubview(tableView)

        tableView.reloadData()
        print(matchedWords[0])
        
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
            if let found = chemicalCheck(chemical: (searchTextField.text?.capitalizingFirstLetter())!){
                self.query(whereString: found){(result: String) in
                    print(result)
                    SVProgressHUD.dismiss()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if Facility.searchInstance.count != 0{
                        //call the marker func
                        DispatchQueue.main.async {
                            
                            self.addMarker(facilities: Facility.searchInstance)
                        }
                    }
                    else {
                        
                        DispatchQueue.main.async {
                            self.showError("\(self.searchTextField.text!) not found", message: "Please try with another keyword")
                        }
                    }
                    
                    
                }

            }
            else{
                self.showError("\(self.searchTextField.text!) not found", message: "Please try with another keyword")
                tableView.isHidden = true

            }
      
        }
        else{
            //showError("Nothing to search", message: "Enter chemical name to search.")
        }
    }
    var chemicalHelper: Int?
    func chemicalCheck(chemical: String)-> String? {
        var result: String?
        for i in 0...(searchableChemicals.count-1){
            
            if searchableChemicals[i] == chemical{
                
                result = "chem_" + "\(i + 1)" + " > 0"
                chemicalHelper = i + 1
                return result
            }
            else{
                result = ""
                //showError("NOT FOUND", message: "Chemical is not in the list")
                //show error result not found
            }
        }
        
        return result
    }
    func query(whereString: String, completion: @escaping (_ result: String) -> Void) {
        Facility.searchInstance.removeAll()
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
                print("Not Found in error")
                
                print("populateFromServiceWithParameters error :: \(error.localizedDescription)")
            }
            else {
                //the resulting features should be displayed on the map
                //you can print the count of features
                print(result?.featureEnumerator().allObjects.count ?? 0)
                
                for facility in (result?.featureEnumerator().allObjects)!{
                    
                    let name = facility.attributes["FNM"] as? String
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
                    
                    let totalerelt = facility.attributes["TOTALERELT"] as? Int
                    let totalCur = facility.attributes["TOT_CURRENT"] as? Int
                    let chemKey = "CHEM_" + "\(self.chemicalHelper!)"
                    let chemicalAmount = facility.attributes[chemKey] as? Int
                    let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!,  chemicalAmount: chemicalAmount!)
                    
                   // let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!, chemicalAmount: chemicalAmount!)
                    
                    print(fac.name ?? "no name")
                    Facility.searchInstance.append(fac)
                    
                    
                    
                    
                }
                
                
                print("Not found before completion")
                completion("done with query")
                
            }
        }
    }
    func addMarker(facilities: [Facility]){
        if facilities.count != 0{
            for i in 0..<facilities.count {
                let coordinates = CLLocationCoordinate2D(latitude: Facility.searchInstance[i].latitude as! CLLocationDegrees, longitude: Facility.searchInstance[i].longitude as! CLLocationDegrees)
                let marker = GMSMarker(position: coordinates)
                marker.map = self.maps
                marker.icon = UIImage(named: "bluemarker") //custom marker
                marker.userData = i
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 2)
                marker.accessibilityLabel = "\(i)"
                marker.tracksInfoWindowChanges = true
                marker.isFlat = true
            }
            let leftBound = CLLocationCoordinate2D(latitude: facilities[0].latitude as! CLLocationDegrees, longitude: facilities[0].longitude as! CLLocationDegrees)
            let rightBound = CLLocationCoordinate2D(latitude: facilities[facilities.count-1].latitude as! CLLocationDegrees, longitude: facilities[facilities.count-1].longitude as! CLLocationDegrees)
            // let calgary = CLLocationCoordinate2D(latitude: self.latitudes[self.latitudes.count-1],longitude: self.longitudes[self.longitudes.count-1])
            let bounds = GMSCoordinateBounds(coordinate: leftBound, coordinate: rightBound)
            let camera = self.maps.camera(for: bounds, insets: UIEdgeInsets())!
            self.maps.animate(toZoom: 6)
            self.maps.camera = GMSCameraPosition.camera(withTarget: leftBound, zoom: 14)
            
            
            self.maps.camera = camera
        }
        

    }
     //MARK: GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel!)

        
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.address.text = Facility.searchInstance[index].address()// + ", " + facilities[index].city as String? + ", " + facilities[index].state as String? + ", " + facilities[index].zipCode as String?
        customInfoWindow.chemicalName.text = searchTextField.text?.capitalized
        customInfoWindow.facilityName.text = Facility.searchInstance[index].name as String?
        customInfoWindow.moreDetails()
        customInfoWindow.chemicalAmount.text = String(describing: Facility.searchInstance[index].chemicalAmount!) + " pounds"
        mapView.backgroundColor = UIColor.black

        self.maps.bringSubview(toFront: customInfoWindow)
        return customInfoWindow
    
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("moredetails")
        
        //CustomInfoWindow.moreDetails()
        //moreDetail.sendActionsForControlEvents(.TouchUpInside)

        //Optional Alert
        if let index = marker.userData{
            sendIndex = index as? Int
        }
        if (sendIndex != nil){
            self.selectedFacility = Facility.searchInstance[sendIndex!]
            performSegue(withIdentifier: Constants.Segues.homeToDetail, sender: nil)

        }
        

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
    
        if segue.identifier == Constants.Segues.homeToDetail{
            let vc = segue.destination as! DetailViewController
            
    
            vc.facilityToDisplay = selectedFacility

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
        let action = UIAlertAction(title: "Ok", style: .default, handler: {  (alert:UIAlertAction) -> Void in
            self.tableView.isHidden = true
            print("tableview hiding")
            self.searchTextField.text = ""
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
