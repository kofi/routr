//
//  Route.swift
//  RoutR
//
//  Created by Kofi on 9/30/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import Foundation
import CoreData

class Route: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func createInManagedObjectContext(moc: NSManagedObjectContext, routeName: String, company: String, stops: NSSet ) -> Route {
        
        let newRoute = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: moc) as! Route
        newRoute.routeName  = routeName
        newRoute.company = company
        newRoute.created = NSDate()
        newRoute.stops = stops
        
        
        do {
            try moc.save()
        } catch let error as NSError {
            print("Could not save \(error.localizedDescription)")
        }
        
        newRoute.setStopIndexes()
        
        return newRoute
    }
    
    func setStopIndexes() {
        var count : Int = 0
        //var stops = self.stops
        for stop in self.stops!  {
            //let routeStop = stop as! Stop
            let myStopIndex = (stop as! Stop).stopToRoute
            //print("\(myStopIndex)")
            //print("\(self.objectID)")
            //print("\(self.stops)")
            //print("\(count)")
            myStopIndex?.indexes[self.objectID] = count
            //(stop as! Stop).stopToRoute!.indexes[self.objectID] = count
            (stop as! Stop).stopToRoute = myStopIndex
            let indexes = (stop as! Stop).stopToRoute!.indexes
            print("\(indexes)")
            count++
        }
        
    }


}
