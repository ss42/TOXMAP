//
//  ShowInMapViewController.swift
//  TOXMAP
//
//  Created by Sanjay Shrestha on 12/23/16.
//  Copyright © 2016 NIH. All rights reserved.
//

import UIKit
import GoogleMaps

class ShowInMapViewController: UIViewController, GMSMapViewDelegate {

    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView = GMSMapView(frame: self.view.frame)
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        
        let index = UserDefaults.standard.value(forKey: "index") as! Int?
        
        let facility = Facility.sharedInstance[index!]
        
        let camera = GMSCameraPosition.camera(withLatitude: facility.latitude as! CLLocationDegrees,
                                              longitude: facility.longitude as! CLLocationDegrees,
                                              zoom: 14)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        
        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "\(facility.name!)"
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.map = mapView
        
        view = mapView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
