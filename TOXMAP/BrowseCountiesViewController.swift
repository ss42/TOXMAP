//
//  BrowseCountiesViewController.swift
//  
//
//  Created by Sanjay Shrestha on 3/10/17.
//  Source code property belongs to The National Library of Medicine (NLM)

//

import UIKit
import ArcGIS
import SVProgressHUD

class BrowseCountiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    private var featureTable:AGSServiceFeatureTable!
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
       // self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.chemicalURL)!)
        
//        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        
        // Do any additional setup after loading the view, typically from a nib.
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
        let manager = ArcGISManager()
        manager.query(whereString: alias!, url: ArcGISURLType.chemicalURL.rawValue, chemicalSearch: true){(result: String) in
            SVProgressHUD.dismiss()
            UIApplication.shared.endIgnoringInteractionEvents()
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
        UIApplication.shared.beginIgnoringInteractionEvents()
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

    func query(whereText: String, completion: @escaping (_ result: String) -> Void) {
        Facility.sharedInstance.removeAll()
        let queryParams = AGSQueryParameters()
        queryParams.whereClause = whereText
        
        self.featureTable.populateFromService(with: queryParams, clearCache: true, outFields: ["*"]) { result, error in
            if error != nil {
                SVProgressHUD.dismiss()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.showError("Could not perform search.", message: "Please try again later.")
            }
            else {

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
                    let lat = facility.attributes["LATD"] as? NSNumber
                    let totalerelt = facility.attributes["TOTALERELT"] as? Int
                    let totalCur = facility.attributes["TOT_CURRENT"] as? Int
                    let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                    Facility.sharedInstance.append(fac)
                    self.tableView.reloadData()
                    
                }
                Facility.sharedInstance.sort{$0.name! < $1.name!}
                completion("Finished loading data")
            }
        }
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
