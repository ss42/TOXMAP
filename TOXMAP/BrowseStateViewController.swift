//
//  BrowseStateViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 1/26/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit


class BrowseStateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List of States"


        self.tableView.delegate = self
        self.tableView.dataSource = self

        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: Constants.Segues.stateToCounty, sender: nil)
        
        
        
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
        if segue.identifier == Constants.Segues.stateToCounty{
            let vc = segue.destination as! BrowseCountiesViewController
            let indexPath:NSIndexPath = tableView.indexPathForSelectedRow! as NSIndexPath
            vc.index = indexPath.row

            
        }
    }
    

    
}
