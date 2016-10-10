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
    
    
    var longitudes:[Double]!
    var latitudes:[Double]!
    var architectNames:[String]!
    var completedYear:[String]!
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var searchTextField: UITextField!
    var matchedWords: [String] = []

    
     let searchableColleges: [String] = ["The College of New Jersey","Abilene Christian University","Adelphi University","Agnes Scott College","Aiken Technical College","Air Force Institute of Technology","Air Force Institute of Technology","Alabama A&M University","Alabama State University","Alamo Colleges","Albertson College of Idaho","Albion College","Alfred University","Allegheny College","Allentown College of Saint Francis de Sales","Alma College","Alverno College","Ambassador University","American Coastline University","American International College","American University","Amherst College","Andrews University","Angetelo State University","Anne Arundel Community College","Antioch New England","Antioch University","Antioch University - Los Angeles","Antioch University - Seattle","Appalachian State University","Aquinas College","Arcadia College","Arizona State University","Arizona Western College","Arkansas State University","Arkansas Tech University","Armstrong State College","Ashland University","Assumption College","Auburn University","Auburn University at Montgomery","Augsburg College","Augustana College (IL)","Augustana College (SD)","Augusta University","Augusta University","Aurora University","Austin College","Austin Community College","Austin Peay State University","Averett College","Avila College","Azusa Pacific University","Babson College","Baker University","Baldwin-Wallace College","Ball State University","Baptist Bible College","Bard College","Barry University","Bastyr University"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.query = AGSQuery()
        query.whereClause = "chem_7 > 0"
        
        self.query.outFields = ["*"]
        let countiesLayerURL = kMapServiceLayerURL
        
        self.queryTask = AGSQueryTask(URL: NSURL(string: countiesLayerURL))
        self.queryTask.delegate = self

        //TEST QUERY
       // self.query.text = "SPRINGFIELD"
        self.queryTask.executeWithQuery(self.query)
//        let feature = self.featureSet.features as! AGSGraphic
//        print(feature)//.attributeAsStringForKey("NAME")
        
        
        // Get main screen bounds
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //let xPos = UINavigationController. UINavigationBar.frame.size.height
            //.navigationBar.frame.size.height
     
        
        //
        latitudes = [48.8566667,41.8954656,51.5001524]
        longitudes = [2.3509871,12.4823243,-0.1262362]
        architectNames = ["Stephen Sauvestre","Bonanno Pisano","Augustus Pugin"]
        completedYear = ["1889","1372","1859"]
        //
        self.maps = GMSMapView(frame: self.view.frame)
        self.view.addSubview(self.maps)
        self.maps.delegate = self
        
        // Add 3 markers
        for i in 0...2 {
            let coordinates = CLLocationCoordinate2D(latitude: latitudes[i], longitude: longitudes[i])
            let marker = GMSMarker(position: coordinates)
            marker.map = self.maps
            marker.icon = UIImage(named: "\(i)")
            marker.infoWindowAnchor = CGPointMake(0.5, 0.2)
            marker.accessibilityLabel = "\(i)"
        }

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
    override func viewDidAppear(animated: Bool) {
//        let feature = self.featureSet.features[0] as! AGSGraphic
//        var x = feature.attributeAsStringForKey("FCTY") //The display field name for the service we are using
//        print(x)
        print("viewdidappear")
    }
    
    @IBAction func listen(sender: AnyObject) {
        matchedWords = getMatchingWords(searchTextField.text!)
        print("Listening")
        if searchTextField.text == ""{
            print("empty")
            tableView.hidden = true
        }
        else{
            print("tableview should show")
            tableView.hidden = false
            maps.hidden = true
        }
        
        tableView.reloadData()
    }
    @IBAction func finishedListening(sender: AnyObject) {
        maps.hidden = false
    }
    func queryTask(queryTask: AGSQueryTask!, operation op: NSOperation!, didExecuteWithObjectIds objectIds: [AnyObject]!) {
        print("Hellow world")
        print("object ids")
        print(objectIds)
    }
    
    func queryTask(queryTask: AGSQueryTask!, operation op: NSOperation!, didExecuteWithFeatureSetResult featureSet: AGSFeatureSet!) {
        print(" world")
        //get feature, and load in to table
        self.featureSet = featureSet
        for item in featureSet.features{
           // convertStringToDictionary(item as! String)
            print(item)
        }
        //print(featureSet.features[0])
        print("Fieldname: \(featureSet.displayFieldName)")
    }
    
//    func queryTask(queryTask: AGSQueryTask!, operation op: NSOperation!, didExecuteWithRelatedFeatures relatedFeatures: [NSObject : AnyObject]!) {
//        print("Hellow world")
//        //The valve for which you are finding related features
//        let valveID = 0
//        
//        let results = relatedFeatures[valveID] as! AGSFeatureSet
//        
//        for graphic in results.features as! [AGSGraphic] {
//            print("graphic: \(graphic)")
//        }
//    }
    
    //if there's an error with the query display it to the user
    func queryTask(queryTask: AGSQueryTask!, operation op: NSOperation!, didFailWithError error: NSError!) {
        UIAlertView(title: "Error", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Ok").show()
    }
    //MARK: GMSMapViewDelegate
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        // Get a reference for the custom overlay
        let index:Int! = Int(marker.accessibilityLabel!)
        let customInfoWindow = NSBundle.mainBundle().loadNibNamed("CustomInfoWindow", owner: self, options: nil)![0] as! CustomInfoWindow
        customInfoWindow.architectLbl.text = architectNames[index]
        customInfoWindow.completedYearLbl.text = completedYear[index]
        return customInfoWindow
    
    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getMatchingWords(searchWord: String) -> [String] {
        let word_to_match = searchWord.lowercaseString
        var matching_words: [String] = []
        
        for suggestions in searchableColleges {
            let lower = suggestions.lowercaseString
            if lower.lowercaseString.rangeOfString(word_to_match) != nil{
                matching_words.append(suggestions)
            }
        }
        
        return matching_words
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchedWords.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath)
        cell.textLabel!.text = matchedWords[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(matchedWords[indexPath.row])
        searchTextField.text = matchedWords[indexPath.row]
        tableView.hidden = true
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    

    
}
