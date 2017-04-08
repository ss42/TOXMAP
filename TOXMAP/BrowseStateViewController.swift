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
    var indexToSend: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "List of States"
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
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexToSend = indexPath.row as Int
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: Constants.Segues.stateToCounty, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.State.stateFullName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.stateCell)
        cell?.textLabel?.text = Constants.State.stateFullName[indexPath.row].capitalized
        return cell!
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segues.stateToCounty{
            let vc = segue.destination as! BrowseCountiesViewController
            vc.index = indexToSend
        }
    }
    

    
}
