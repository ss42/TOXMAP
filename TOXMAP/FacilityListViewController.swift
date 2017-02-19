//
//  FacilityListViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 2/3/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit
import ArcGIS

class FacilityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var facility: Facility?

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.center = self.view.center
        activityIndicator.activityIndicatorViewStyle = .gray
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        
        self.featureTable = AGSServiceFeatureTable(url: URL(string: Constants.URL.chemicalURL)!)
        
        featureTable.featureRequestMode = AGSFeatureRequestMode.manualCache
        
        let index = UserDefaults.standard.value(forKey: "index") as? Int
        convertToAlias(number: index!)
        
        navigationItem.title = "Facilities"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: Selector(("loadList:")),name:NSNotification.Name(rawValue: "load"), object: nil)
        
        //delay and run code
        let when = DispatchTime.now() + 2  //2 means 2 seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.tableView.reloadData()
            // Your code with delay
        }
        // Do any additional setup after loading the view.
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //delay and run code
        let when = DispatchTime.now() + 2  //2 means 2 seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            self.tableView.reloadData()
            // Your code with delay
        }
        print("super init  in facilitiesList")
        print(Facility.searchInstance.count)
        
    }
    func loadList(notification: NSNotification){
        print("loading ")
        
        self.tableView.reloadData()
    }
    

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.facility = Facility.searchInstance[indexPath.row]
        facility = Facility.searchInstance[indexPath.row]
       // print(facility!.name ?? " ")
        

        performSegue(withIdentifier: Constants.Segues.facilityListToDetail , sender: nil)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Facility.searchInstance.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.FacilityListCell)
        cell?.textLabel?.text = Facility.searchInstance[indexPath.row].name as String!
        
        activityIndicator.stopAnimating()
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            if segue.identifier == Constants.Segues.facilityListToDetail{
                let vc = segue.destination as! DetailViewController
                vc.facilityToDisplay = facility
    
                
            }
    }
    private var featureTable:AGSServiceFeatureTable!
    
    var featureSet:AGSFeatureSet!
    
    func convertToAlias(number: Int){
        let chemAlias = "chem_" + "\(number + 1)" + " > 0"
        
        self.queryForState(chemical: chemAlias){(result: String) in
            print(result)
            self.tableView.reloadData()
            self.activityIndicator.stopAnimating()
            
        }
       
        
    }
    
    
    
    func queryForState(chemical: String, completion: @escaping (_ result: String) -> Void) {
        Facility.searchInstance.removeAll()
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
                    print(name)
                    let facilityNumber = facility.attributes["FACN"] as? NSString
                    let street = facility.attributes["FAD"] as? NSString
                    //let countyName = facility.attributes["FCO"] as? NSString
                    let city = facility.attributes["FCTY"] as? NSString
                    let state = facility.attributes["FST"]as? NSString
                    let zipcode = facility.attributes["FZIP"] as? NSString
                    let facitlityID = facility.attributes["FRSID"] as? NSString
                    let long = facility.attributes["LONGD"] as? NSNumber
                    let lat = facility.attributes["LATD"] as? NSNumber
                    let totalerelt = facility.attributes["TOTALERELT"] as? NSNumber
                    let totalCur = facility.attributes["TOT_CURRENT"] as? NSNumber
                    let fac = Facility(number: facilityNumber!, name: name!, street: street!, city: city!, state: state!, zipCode: zipcode!, latitude: lat!, longitude: long!, total: totalerelt!, current: totalCur!, id: facitlityID!)
                    
                    Facility.searchInstance.append(fac)
                    
                    self.tableView.reloadData()
                    
                }
                completion("Finished loading data")
            }
        }
    }

    
//    func showActivityIndicatory(uiView: UIView) {
//        var container: UIView = UIView()
//        container.frame = uiView.frame
//        container.center = uiView.center
//        container.backgroundColor = UIColor(
//            (0xffffff, alpha: 0.3)
//        
//        var loadingView: UIView = UIView()
//        loadingView.frame = CGRectMake(0, 0, 80, 80)
//        loadingView.center = uiView.center
//        loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
//        loadingView.clipsToBounds = true
//        loadingView.layer.cornerRadius = 10
//        
//        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
//        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
//        actInd.activityIndicatorViewStyle =
//            UIActivityIndicatorViewStyle.WhiteLarge
//        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
//                                    loadingView.frame.size.height / 2);
//        loadingView.addSubview(actInd)
//        container.addSubview(loadingView)
//        uiView.addSubview(container)
//        actInd.startAnimating()
//    }

    

}
