//
//  FacilitiesTableViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//  Source code property belongs to The National Library of Medicine (NLM)


import UIKit


class FacilitiesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
 
    private var facility: Facility?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Reporting Facilities"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if tableView.indexPathForSelectedRow != nil {
            let indexpath: NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
            tableView.deselectRow(at: indexpath as IndexPath, animated: true)
        }
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            facility = Facility.sharedInstance[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

            performSegue(withIdentifier: Constants.Segues.browseFacilityToDetail , sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Facility.sharedInstance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.chemicalCell)
            cell?.textLabel?.text = (Facility.sharedInstance[indexPath.row].name as String!).capitalizingFirstLetter()
            return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.Segues.browseFacilityToDetail{
            let vc = segue.destination as! DetailViewController
            vc.facilityToDisplay = facility
            
            
        }
    }

}
