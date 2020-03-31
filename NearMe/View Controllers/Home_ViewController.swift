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
import CoreData

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class Home_ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin:MKPlacemark? = nil
    var toDeleteAnnotation:MKAnnotation? = nil
    var toDeleteMapView: MKMapView? = nil
    var resultSearchController:UISearchController? = nil
    
   // var didFindLocation

    fileprivate let locationManager:CLLocationManager = CLLocationManager()
    
    @objc func getDirections() {
        guard let selectedPin = selectedPin else {return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    @objc func deleteFromData() {
        guard let selectedPin = selectedPin else {return }
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Places>(entityName: "Places")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if (result.latitude == selectedPin.coordinate.latitude && result.longitude == selectedPin.coordinate.longitude) {
                        context.delete(result)
                        do {
                            try context.save()
                            print("Saved")
                            toDeleteMapView?.removeAnnotation(toDeleteAnnotation!)
                        } catch {
                            print("Saving Error")
                        }
                    }
                }
            } catch {
                print("Couldnt not retrieve")
            }
        }
        print("deleted annotation")
 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let places = self.retrieveValues()
        for place in places {
            let newCoordinate = CLLocationCoordinate2D(latitude: place.0, longitude: place.1)
            let placemark = MKPlacemark(coordinate: newCoordinate)
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.coordinate
            annotation.title = placemark.name
            if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            mapView.addAnnotation(annotation)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
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
        //resultSearchController?.delegate = self
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
        
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    

    

}

extension Home_ViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
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

extension Home_ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        selectedPin = placemark
        //mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        //print(annotation.coordinate)
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        self.save(x:annotation.coordinate.latitude, y: annotation.coordinate.longitude)
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}


extension Home_ViewController: MKMapViewDelegate {
    func mapView(_: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {return nil}
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        toDeleteAnnotation = annotation
        toDeleteMapView = mapView
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width:30, height:30)
        let button = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        let button1 = UIButton(frame: CGRect(origin: CGPoint.zero, size: smallSquare))
        button1.setBackgroundImage(UIImage(named: "car"), for: .normal)
        button1.addTarget(self, action: #selector(deleteFromData), for: .touchUpInside)
        pinView?.rightCalloutAccessoryView = button1
        
        return pinView
    }
}

extension Home_ViewController {
    func save(x: Double, y: Double) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Places", in: context) else {return}
            
            let newValue = NSManagedObject(entity: entityDescription, insertInto: context)
            
            //newValue.setValue(value, forKey: "placeName")
            newValue.setValue(x, forKey: "latitude")
            newValue.setValue(y, forKey: "longitude")
            
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Saving Error")
            }
        }
    }
    
    func retrieveValues() -> [(Double,Double)] {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Places>(entityName: "Places")
            var returnValues = [(Double,Double)]()
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    let latitude = result.latitude
                    let longitude = result.longitude
                    returnValues.append((latitude, longitude))
                }
            } catch {
                print("Couldnt not retrieve")
            }
            return returnValues
        }
        return []
    }
}
