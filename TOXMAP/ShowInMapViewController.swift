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
    
    var facilityToMap: Facility?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView = GMSMapView(frame: self.view.frame)
        self.view.addSubview(self.mapView)
        self.mapView.delegate = self
        
        
        if let fac = facilityToMap{
            var facility = fac
            let camera = GMSCameraPosition.camera(withLatitude: facility.latitude as! CLLocationDegrees,
                                                  longitude: facility.longitude as! CLLocationDegrees,
                                                  zoom: 14)
            let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
            
            let marker = GMSMarker()
            marker.position = camera.target
            marker.snippet = "\(facility.name!)"
            marker.icon = UIImage(named: "bluemarker") //custom marker

            marker.map = mapView
            
            view = mapView
        }
        else{
            //Show error
        }
        
      
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
