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

let kMapServiceLayerURL = "https://toxmap.nlm.nih.gov/arcgis/rest/services/toxmap5/vsfs_chemtable/MapServer/0"

class HomeViewController: UIViewController, AGSQueryTaskDelegate, GMSMapViewDelegate {

    var maps: GMSMapView!
    
    //@IBOutlet weak var maps: GMSServices!
    var queryTask:AGSQueryTask!
    var query:AGSQuery!
    var featureSet:AGSFeatureSet!
    var testArray: [String]!
    
    
    var longitudes = [Double]()
    var latitudes = [Double]()
//    var architectNames:[String]!
//    var completedYear:[String]!
    
    var facilities = [Facility]()
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    var matchedWords: [String] = []

    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.query = AGSQuery()
        query.whereClause = "chem_7 > 0"
        
        self.query.outFields = ["*"]
        let countiesLayerURL = kMapServiceLayerURL
        
        self.queryTask = AGSQueryTask(url: URL(string: countiesLayerURL))
        self.queryTask.delegate = self

        //TEST QUERY
       // self.query.text = "SPRINGFIELD"
        self.queryTask.execute(with: self.query)
//        let feature = self.featureSet.features as! AGSGraphic
//        print(feature)//.attributeAsStringForKey("NAME")
        
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //let xPos = UINavigationController. UINavigationBar.frame.size.height
            //.navigationBar.frame.size.height
     
        
        //
//        latitudes = [48.8566667,41.8954656,51.5001524]
//        longitudes = [2.3509871,12.4823243,-0.1262362]
       // architectNames = ["WESTFIELD ELECTROPLATING CO","SOLUTIA INC","SPECIALTY MINERALS INC"]
       // completedYear = ["68 N ELM ST","730 WORCESTER ST","260 COLUMBIA ST"]
        //
        self.maps = GMSMapView(frame: self.view.frame)
        self.view.addSubview(self.maps)
        self.maps.delegate = self
        
        // Add 3 markers
        

        ////mapView.addSubview(tableView)
        view.addSubview(searchTextField)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        tableView.allowsSelection = true
        
        view.addGestureRecognizer(tap)
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
            tableView.isHidden = false
            maps.isHidden = true
        }
        
        tableView.reloadData()
    }
    @IBAction func finishedListening(_ sender: AnyObject) {
        maps.isHidden = false
    }
    func queryTask(_ queryTask: AGSQueryTask!, operation op: Operation!, didExecuteWithObjectIds objectIds: [AnyObject]!) {
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
                //let number = facility?.attribute(forKey: "FRSID") as? NSNumber
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
                let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!)
                
                self.facilities.append(fac)
                
                
                print(item)
            }
            
            for i in 0...(self.facilities.count-1) {
                let coordinates = CLLocationCoordinate2D(latitude: self.facilities[i].latitude as! CLLocationDegrees, longitude: self.facilities[i].longitude as! CLLocationDegrees)
                let marker = GMSMarker(position: coordinates)
                marker.map = self.maps
                marker.icon = UIImage(named: "\(i)")
                marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.2)
                marker.accessibilityLabel = "\(i)"
            }
            let leftBound = CLLocationCoordinate2D(latitude: self.facilities[0].latitude as! CLLocationDegrees, longitude: self.facilities[0].longitude as! CLLocationDegrees)
            let rightBound = CLLocationCoordinate2D(latitude: self.facilities[self.facilities.count-1].latitude as! CLLocationDegrees, longitude: self.facilities[self.facilities.count-1].longitude as! CLLocationDegrees)
           // let calgary = CLLocationCoordinate2D(latitude: self.latitudes[self.latitudes.count-1],longitude: self.longitudes[self.longitudes.count-1])
            let bounds = GMSCoordinateBounds(coordinate: leftBound, coordinate: rightBound)
            let camera = self.maps.camera(for: bounds, insets: UIEdgeInsets())!
            self.maps.animate(toZoom: 2)

           // self.maps.camera = camera
            })

  
        
        //print(featureSet.features[0])
       // print("Fieldname: \(featureSet.displayFieldName)")
    }
    /*
    func loadJson(filename fileName: String) -> [[String: AnyObject]]? {
        print("words")
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            print("sefsef")
            if let data = try? Data(contentsOf: url) {
                print("inside data")
                do {
                    print("inside do")
                    let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("after object")
                    
                    if let dictionary = object as? [[String: AnyObject]] {
                        print("words!!!!!!!")
                        return dictionary
                    }
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        
        return nil
    }
    */
    //if there's an error with the query display it to the user
    func queryTask(_ queryTask: AGSQueryTask!, operation op: Operation!, didFailWithError error: NSError!) {
        UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Ok").show()
    }
    //MARK: GMSMapViewDelegate
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel!)
        
        let customInfoWindow = Bundle.main.loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.address.text = facilities[index].address()// + ", " + facilities[index].city as String? + ", " + facilities[index].state as String? + ", " + facilities[index].zipCode as String?
        customInfoWindow.chemical.text =  facilities[index].number as String?
        customInfoWindow.facilityName.text = facilities[index].name as String?
        return customInfoWindow
    
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
    let searchableColleges: [String] = ["The College of New Jersey","Abilene Christian University","Adelphi University","Agnes Scott College","Aiken Technical College","Air Force Institute of Technology","Air Force Institute of Technology","Alabama A&M University","Alabama State University","Alamo Colleges","Albertson College of Idaho","Albion College","Alfred University","Allegheny College","Allentown College of Saint Francis de Sales","Alma College","Alverno College","Ambassador University","American Coastline University","American International College","American University","Amherst College","Andrews University","Angetelo State University","Anne Arundel Community College","Antioch New England","Antioch University","Antioch University - Los Angeles","Antioch University - Seattle","Appalachian State University","Aquinas College","Arcadia College","Arizona State University","Arizona Western College","Arkansas State University","Arkansas Tech University","Armstrong State College","Ashland University","Assumption College","Auburn University","Auburn University at Montgomery","Augsburg College","Augustana College (IL)","Augustana College (SD)","Augusta University","Augusta University","Aurora University","Austin College","Austin Community College","Austin Peay State University","Averett College","Avila College","Azusa Pacific University","Babson College","Baker University","Baldwin-Wallace College","Ball State University","Baptist Bible College","Bard College","Barry University","Bastyr University"]


}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getMatchingWords(_ searchWord: String) -> [String] {
        let word_to_match = searchWord.lowercased()
        var matching_words: [String] = []
        
        for suggestions in searchableColleges {
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
