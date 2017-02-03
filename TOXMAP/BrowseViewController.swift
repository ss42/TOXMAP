//
//  SecondViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 9/17/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import ArcGIS



class BrowseViewController: UIViewController {

    
    @IBOutlet weak var searchSegment: UISegmentedControl!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    let browse = ["Chemicals", "By State", "By City"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.delegate = self
       // self.tableView.dataSource = self
        
        self.view.applyGradient(colours: [Constants.colors.mainColor, Constants.colors.secondaryColor], locations: [0.2, 0.9, 0.9])
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    @IBAction func searchPressed(_ sender: Any) {
    }
    
    
    @IBAction func browseByChemicals(_ sender: Any) {
    }
    
    
    @IBAction func browseByState(_ sender: Any) {
        performSegue(withIdentifier: Constants.Segues.browseToState, sender: nil)
      

    }
    
    





}

