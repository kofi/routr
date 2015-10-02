//
//  Stop.swift
//  RoutR
//
//  Created by Kofi on 9/30/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import Foundation
import CoreData

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
