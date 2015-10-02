//
//  DataHelper.swift
//  RoutR
//
//  Created by Kofi on 10/1/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import Foundation
import CoreData

public class DataHelper {
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func seedDataStore() {
        seedStops()
        seedRoutes()
    }
    
    private func seedStops() {
        let stops = [
            (firstName: "John", lastName: "Doe", street: "ALLSTON CT.", houseNumber: "1", town: "Cambridge", state: "Massachusetts", zipCode: "02139-3919"),
            (firstName: "Jane", lastName: "Mael", street: "APPLETON ST", houseNumber: "174", town: "Cambridge", state: "Massachusetts", zipCode: "02138-1331"),
            (firstName: "David", lastName: "Johnson", street: "Ash ST.", houseNumber: "31", town: "Cambridge", state: "Massachusetts", zipCode: "02138"),
            (firstName: "Shirley", lastName: "Chisolm", street: "Aberdeen CT.", houseNumber: "1", town: "Cambridge", state: "Massachusetts", zipCode: "02138"),
            (firstName: "Jack", lastName: "Rudolph", street: "AGASSIZ St.", houseNumber: "18", town: "Cambridge", state: "Massachusetts", zipCode: "02140-2802")
        ]
        
        for stop in stops {
            let newStopObject = NSEntityDescription.insertNewObjectForEntityForName("Stop", inManagedObjectContext: context) as! Stop
            newStopObject.firstName = stop.firstName
            newStopObject.lastName = stop.lastName
            newStopObject.street = stop.street
            newStopObject.houseNumber = stop.houseNumber
            newStopObject.town = stop.town
            newStopObject.state = stop.state
            newStopObject.zipCode = stop.zipCode
        }
        
        do {
            try context.save()
        } catch _ {
            
        }
    }
    
    
    private func seedRoutes() {
        let stopsFetchRequest = NSFetchRequest(entityName: "Stop")
        let allStops = (try! context.executeFetchRequest(stopsFetchRequest)) as! [Stop]
        //print("\(allStops)")
        
        let stop1 = allStops.filter({(c: Stop) -> Bool in
            return (c.firstName == "John") && (c.lastName == "Doe")
        }).first
        let stop2 = allStops.filter({(c: Stop) -> Bool in
            return (c.firstName == "Jane") && (c.lastName == "Mael")
        }).first
        let stop3 = allStops.filter({(c: Stop) -> Bool in
            return (c.firstName == "David") && (c.lastName == "Johnson")
        }).first
        let stop4 = allStops.filter({(c: Stop) -> Bool in
            return (c.firstName == "Shirley") && (c.lastName == "Chisolm")
        }).first
        let stop5 = allStops.filter({(c: Stop) -> Bool in
            return (c.firstName == "Jack") && (c.lastName == "Rudolph")
        }).first
        
//        let stop1 = allStops[0]
//        let stop2 = allStops[1]
//        let stop3 = allStops[2]
//        let stop4 = allStops[3]
//        let stop5 = allStops[4]
        
        let routes = [
            (routeName: "Mondays", company: "St. Elizabeths", stops: NSSet(array: [stop1!, stop2!])),
            (routeName: "Wednesdays", company: "St. Judes", stops: NSSet(array: [stop2!, stop3!, stop4!])),
            (routeName: "Tuesdays", company: "St. Mary's", stops: NSSet(array: [stop5!])),
            (routeName: "Sundays", company: "Kindred", stops: NSSet(array: [stop1!, stop2!, stop4!, stop5!])),
            (routeName: "Fridays", company: "Homeway", stops: NSSet(array: [stop1!]))
        ]
        //print("\(routes)")
        
        for route  in routes {
            let newRouteObject = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: context) as! Route
            newRouteObject.routeName = route.routeName
            newRouteObject.company = route.company
            newRouteObject.stops = route.stops
            print("\(route.stops.count)")
            newRouteObject.created = NSDate()
        }
        
        do {
            try context.save()
        } catch _ {
        }
    }
    
    
//    public func printAllStops() {
//        let zooFetchRequest = NSFetchRequest(entityName: "Zoo")
//        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        
//        zooFetchRequest.sortDescriptors = [primarySortDescriptor]
//        
//        let allZoos = (try! context.executeFetchRequest(zooFetchRequest)) as! [Zoo]
//        
//        for zoo in allZoos {
//            print("Zoo Name: \(zoo.name)\nLocation: \(zoo.location) \n-------\n", terminator: "")
//        }
//    }
//    
//
//    
//    public func printAllAnimals() {
//        let animalFetchRequest = NSFetchRequest(entityName: "Animal")
//        let primarySortDescriptor = NSSortDescriptor(key: "habitat", ascending: true)
//        
//        animalFetchRequest.sortDescriptors = [primarySortDescriptor]
//        
//        let allAnimals = (try! context.executeFetchRequest(animalFetchRequest)) as! [Animal]
//        
//        for animal in allAnimals {
//            print("\(animal.commonName), a member of the \(animal.classification.family) family, lives in the \(animal.habitat) at the following zoos:\n", terminator: "")
//            for zoo in animal.zoos {
//                print("> \(zoo.name)\n", terminator: "")
//            }
//            print("-------\n", terminator: "")
//        }
//    }
}