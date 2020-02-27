//
//  Home_ViewController.swift
//  NearMe
//
//  Created by Raymond Zhu on 2/4/20.
//  Copyright © 2020 NearMe. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Home_ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!

    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()

    }
    
    

}



