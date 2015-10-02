//
//  StoreLocation.swift
//  RoutR
//
//  Created by Kofi on 10/2/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import Foundation
import MapKit

class StoreLocation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let subtitle: String?
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.subtitle = locationName
        super.init()
    }
    
//    var subtitle: String {
//        return locationName
//    }
}