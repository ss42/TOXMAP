//
//  BrowseChemicalsTableViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 2/18/17.
//  Copyright © 2017 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)


import UIKit


class BrowseChemicalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    var chemicalSelected = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Chemicals"
        tableView.reloadData()
        tableView.translatesAutoresizingMaskIntoConstraints = false

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if tableView.indexPathForSelectedRow != nil {
            let indexpath: NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
                tableView.deselectRow(at: indexpath as IndexPath, animated: true)
            }
        
    }
    
    
    
    /**
     Converts the Chemical Name to Alias and call Query function
     
     - parameter bar: Index of the chemical from the tableView
     - returns:
     */

    func convertToAlias(number: Int){
        let manager = ArcGISManager()
        chemicalSelected = Chemical.chemicalAlias[number]
        let chemAlias = "\(chemicalSelected)" + " > 0"
        manager.query(whereString: chemAlias, url: ArcGISURLType.chemicalURL.rawValue, chemicalSearch: true){(result: String) in
                        if Facility.sharedInstance.count != 0{
                self.performSegue(withIdentifier: Constants.Segues.chemicalToFacility, sender: nil)
            }
            else{
                self.showError("No Facilities Found", message: "Please select a different chemical.")
            }
        }
        
    }
    


    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Chemical.chemicalName.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.browseChemicalCell, for: indexPath)
        cell.textLabel?.text = Chemical.chemicalName[indexPath.row].capitalized
        return cell
    }
    // MARK: - Table view is Tapped or selected

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = Constants.colors.secondaryColor
        tableView.deselectRow(at: indexPath, animated: true)
        let manager = ArcGISManager()
        if !manager.isInternetAvailable(){
            showError("No Internet Connection", message: "Please try after the internet connection is back.")
        }
        convertToAlias(number: index)
    }
 



}
