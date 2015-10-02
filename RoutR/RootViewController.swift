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

    //public var moc: NSManagedObjectContext!
    
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
    var routesFetch: NSFetchRequest =  NSFetchRequest() //NSFetchRequest(entityName: "Route")
    //var routes = [Route]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        //createStarterRoutes()
        initializeFetchedResultsController()
        performFetch()
        self.tableView.reloadData()
        //print("I cant wait to push this project to GitHub")
        //print(moc)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
//    private func createStarterRoutes() {
//        //let entityDescription = NSEntityDescription.entityForName("Route", inManagedObjectContext: moc)
//        
//        for routeDict in routesDict {
//            
//            //print(routeDict)
//            saveRouteFromDict(routeDict: routeDict)
//        }
//        
//    }
    
    // MARK: - Save Edit Routines
    
    private func saveRouteFromDict(routeDict routeDict : [String: String]) {
        
        Route.createInManagedObjectContext(moc, routeName: routeDict["routeName"]!, company: routeDict["company"]!, stops: NSSet(array: []))
        
//        let route = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: self.moc) as! Route
//        //let route1 = Route(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
//        route.company = routeDict["company"]
//        route.created = NSDate()
//        route.routeName = routeDict["routeName"]
//        //route.stops = NSSet()
//        
//        print("\(route)")
//        
//        do {
//            try moc.save()
//            //print("saved route \(route)")
//
//        } catch let error as NSError {
//            print("Could not save \(error.description)")
//            
//        }
    }
    
    private func saveRoute(route route : Route) {
        Route.createInManagedObjectContext(moc, routeName: route.routeName!, company: route.company!, stops: NSSet(array: []))
//        let routeSave = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: self.moc) as! Route
//
//        //let route1 = Route(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
//        routeSave.company = route.company!
//        routeSave.created = NSDate()
//        routeSave.routeName = route.routeName!
//        
//        do {
//            try moc.save()
//            //print("saved route \(routeSave)")
//            
//        } catch let error as NSError {
//            print("Could not save \(error.localizedDescription)")
//        }
    }
    
    
    private func deleteRouteFromIndex(indexPath: NSIndexPath) {
        let managedObject:NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
        do {
            moc.deleteObject(managedObject)
            try moc.save()

        } catch let error as NSError {
            print("Could not save \(error.localizedDescription)")
        }

    }
    
    private func updateRouteAtIndex(indexPath: NSIndexPath, routeDict : [String : String]) {
        
        let selectedRoute =  frc.objectAtIndexPath(indexPath) as! Route
        //let moID = selectedRoute.objectID
        selectedRoute.routeName = routeDict["routeName"]
        selectedRoute.company   = routeDict["company"]
        
        do {
    
            let fetchResults = try moc.executeFetchRequest(routesFetch) as! [Route]

            let thisRoute = fetchResults[indexPath.row]
            //let thisMOID = thisRoute.objectID
            //print("\(moID) \(thisMOID)")
            thisRoute.routeName = routeDict["routeName"]
            thisRoute.company   = routeDict["company"]
            
    
            do {
                try moc.save()
                print("saved route \(thisRoute)")
    
            } catch let error as NSError {
                print("Could not save \(error.localizedDescription)")
            }
            
        } catch let error as NSError {
            print("could not fetch results \(error.localizedDescription)")
        }
        

        
    }
    
    
    // MARK: fetched Results controller methods
    
    func initializeFetchedResultsController() {

        self.routesFetch = itemFetchRequest()
        self.frc = NSFetchedResultsController(
                        fetchRequest: self.routesFetch, managedObjectContext: moc,
                        // set this to routeName so that creates sections or set to nil
                        // if not nil then we can display header with TableView:
                        sectionNameKeyPath: "routeName", // "routeName",
                        cacheName: "routesCache")
        self.frc.delegate = self

    }
    
    func itemFetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Route")
        //let routeNameSort = NSSortDescriptor(key: "department.name", ascending: true)
        let routeNameSort = NSSortDescriptor(key: "routeName", ascending: true)
        let createdSort = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [createdSort, routeNameSort]  //departmentSort,
        
        return request
    }
    
    func performFetch() {
        do {
            try self.frc.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }

    }
    
    // MARK: - Auto Table Update from CoreData
    
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
            atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType,
            newIndexPath: NSIndexPath?) {
                
                switch type {
                case .Insert:
                    self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                case .Delete:
                    self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                case .Update:
                    self.configureCell(self.tableView.cellForRowAtIndexPath(indexPath!)! as! RouteTableViewCell, indexPath: indexPath!)
                case .Move:
                    self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                    self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
        self.tableView.reloadData()
    }

    
    // MARK:
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // http://www.andrewcbancroft.com/2015/03/05/displaying-data-with-nsfetchedresultscontroller-and-swift/
        return self.frc.sections!.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return 0 // 1currentRoutes.count
        // http://www.andypierz.com/blog/2014/11/9/basic-drag-and-drop-uitableviews-using-swift-and-core-data
        if self.frc.sections == nil {
            return 0
        }
        
        let sections: [NSFetchedResultsSectionInfo] = self.frc.sections!
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("routeCell", forIndexPath: indexPath) as! RouteTableViewCell //UITableViewCell
        
        //cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
        
        //let route = routes[indexPath.row] as! Route
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: RouteTableViewCell, indexPath: NSIndexPath) {
        let route = self.frc.objectAtIndexPath(indexPath) as! Route
        // Populate cell from the NSManagedObject instance
        //cell.textLabel?.text = route.routeName
        cell.routeNameLabel!.text = "\(route.routeName!)"
        
        //let section = indexPath.section
        //let row = indexPath.row
        //print("Section: \(section)  Row: \(row)")
        //print("\(indexPath.row)" )
        if let sections = self.frc.sections {
            let sectionsCount = sections.count
            //let thisSectionCount = self.tableView.numberOfRowsInSection(section)
            if sectionsCount == 1 {
                cell.routeIndexLabel!.text = "\(indexPath.row + 1)"
            } else {
                cell.routeIndexLabel!.text =  "\(indexPath.section + 1)"  //"\(indexPath.section * (thisSectionCount-1) + indexPath.row+1)"
            }
        }
        //cell.routeIndexLabel!.text = "\(route.stops!.count)"
        //cell.routeIndexLabel.text = "\(route.company!)"
        cell.routeStopCountLabel!.text =  "\(route.stops!.count)" // "\(Int(arc4random_uniform(10)))"
        // http://www.globalnerdy.com/2015/01/26/how-to-work-with-dates-and-times-in-swift-part-one/
        let formatter = NSDateFormatter()
        //formatter.stringFromDate(route.created!)
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        cell.routeCompanyLabel!.text = "\(route.company!) @ \(formatter.stringFromDate(route.created!))"
        //print("Object for configuration: \(route)")
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // do we ha
        if let sections = self.frc.sections {
            let currentSection = sections[section]
            return currentSection.name
        }
        
        return nil
    }



    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            // remove the deleted item from the model
            self.deleteRouteFromIndex(indexPath)
            
        }
        //else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //}
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //print("\(segue.identifier)")
        print("RouteViewController: within prepareForseque")
        if segue.identifier == "ShowDetail" {
            print("RouteViewController: preparing to show Detail")
            let routeDetailNavigationController =  segue.destinationViewController as! UINavigationController
            let routeDetailViewController = routeDetailNavigationController.viewControllers[0] as! RouteInfoTableViewController
            if let selectedRouteCell = sender as? UITableViewCell {
                let indexPath = self.tableView.indexPathForCell(selectedRouteCell)!
                let selectedRoute =  frc.objectAtIndexPath(indexPath) as! Route
                routeDetailViewController.route = selectedRoute
            }
        }
        else if segue.identifier == "AddItem" {
            print("adding a new route")
            
        }
        
        
    }

    
    @IBAction func unwindToRouteView(sender: UIStoryboardSegue) {
        print("Coming from Route View Controller")
        if let sourceViewController = sender.sourceViewController as? RouteDetailViewController, routeDict = sourceViewController.routeDict {
                
            if  routeDict["routeName"] != "" { //let selectedIndexPath =
                print("\(routeDict)")
                saveRouteFromDict(routeDict: routeDict)
            }
            
            
        }
    }


    
    


}
