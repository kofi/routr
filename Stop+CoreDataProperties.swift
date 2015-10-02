//
//  Stop+CoreDataProperties.swift
//  RoutR
//
//  Created by Kofi on 9/30/15.
//  Copyright © 2015 38atkins. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

//@objc(Stop)

extension Stop {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var street: String?
    @NSManaged var houseNumber: String?
    @NSManaged var town: String?
    @NSManaged var state: String?
    @NSManaged var zipCode: String?
    @NSManaged var country: String?
    @NSManaged var route: NSManagedObject?
    
}
