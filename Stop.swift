//
//  Stop.swift
//  RoutR
//
//  Created by Kofi on 9/30/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Stop: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    //[NSManagedObjectID:Int16] // = [NSManagedObjectID:Int16]()
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, firstName: String?, lastName: String?, street: String?,
        houseNumber: String, town: String, state: String, zipCode: String, country: String ) -> Stop {
    
            let newStopObject = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: moc) as! Stop
            newStopObject.firstName = firstName
            newStopObject.lastName = lastName
            newStopObject.street = street
            newStopObject.houseNumber = houseNumber
            newStopObject.town = town
            newStopObject.state = state
            newStopObject.zipCode = zipCode
            newStopObject.country = country
            newStopObject.stopToRoute = StopIndex()
            newStopObject.created = NSDate()
       
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error.localizedDescription)")
        }
        
        return newStopObject
    }
    
    class func upDateInManagedObjectContext(moc: NSManagedObjectContext, stop : Stop,  firstName: String?, lastName: String?, street: String?,
        houseNumber: String?, town: String?, state: String? , zipCode: String?, country: String?, stopIndex : StopIndex )  {
            
            stop.firstName = firstName
            stop.lastName = lastName
            stop.street = street
            stop.houseNumber = houseNumber
            stop.town = town
            stop.state = state
            stop.zipCode = zipCode
            stop.country = country
            stop.stopToRoute = stopIndex
            
            do {
                try moc.save()
            } catch let error as NSError {
                print("Could not save \(error.localizedDescription)")
            }
            
    }
    
    func getAddress() -> String {
        let address =  "\(self.houseNumber!) \(self.street!), \(self.town!), \(self.state!), \(self.zipCode!)"
        return address
    }
    
    func getTitle() -> String {
        let title = "\(self.firstName!) \(self.lastName!)"
        return title
    }
    
    func getPatientName() -> String {
        let patientName = "\(self.houseNumber!) \(self.street!)"
        return patientName
    }
    
//    func getStoreLocation(var location: StoreLocation) {
//        let addressString = self.getAddress()
//        //var location = StoreLocation(title: "", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
//        // find the location coordinates from the address using CLGeocoder
//        let geoCoder = CLGeocoder()
//        
//        geoCoder.geocodeAddressString(addressString) { (placemarks, error) -> Void in
//            // if we don't get back and address
//            if error != nil {
//                print("Error finding location  \(error)")
//            } else {
//                
//                let placemark = placemarks![0]
//                let placelocation = placemark.location
//                let stopCoordinates = placelocation!.coordinate
//                let mylocation = StoreLocation(title: self.getTitle(), locationName: self.getPatientName(), discipline: "Patient",
//                    coordinate: stopCoordinates)  //CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589))
//                
//                
//                location = mylocation
//            }
//            
//        }
//        //return location
//        
//    }
//
//    
//    func getPlacemarkFromLocation(address: String){
//        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
//            if (error != nil) {
//                print("reverse geodcode fail: \(error!.localizedDescription)")
//            } else {
//                let pm = placemarks! as [CLPlacemark]
//                if pm.count > 0 {
//                    //self.showAddPinViewController(placemarks[0] as CLPlacemark)
//                }
//            }
//        })
//    }
//    
//    func getCoordinateFromString(address: String, completionHandler: (CLPlacemark!, NSError?) -> ()) {
//        //let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//        let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(address) { placemarks, error in
//            if error != nil {
//                print("Reverse geocoding error: \(error)")
//            } else if placemarks!.count == 0 {
//                print("no placemarks")
//            }
//            
//            completionHandler((placemarks?.first)! as CLPlacemark, error)
//        }
//    }
    
//    func getCoordinateFromString(address: String) {placemark, error) in
//        if placemark != nil {
//            // use placemark here
//            let placemark = placemarks![0]
//            let placelocation = placemark.location
//            let stopCoordinates = placelocation!.coordinate
//            location = StoreLocation(title: self.getTitle(), locationName: self.getPatientName(), discipline: "Patient",
//                coordinate: stopCoordinates)  //CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589))
//        }
//    }

    // See http://stackoverflow.com/questions/25960555/coredata-swift-and-transient-attribute-getters
    var stoppedToRoute : StopIndex {
        //return StopIndex()
        get {
            return StopIndex()
        }
        set {
            stopToRoute = newValue
        }
    }
    
    func getIndexForRoute(routeID: NSManagedObjectID) -> Int {
        return (self.stopToRoute!.indexes.count > 0 ? self.stopToRoute!.indexes[routeID]: 0)!
    }
    
}
