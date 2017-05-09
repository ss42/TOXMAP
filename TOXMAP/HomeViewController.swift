//
//  FirstViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)

import UIKit
import GoogleMaps
import ArcGIS
import SVProgressHUD
import SystemConfiguration


class HomeViewController: UIViewController, GMSMapViewDelegate {

//    IBOutlets
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var listChemicalButton: UIButton!
    @IBOutlet weak var stateShowButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    private var featureTable:AGSServiceFeatureTable!
    
    
    var matchedWords: [String] = []
    var maps: GMSMapView!
    var tableView = UITableView()
    var featureSet:AGSFeatureSet!
    var selectedFacility: Facility?
    var sendIndex: Int?
    var stateVsChemicalTable = true
    var chemicalIndex: Int?
    var chemicalSelected = ""
    let searchableChemicals = Chemical.chemicalName
    var flag = 1   //Used to monitor multiple clicks to show and hide tableView
    var chemicalTableOn: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        stateShowButton.contentMode = .scaleAspectFit
        listChemicalButton.contentMode = .scaleAspectFit
        setDefaultLocation()
        addTableView()
        view.addSubview(tableView)
        view.addSubview(topView)
        addTapGesture()

    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Facility.sharedInstance.removeAll()

    }
    
    //MARK: Set Default location for camera and map's first view
    func setDefaultLocation(){
        let defaultLocation = GMSCameraPosition.camera(withLatitude: 41.140276,
                                                       longitude: -100.760145,
                                                       zoom: 3.2)
        self.maps = GMSMapView.map(withFrame: self.view.bounds, camera: defaultLocation)
        self.maps = GMSMapView(frame: self.view.frame)
        self.view.addSubview(self.maps)
        self.maps.delegate = self
        self.maps.camera = defaultLocation

    }
    //MARK: Chem table
    func addTableView(){
        tableView.frame = CGRect(x: stateTextField.frame.origin.x, y: stateTextField.frame.origin.y, width: stateTextField.frame.width, height: 100)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.bounces = false

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func addTapGesture(){
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
    }
    
    
    func dismissTable(){
        dismissKeyboard()
        tableView.isHidden = true
    }
 
    /**
     Monitor for chemical search textfield to help for autocorrect
     
     - parameter bar: UITextfield
     - returns:
     */
    @IBAction func listenChemicalTyping(_ sender: AnyObject) {
        matchedWords = searchableChemicals
        matchedWords = getMatchingWords(searchTextField.text!)
        chemicalTableOn = true
        if searchTextField.text == ""{
            tableView.isHidden = true
        }
        else{
            UIView.animate(withDuration: 0.5){
                self.tableView.frame = CGRect(x: self.searchTextField.frame.origin.x, y: self.searchTextField.frame.origin.y + self.searchTextField.frame.height, width: self.searchTextField.frame.width + self.stateShowButton.frame.width, height: self.view.frame.height - 200)
                self.tableView.isHidden = false
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
        tableView.isHidden = true
        let manager = ArcGISManager()
        if searchTextField.text != ""{
            let searchWord = whereText(chemical: (searchTextField.text)!)
            if searchWord != "" && manager.isInternetAvailable(){
                if let found = searchWord{
                    DispatchQueue.global(qos: .userInitiated).async { // 1
                        manager.query(whereString: found, url: ArcGISURLType.chemicalURL.rawValue, chemicalSearch: true){(result: String) in
                        if Facility.sharedInstance.count != 0{
                            DispatchQueue.main.async {
                                self.addMarker(facilities: Facility.sharedInstance)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                            if self.stateTextField.text == "All States"{
                                self.showError("\(self.searchTextField.text!) not found", message: "Please try with another chemical.")
                            }else {
                                self.showError("\(self.searchTextField.text!) not found", message: "Please try with another chemical or state.")
                            }
                            }}}}}
                else{
                    self.showError("\(self.searchTextField.text!) not found", message: "Please try with another chemical or state")
                }
            }else{ if !manager.isInternetAvailable(){
                self.showError("No Internet Connection", message: "Please try after the internet connection is back.")
                }
                self.showError("\(self.searchTextField.text!) not found", message: "Please try with another chemical or state")
                
            }
        }
    }
    /**
     Where text to send to the query
     
     - parameter bar: the name of the chemical
     
     - returns: actual where text to be sent to the URL
     */
    func whereText(chemical: String)-> String? {
        var result: String?
        if chemical.characters.count > 1{
            let checkIndex = chemical.uppercased()
                if let chemIndex = Chemical.chemicalName.index(of: checkIndex){
                let chem = Chemical.chemicalAlias[chemIndex]
                Chemical.shared.alias = chem
                Chemical.shared.chemicalName = Chemical.chemicalName[chemIndex]
                UserDefaults.standard.set(chem, forKey: "chemSelected")
                chemicalSelected = chem
                result = "\(chem)" + " > 0"
                if stateTextField.text == "All States"{
                    return result
                }else if (stateTextField.text?.characters.count)! > 1{
                    let stateIndex = Constants.State.menuState.index(of: stateTextField.text!.uppercased())
                    let stateAlias = Constants.State.stateAbbreviation[stateIndex! - 1]
                    result = "fst='\(stateAlias)' and " + result!
                }
            }else{
                return ""
            }
        }else{
            return ""
        }
        return result
    }

    /**
     Add maps marker on screen
     
     - parameter bar: Array of Facility
     
     - returns:
     */
    func addMarker(facilities: [Facility]){
        if facilities.count != 0{
            for i in 0..<facilities.count {
                let coordinates = CLLocationCoordinate2D(latitude: Facility.sharedInstance[i].latitude as! CLLocationDegrees, longitude: Facility.sharedInstance[i].longitude as! CLLocationDegrees)
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
     */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel!)

        
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.address.text = Facility.sharedInstance[index].address()// + ", " + facilities[index].city as String? + ", " + facilities[index].state as String? + ", " + facilities[index].zipCode as String?
        customInfoWindow.chemicalName.text = searchTextField.text?.capitalized
        customInfoWindow.facilityName.text = Facility.sharedInstance[index].name as String?
        customInfoWindow.TRIYearTitle.text = "TRI Year " + Constants.TRIYear
        customInfoWindow.TotalChemicalReleaseYear.text = "On-site release (\(Constants.TRIYear)):"
        //let amount = Int((Facility.searchInstance[index].chemical?["amount"])!)
        let amount = Int((Facility.sharedInstance[index].chemical?.chemicalAmount)!)
        let formatedAmount = amount.addFormatting(number: amount)
        customInfoWindow.chemicalAmount.text = formatedAmount  + " pounds"
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
            self.selectedFacility = Facility.sharedInstance[sendIndex!]
            performSegue(withIdentifier: Constants.Segues.homeToDetail, sender: nil)
        }
    }
 
    
    func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
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
    /**
     Show State menu on click/TAP
     -Function from selector for gesturerecognizer, shows and hides tableview
     
     - parameter bar: Listen to gesture recognizer
     - returns:
     */
    func showTable(){
        chemicalTableOn = false
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
            chemicalTableOn = false
            UIView.animate(withDuration: 0.5){
                self.tableView.frame = CGRect(x: self.searchTextField.frame.origin.x, y: self.searchTextField.frame.origin.y + self.searchTextField.frame.height, width: self.searchTextField.frame.width + self.stateShowButton.frame.width, height: 0)
                self.tableView.isHidden = true
                self.flag = 1
            }
        }else{
            chemicalTableOn = true
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
        cell.textLabel!.text = matchedWords[indexPath.row].capitalized
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if chemicalTableOn!{
            searchTextField.text = matchedWords[indexPath.row].capitalized
            chemicalIndex = indexPath.row as Int
            tableView.isHidden = true

        }
        else{
            stateTextField.text = Constants.State.menuState[indexPath.row].capitalized
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
    
    

    override func showError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: {  (alert:UIAlertAction) -> Void in
            self.tableView.isHidden = true

        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
