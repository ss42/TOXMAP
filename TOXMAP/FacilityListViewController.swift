//
//  FacilityListViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 2/3/17.
//  Copyright © 2017 NIH. All rights reserved.
//

import UIKit

class FacilityListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var facility: Facility?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: Selector(("loadList:")),name:NSNotification.Name(rawValue: "load"), object: nil)

        // Do any additional setup after loading the view.
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        tableView.reloadData()
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
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
            if segue.identifier == Constants.Segues.facilityListToDetail{
                let vc = segue.destination as! DetailViewController
                vc.facilityToDisplay = facility
    
                
            }
    }

    

}
