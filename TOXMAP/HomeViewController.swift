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
    private var featureTable:AGSServiceFeatureTable!
    var featureSet:AGSFeatureSet!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var listChemicalButton: UIButton!
    var selectedFacility: Facility?
    var sendIndex: Int?
    var stateVsChemicalTable = true
    var chemicalIndex: Int?
    var chemicalSelected = ""
    @IBOutlet weak var stateShowButton: UIButton!
    var tableView = UITableView()
    @IBOutlet weak var searchTextField: UITextField!
    var matchedWords: [String] = []
    @IBOutlet weak var searchButton: UIButton!
    let searchableChemicals = Chemical.chemicalName
    var flag = 1   //Used to monitor multiple clicks to show and hide tableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
        stateShowButton.contentMode = .scaleAspectFit
        listChemicalButton.contentMode = .scaleAspectFit
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
        
 
        tableView.frame = CGRect(x: stateTextField.frame.origin.x, y: stateTextField.frame.origin.y, width: stateTextField.frame.width, height: 100)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        view.addSubview(topView)

        //Tap Guesture
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissTable))
        tap.numberOfTapsRequired = 1
        tap.cancelsTouchesInView = false
        let tap1: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTable))
        tap1.numberOfTapsRequired = 1
        tap1.cancelsTouchesInView = false
        tableView.allowsSelection = true
        self.stateShowButton.addGestureRecognizer(tap1)

        self.topView.addGestureRecognizer(tap)
        

        tableView.bounces = false



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

    }
    func dismissTable(){
        dismissKeyboard()
        tableView.isHidden = true
    }
    /**
     Show State menu on click/TAP
     -Function from selector for gesturerecognizer, shows and hides tableview
     
     - parameter bar: Listen to gesture recognizer
     - returns:
     */
    func showTable(){
        if flag == 0{
            UIView.animate(withDuration: 0.5){
                self.tableView.frame = CGRect(x: self.stateTextField.frame.origin.x, y: self.stateTextField.frame.origin.y + self.stateTextField.frame.height, width: self.stateTextField.frame.width + self.stateShowButton.frame.width, height: 0)
                self.tableView.isHidden = true
                self.flag = 1
            }
        }else{
            UIView.animate(withDuration: 0.5){
                self.matchedWords = Constants.State.menuState
                self.tableView.frame = CGRect(x: self.stateTextField.frame.origin.x, y: self.stateTextField.frame.origin.y + self.stateTextField.frame.height, width: self.stateTextField.frame.width + self.stateShowButton.frame.width, height: self.view.frame.height - 200)
                self.tableView.isHidden = false
                //view.bringSubview(toFront: stateview)
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
                self.flag = 0
                
            }
        }
    }
    /**
     Show Chemical menu on click/TAP
     shows and hides tableview
     
     - parameter bar: Listens to click
     - returns:
     */

    @IBAction func showListofChemicalButtonPressed() {
        if flag == 0{
            UIView.animate(withDuration: 0.5){
                self.tableView.frame = CGRect(x: self.searchTextField.frame.origin.x, y: self.searchTextField.frame.origin.y + self.searchTextField.frame.height, width: self.searchTextField.frame.width + self.stateShowButton.frame.width, height: 0)
                self.tableView.isHidden = true
                self.flag = 1
            }
        }else{
            UIView.animate(withDuration: 0.5){
                self.matchedWords = self.searchableChemicals
                self.tableView.frame = CGRect(x: self.searchTextField.frame.origin.x, y: self.searchTextField.frame.origin.y + self.searchTextField.frame.height, width: self.searchTextField.frame.width + self.stateShowButton.frame.width, height: self.view.frame.height - 200)
                self.tableView.isHidden = false
                //view.bringSubview(toFront: stateview)
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
                self.flag = 0
                
            }
        }
  
    }
    /**
     Monitor for chemical search textfield to help for autocorrect
     
     - parameter bar: UITextfield
     - returns:
     */
    @IBAction func listenChemicalTyping(_ sender: AnyObject) {
        matchedWords = searchableChemicals
        matchedWords = getMatchingWords(searchTextField.text!)
        print("Listening")
        if searchTextField.text == ""{
            tableView.isHidden = true
        }
        else{
            UIView.animate(withDuration: 0.5){
                self.tableView.frame = CGRect(x: self.searchTextField.frame.origin.x, y: self.searchTextField.frame.origin.y + self.searchTextField.frame.height, width: self.searchTextField.frame.width + self.stateShowButton.frame.width, height: self.view.frame.height - 200)
                self.tableView.isHidden = false
                //view.bringSubview(toFront: stateview)
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
                self.flag = 0
                
            }
            
        }
        
        tableView.reloadData()
    }
    

    @IBAction func stateButtonPressed(_ sender: Any) {
    }
    
  
    /**
     Search chemicals Button- send query and show error if no result
     
     - parameter bar:
     
     - returns:
     */
    @IBAction func search() {
        maps.clear()
        print("finished listening")
        if searchTextField.text != ""{
            if let found = whereText(chemical: (searchTextField.text?.capitalizingFirstLetter())!){
                DispatchQueue.global(qos: .utility).async { // 1
                    self.query(whereString: found){(result: String) in
                        print(result)
                        SVProgressHUD.dismiss()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        if Facility.searchInstance.count != 0{
                            DispatchQueue.main.async {
                                self.addMarker(facilities: Facility.searchInstance)
                            }
                        }
                        else {  DispatchQueue.main.async {
                                self.showError("\(self.searchTextField.text!) not found", message: "Please try with another chemical")
                            }}}}}
            else{
                self.showError("\(self.searchTextField.text!) not found", message: "Please try with another chemical")
            }}
        else{
            //showError("Nothing to search", message: "Enter chemical name to search.")
        }
    }
    /**
     Where text to send to the query
     
     - parameter bar: the name of the chemical
     
     - returns: actual where text to be sent to the URL
     */
    func whereText(chemical: String)-> String? {
        var result: String?
        if chemicalIndex != nil || chemical.characters.count > 1{
            let chemIndex = Chemical.chemicalName.index(of: chemical)
            let chem = Chemical.chemicalAlias[chemIndex!]
            chemicalSelected = chem
            result = "\(chem)" + " > 0"
            if stateTextField.text == "ALL STATES"{
                return result
            }else if (stateTextField.text?.characters.count)! > 1{
                let stateIndex = Constants.State.menuState.index(of: stateTextField.text!)
                let stateAlias = Constants.State.stateAbbreviation[stateIndex! - 1]
                result = "fst='\(stateAlias)' and " + result!
            }
        }
        return result
    }
    
    /**
     Query chemicals to the URL
     
     - parameter bar: wheretext - The actual input text to search
     
     - returns: completion handler and fills Facility  Search Shared instance
     */
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
                print("populateFromServiceWithParameters error :: \(error.localizedDescription)")
            }
            else {
                for facility in (result?.featureEnumerator().allObjects)!{
                    print(result?.featureEnumerator())
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
                    Facility.searchInstance.append(fac)
                }
                completion("done with query")
                
            }
        }
    }
    /**
     Add maps marker on screen
     
     - parameter bar: Array of Facility
     
     - returns:
     */
    func addMarker(facilities: [Facility]){
        if facilities.count != 0{
            for i in 0..<facilities.count {
                let coordinates = CLLocationCoordinate2D(latitude: Facility.searchInstance[i].latitude as! CLLocationDegrees, longitude: Facility.searchInstance[i].longitude as! CLLocationDegrees)
                let marker = GMSMarker(position: coordinates)
                marker.map = self.maps
                marker.icon = UIImage(named: "bluemarker") //custom marker
                marker.userData = i
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 5)
                marker.accessibilityLabel = "\(i)"
                marker.tracksInfoWindowChanges = true
                marker.isFlat = true
            }
            let leftBound = CLLocationCoordinate2D(latitude: facilities[0].latitude as! CLLocationDegrees, longitude: facilities[0].longitude as! CLLocationDegrees)
            let rightBound = CLLocationCoordinate2D(latitude: facilities[facilities.count-1].latitude as! CLLocationDegrees, longitude: facilities[facilities.count-1].longitude as! CLLocationDegrees)
            let bounds = GMSCoordinateBounds(coordinate: leftBound, coordinate: rightBound)
            let camera = self.maps.camera(for: bounds, insets: UIEdgeInsets())!
            self.maps.animate(toZoom: 5)
            self.maps.camera = GMSCameraPosition.camera(withTarget: leftBound, zoom: 14)
            self.maps.camera = camera
        }
        
    }
    /**
     PopUP Window for marker
     
     - parameter bar: map
     
     - returns: pop up window which is the CustomInfoWindo.xib
     */    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel!)

        
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.address.text = Facility.searchInstance[index].address()// + ", " + facilities[index].city as String? + ", " + facilities[index].state as String? + ", " + facilities[index].zipCode as String?
        customInfoWindow.chemicalName.text = searchTextField.text?.capitalized
        customInfoWindow.facilityName.text = Facility.searchInstance[index].name as String?
        customInfoWindow.TRIYearTitle.text = "TRI Year " + Constants.TRIYear
        customInfoWindow.TotalChemicalReleaseYear.text = "Total Release Amount(\(Constants.TRIYear))"
        customInfoWindow.chemicalAmount.text = (Facility.searchInstance[index].chemical?["amount"])!  + " pounds"
        mapView.backgroundColor = UIColor.black
        UIView.animate(withDuration: 0.5){
            self.maps.bringSubview(toFront: customInfoWindow)

        }
        return customInfoWindow
    
    }
    /**
    Marker Tap monitor
     - parameter bar: mapView
     
     - returns:
     */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
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
    /**
     Overide Segue to send facility to next view controller
     
     - parameter bar: seque name
     
     - returns:
     */
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
    func caretRect(for position: UITextPosition) -> CGRect{
        return CGRect.zero
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = matchedWords[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if matchedWords.count > 75{
            searchTextField.text = matchedWords[indexPath.row]
            chemicalIndex = indexPath.row as Int
            tableView.isHidden = true

        }
        else{
            stateTextField.text = Constants.State.menuState[indexPath.row]
            tableView.isHidden = true
        }

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
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        maps.isHidden = false
        maps.clear()
    }
    
    

    func showError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {  (alert:UIAlertAction) -> Void in
            self.tableView.isHidden = true
            self.searchTextField.text = ""
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
