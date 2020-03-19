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

class Home_ViewController: UIViewController,MKMapViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var resultSearchController:UISearchController? = nil
    
   // var didFindLocation

    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestLocation()
        var location: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
            location = locationManager.location
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        if location != nil {
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.delegate = self
        resultSearchController?.searchResultsUpdater = locationSearchTable
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        
        let searchBar = resultSearchController!.searchBar
        //searchBar = UISearchBar(frame: CGRect(x:0, y:0, width: (view.bounds.width), height:50))
        
        //mapView.addSubview(searchBar)
        //searchBar.delegate = locationSearchTable
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        //resultSearchController?.dimsBackgroundDuringPresentation = true
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
    }
    
    

}

extension Home_ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("hiiiiiiiiii")
        if let location = locations.first {
            print("hellooooo")
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta:0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error \(error)")
            print("hiiiialksdjfklasjdf")
    }
}

