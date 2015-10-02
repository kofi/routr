//
//  RouteStopsMapsCell.swift
//  RoutR
//
//  Created by Kofi on 10/2/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteStopsMapsCell: UITableViewCell {

    @IBOutlet weak var stopsMap: MKMapView!
    var initialLocation: CLLocation?
    let regionRadius: CLLocationDistance = 5000
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        stopsMap.setRegion(coordinateRegion, animated: true)
    }
    
    

}
