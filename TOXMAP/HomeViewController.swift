//
//  FirstViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import GoogleMaps

class HomeViewController: UIViewController {

    @IBOutlet weak var maps: UIView!
    
    //@IBOutlet weak var maps: GMSServices!
    
    
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
        //view.addSubview(searchTextField)

        // Get main screen bounds
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        //let xPos = UINavigationController. UINavigationBar.frame.size.height
            //.navigationBar.frame.size.height
        
        
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.cameraWithLatitude( -33.86, longitude: 151.20, zoom: 6.0)
        let mapView = GMSMapView.mapWithFrame(CGRect.init(x: 0, y: 94, width: screenWidth, height: screenHeight-100), camera: camera)
           // mapView.isMyLocationEnabled = true
        //view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView

        //begin()
        print("View did load happening")
        //self.mapView.bringSubview(toFront: searchTextField)
        ////mapView.addSubview(tableView)
        view.addSubview(searchTextField)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        
        tableView.allowsSelection = true
        
        view.addGestureRecognizer(tap)
        maps = mapView
        view.addSubview(maps)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func begin(){
        // Create a GMSCameraPosition that tells the map to display the
        
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
