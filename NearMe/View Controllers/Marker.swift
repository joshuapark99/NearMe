//
//  Marker.swift
//  NearMe
//
//  Created by Jackie Chen on 2/27/20.
//  Copyright © 2020 NearMe. All rights reserved.
//

import Foundation
import MapKit

class Marker: NSObject, MKAnnotation {
  let title: String?
  let locationName: String
  let coordinate: CLLocationCoordinate2D
  
  init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.locationName = locationName
    self.coordinate = coordinate
    
    super.init()
  }
  
  var subtitle: String? {
    return locationName
  }
}
