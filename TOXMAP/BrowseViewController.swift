//
//  SecondViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)


import UIKit


class BrowseViewController: UIViewController, UITextFieldDelegate {

    
    var searchMode = true
    private var facility: Facility?

    //MARK: IBOutlets
    @IBOutlet weak var browseStateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchSegment: ADVSegmentedControl!
    @IBOutlet weak var searchField: UITextField!{
        didSet{
            searchField.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentControl()
        
        navigationItem.title = "Explore"

        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        setUpButton()
        
    }
    /**
     Search controller for different methods
     
     - parameter bar: Listens to the differnt segments/selection
     
     - returns:
     */
    func segmentValueChanged(_ sender: AnyObject?){
        if self.searchSegment.selectedIndex == 0{
            searchField.placeholder = "Search by facility name"
        }
        else {
            searchField.placeholder = "Search by state"
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        Facility.sharedInstance.removeAll()
        
    }
    
    func setUpButton(){
        browseStateButton.setTitle("State/\nCounty", for: .normal)
        browseStateButton.sizeToFit()
        browseStateButton.titleLabel!.lineBreakMode = NSLineBreakMode.byWordWrapping
        browseStateButton.titleLabel!.numberOfLines = 0
        browseStateButton.titleLabel!.textAlignment = NSTextAlignment.center
    }
    func setUpSegmentControl(){
        searchSegment.items = ["Facilities", "State"]
        searchSegment.font = UIFont(name: "CenturyGothic", size: 16)
        searchSegment.borderColor = Constants.colors.mainColor
        searchSegment.selectedIndex = 0
        searchSegment.addTarget(self, action: #selector(BrowseViewController.segmentValueChanged(_:)), for: .valueChanged)

    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        view.endEditing(true)
        cancelButton.isHidden = true
        searchField.text = ""
    }

    /**
     Main Search result sender- Checks the segment first and sends query to specific place with proper where clause
     
     - parameter bar: Listens for the click
     
     - returns:
     */
    @IBAction func searchPressed() {
        cancelButton.isHidden = true
        let manager = ArcGISManager()
        if searchField.text != "" && manager.isInternetAvailable(){
            
            let searchText = searchField.text!.uppercased()
            if searchSegment.selectedIndex == 0{
                let searchString = "upper(fnm) like '%\(searchText)%'"
                let manager = ArcGISManager()
                manager.query(whereString: searchString, url: ArcGISURLType.facilityURL.rawValue, chemicalSearch: false){(result: String) in
                    if Facility.sharedInstance.count != 0{
                        self.facility = Facility.sharedInstance[0]
                        self.performSegue(withIdentifier: Constants.Segues.searchToFacility, sender: nil)
                    }
                    else {
                        DispatchQueue.main.async {
                            self.showError("\(self.searchField.text!) not found", message: "Please try with another search item")
                        }
                    }
                }
            }

            else{
                let stateName = stateChecker(stateName: searchText)
                let searchString = "fst='\(stateName)'"
                
                manager.query(whereString: searchString, url: ArcGISURLType.facilityURL.rawValue, chemicalSearch: false){(result: String) in
                    if Facility.sharedInstance.count != 0{
                        self.performSegue(withIdentifier: Constants.Segues.searchToFacility, sender: nil)
                    }
                    else {
                        DispatchQueue.main.async {
                            self.showError("\(self.searchField.text!) not found", message: "Please try  another search term.")
                        }
                    }
                }
            }
        }
        else {
            if !manager.isInternetAvailable(){
                showError("No Internet Connection", message: "Please try after the internet connection is back.")
            }
            //showError("No text", message: "Enter facilities or county to search")
        }
    }
    
    
    func dismissKeyboard() {
        cancelButton.isHidden = true
        view.endEditing(true)
    }
    
    
    /**
     State checker- Validates states and converts full name to abbreviations
     
     - parameter bar: Statename or abbreviation
     
     - returns: returns the state abbreviateion Uppercased
     */
    func stateChecker(stateName: String)-> String{
        
        if stateName.characters.count == 2{
            if stateName == "dc" || stateName == "DC" || stateName == "D.c"{
            return "DC"
            }
            else{
                return stateName.uppercased()
            }
        }
        else{
            if stateName.lowercased() == "washington dc" || stateName.lowercased() == "washington d.c" || stateName.lowercased() == "washington d.c," {
                return "DC"
            }
            for state in Constants.State.stateFullName{
                if stateName.uppercased() == state{
                    return Constants.State.stateAbbreviation[Constants.State.stateFullName.index(of: stateName.uppercased())!]
                }
            }
            return stateName.uppercased()
        }
    }
    
    @IBAction func browseByChemicals(_ sender: Any) {
    }
    
    
    @IBAction func browseByState(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.browseToState, sender: nil)
      

    }
    
    @IBAction func textListening(_ sender: Any) {
        if (searchField.text?.characters.count) != nil{
            cancelButton.isHidden = false
        }
    }

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchField.text = ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        searchPressed()
        return true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.searchToDetail{
            let vc = segue.destination as! DetailViewController
            vc.facilityToDisplay = facility
        }
    }

}
extension UIViewController{
    func showError(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

