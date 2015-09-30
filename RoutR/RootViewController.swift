//
//  RootViewController.swift
//  RoutR
//
//  Created by Kofi on 9/30/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import UIKit
import CoreData

class RootViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    private let routeCell = "Routes"
    private let stopCell = "Cell"
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let routesDict: [[String:String]]  = [
            [ "routeName": "Mondays", "company": "Nizhoni"],
            [ "routeName": "Tuesdays", "company": "Cedex"],
            [ "routeName": "Fridays", "company": "Nizhoni"],
    ]
    
    /* 
    // See 
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreData/nsfetchedresultscontroller.html#//apple_ref/doc/uid/TP40001075-CH8-SW1
    */
    var frc: NSFetchedResultsController!
    var routesFetch = NSFetchRequest(entityName: "Route")
    //var routes = [Route]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createStarterRoutes()
        initializeFetchedResultsController()
        print("I cant wait to push this project to GitHub")
        print(moc)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    private func createStarterRoutes() {
        //let entityDescription = NSEntityDescription.entityForName("Route", inManagedObjectContext: moc)
        
        for route in routesDict {
            
            print(route)
            saveRoute(route: route)
        }
        
        //routes.append(route1)
        
    }
    
    private func saveRoute(route routeDict : [String: String]) {
        let route = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: self.moc) as! Route
        //let route1 = Route(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        route.company = routeDict["company"]
        route.created = NSDate()
        route.routeName = routeDict["routeName"]
        
        do {
            try moc.save()
            print("saved route \(route)")

        } catch let error as NSError {
            print("Could not save \(error.localizedDescription)")
        }
        
    }
    
//    private func fetchCurrentRoutes() {
//        do {
//            routes = try moc.executeFetchRequest(routesFetch) as! [Route]
//        } catch {
//            fatalError("Failed to fetch current routes: \(error)")
//        }
//    }
    
    private func deleteAllRoutes() {
//        
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: self.routesFetch)
//        
//        do {
//            try myPersistentStoreCoordinator.executeRequest(deleteRequest, withContext: moc)
//        } catch let error as NSError {
//            // TODO: handle the error
//        }
    }
    
    
    // MARK: fetched Results controller methods
    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Route")
        //let routeNameSort = NSSortDescriptor(key: "department.name", ascending: true)
        let routeNameSort = NSSortDescriptor(key: "routeName", ascending: true)
        let createdSort = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [createdSort, routeNameSort]  //departmentSort,
        
        //let moc = self.dataController.managedObjectContext
        self.frc = NSFetchedResultsController(
                        fetchRequest: request, managedObjectContext: moc,
                        sectionNameKeyPath: "routeName", cacheName: nil) // "rootCache")
        self.frc.delegate = self
        
        do {
            try self.frc.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
            atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Move:
            break
        case .Update:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
            switch type {
            case .Insert:
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            case .Delete:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            case .Update:
                self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)!, indexPath: indexPath!)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    
    // MARK:
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.frc.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 0 // 1currentRoutes.count
        
        if self.frc.sections == nil {
            return 0
        }
        
        let sections: [NSFetchedResultsSectionInfo] = self.frc.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
        
    }

    
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let route = self.frc.objectAtIndexPath(indexPath) as! Route
        // Populate cell from the NSManagedObject instance
        cell.textLabel?.text = route.routeName
        cell.detailTextLabel?.text = "\(route.company!) @ \(route.created!)"
        print("Object for configuration: \(route)")
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("routeCell", forIndexPath: indexPath) as UITableViewCell
        
        //let route = routes[indexPath.row] as! Route
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
