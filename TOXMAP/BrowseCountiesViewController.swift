//
//  BrowseCountiesViewController.swift
//  
//
//  Created by Sanjay Shrestha on 3/10/17.
//  Source code property belongs to The National Library of Medicine (NLM)

//

import UIKit
import SVProgressHUD

class BrowseCountiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var stateName: String?
    var counties = ["All Counties"]
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List of Counties"
        stateName = Constants.State.stateFullName[index!].lowercased()
        
        DispatchQueue.global(qos: .userInitiated).async { // 1
            self.counties = self.loadJson(forFilename: "County", stateName: (self.stateName?.uppercased())!)!
            DispatchQueue.main.async { // 2
                self.tableView.reloadData()
            }
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if tableView.indexPathForSelectedRow != nil {
            let indexpath: NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
            tableView.deselectRow(at: indexpath as IndexPath, animated: true)
        }
        
    }
    
    func convertToAlias(number: Int){
        
        let state = Constants.State.stateAbbreviation[index!].uppercased()
        var county = counties[number].uppercased()
        county = county.replacingOccurrences(of: "'", with: "", options: .literal, range: nil) //replacing ' ..ex: ST.MARY'S = ST.MARYS
        county = county.replacingOccurrences(of: ".", with: "", options: .literal, range: nil) //replacing .(DOT) ..ex: ST.MARYS = ST. MARYS
        var alias: String?
        if county == "ALL COUNTIES"{
            alias =  "fst='\(state)'"

        }else{
            alias =  "fst='\(state)' and fco='\(county)'"

        }
    
        callArcGIS(whereString: alias!)

    }
    
    func callArcGIS(whereString: String){
        let manager = ArcGISManager()
        manager.query(whereString: whereString, url: ArcGISURLType.chemicalURL.rawValue, chemicalSearch: true){(result: String) in
            if Facility.sharedInstance.count == 0{
                self.showError("No Facilities", message: "There are no facilities in the county you selected. Please try a different one.")
            }else{
                //Segue to next view controller
                self.performSegue(withIdentifier: Constants.Segues.countyToFacility, sender: nil)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = indexPath.row
        SVProgressHUD.show(withStatus: "Loading")
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.black)
        tableView.deselectRow(at: indexPath, animated: true)
        let manager = ArcGISManager()
        if !manager.isInternetAvailable(){
            showError("No Internet Connection", message: "Please try after the internet connection is back.")
        }
        convertToAlias(number: index)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.stateCell)
        if counties[indexPath.row].capitalized == "All Counties" || counties[indexPath.row].capitalized == "District Of Columbia"{
            cell?.textLabel?.text = counties[indexPath.row].capitalized

        }else{
            cell?.textLabel?.text = counties[indexPath.row].capitalized + " County"

        }
        
        return cell!
        
        
    }
    
    func loadJson(forFilename fileName: String, stateName: String) -> Array<String>? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            if let data = NSData(contentsOf: url) {
                do {
                    let allState = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary
                    var state = allState?[stateName.uppercased()] as! [String]

                    if state.count > 2{
                        state.insert("All Counties", at: 0)
                    }
                    return state
                } catch {
                    showError("Error", message: "Please try again later.")
                }
            }
            showError("Error", message: "Please try again later.")
        }
        
        return nil
    }

    
}
