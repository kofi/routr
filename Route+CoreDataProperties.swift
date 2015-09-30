//
//  Route+CoreDataProperties.swift
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

extension Route {

    @NSManaged var routeName: String?
    @NSManaged var company: String?
    @NSManaged var created: NSDate?
    @NSManaged var stops: NSSet?

}
