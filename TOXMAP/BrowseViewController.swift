//
//  SecondViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import ArcGIS



class BrowseViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
   
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let index = indexPath.row
            UserDefaults.standard.setValue(index, forKey: "index")
            performSegue(withIdentifier: Constants.Segues.stateToFacility, sender: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.State.stateFullName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.stateCell)
            cell?.textLabel?.text = Constants.State.stateFullName[indexPath.row]
            return cell!
        
      
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.stateToFacility{
            let vc = segue.destination as! FacilitiesTableViewController
            let indexPath:NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
            vc.stateQueryText = Constants.State.stateAbbreviation[indexPath.row]
            print(vc.stateQueryText)
      
        }
    }



}

