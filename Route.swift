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
            //let indexes = (stop as! Stop).stopToRoute!.indexes
            //print("\(indexes)")
            count++
        }
    }
    
    func setIndexForStop(stop: Stop, index: Int) {
         stop.stopToRoute!.indexes[self.objectID] = index
    }
    
    func getIndexForStop(stop: Stop)-> Int{
        return stop.getIndexForRoute(self.objectID)
    }
    
    func swapIndexesForStops(firstStop: Stop, secondStop: Stop) {
        let index =  firstStop.getIndexForRoute(self.objectID)
        setIndexForStop(firstStop, index: secondStop.getIndexForRoute(self.objectID))
        setIndexForStop(secondStop, index: index)
    }

    func getDistanceBetweenStops() ->  [Float] { // [NSManagedObjectID: [NSManagedObjectID : Float] ]{
        var  distances = [Float]()  //[NSManagedObjectID: [NSManagedObjectID : Float] ]()
        let stopCount = self.stops?.count
        
        switch stopCount! {
        case 0:
            return distances
        case 1:
            return [Float(arc4random_uniform(50))]
        default:
            var loopcount = 1
            for stop in self.stops!  {
                if loopcount == 1 {
                    distances.append(Float(arc4random_uniform(50)))
                }
                let indexforstop = getIndexForStop((stop as! Stop))
                for stopnext in self.stops! {
                    let indexforstopnext = getIndexForStop((stopnext as! Stop))
                    if indexforstop == (indexforstopnext - 1) {
                        //distances[stop.objectID] = [ stopnext.objectID : Float(arc4random_uniform(10))]
                        distances.append(Float(arc4random_uniform(50)))
                        break
                    }
                }
                loopcount += 1
                if loopcount > stopCount {
                    break
                }
            }
            return distances
        }
        
    }
    
    func isStopAtRouteIndex(stop: Stop, index: Int) -> Bool {
//        for stop in self.stops!  {
//            let thisIndex = getIndexForStop(stop as! Stop)
//            if  thisIndex == index {
//                return (stop as! Stop)
//            }
//        }
        let thisIndex = getIndexForStop(stop)
        return thisIndex == index
    }
    
    func getStopForIndex(index: Int) -> Stop? {
        for stop in self.stops!  {
            let thisIndex = getIndexForStop(stop as! Stop)
            if  thisIndex == index {
                return (stop as! Stop)
            }
        }
        return nil
    }

}
