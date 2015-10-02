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
        
        return newRoute
    }


}
