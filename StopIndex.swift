//
//  StopIndex.swift
//  RoutR
//
//  Created by Kofi on 10/2/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import Foundation
import CoreData

class StopIndex: NSObject, NSCoding {
    var indexes: [NSManagedObjectID: Int]
    
    override init(){
        indexes = [NSManagedObjectID: Int]()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        //if let myindexes = indexes {
        aCoder.encodeObject(indexes, forKey: "indexes")
        //}
    }
    
    required init(coder aDecoder: NSCoder) {
        indexes = (aDecoder.decodeObjectForKey("indexes") as? [NSManagedObjectID: Int])!
    }
    
    func addToIndex(objectID: NSManagedObjectID, index: Int){
//        let ok = indexes[objectID] == nil
//        if ok == true {
//            indexes[objectID] = index
//        } else {
//
//        }
        indexes[objectID] = index
    }
    
    
    
}