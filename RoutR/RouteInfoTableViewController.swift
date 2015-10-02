//
//  RouteInfoTableViewController.swift
//  RoutR
//
//  Created by Kofi on 10/1/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import UIKit
import CoreData

class RouteInfoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    let infoSections = ["Route","Stops"]
    let infoCell = "routeInfoDetailCell"
    let spotsCell = "routeInfoStopsCell"
    var route: Route?
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var frc: NSFetchedResultsController!
    var stopsFetch = NSFetchRequest() // NSFetchRequest(entityName: "Stop")
    
    var fetchStopResults : [Stop] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        initializeFetchedResultsController()
        
        navigationItem.title = self.route!.routeName
        performFetch()
        executeStopFetchResult()
        print("\(route)")
        print("")
        print("\(route?.stops)")
        print("")

    }


    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return infoSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 1: (route!.stops?.count)!

    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return infoSections[section]
        }
        return ""
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 15
    }
    


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...
        if indexPath.section == 0 {
            // we are in the info section
            let cell = tableView.dequeueReusableCellWithIdentifier(infoCell, forIndexPath: indexPath) as! RouteDetailTableViewCell
            configureInfoCell(cell: cell, indexPath: indexPath)
            
            return cell
            
        } else {
            // we want to loop over the stops
            let cell = tableView.dequeueReusableCellWithIdentifier(spotsCell, forIndexPath: indexPath) as! RouteStopsTableViewCell
            configureSpotsCell(cell: cell, indexPath: indexPath)
            
            return cell
        }

        //return cell
    }

    func configureInfoCell(cell cell: RouteDetailTableViewCell, indexPath: NSIndexPath){
        cell.companyLabel.text = route!.company
        let formatter = NSDateFormatter()
        //formatter.stringFromDate(route.created!)
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        cell.createdLabel.text = " @ \(formatter.stringFromDate(route!.created!))"
        cell.totalDistanceLabel.text = "20 mi."
        cell.totalTimeTable.text = "2.5 hrs"

    }
    
    
    func configureSpotsCell(cell cell: RouteStopsTableViewCell, indexPath: NSIndexPath) {
//        print("\(indexPath)")
//        print("\(indexPath.section)")
//        print("\(indexPath.row)")
        //print("Configuring SpotsCell")
        print("")
        print("Index path :\(indexPath)")
        print("Indexpath row: \(indexPath.row)")
        
        let stop = self.fetchStopResults[indexPath.row] // stop = self.frc.objectAtIndexPath(indexPath) as? Stop {
        cell.firstNameLabel.text = "\(stop.firstName!) \(stop.lastName!)"
        //cell.lastNameLabel.text = "\(stop.lastName!)"
        cell.addressLabel.text = "\(stop.houseNumber!) \(stop.street!), \(stop.town!), \(stop.state!), \(stop.zipCode!)"
        cell.distanceToLabel.text = "5 mi."
        cell.timeToLabel.text = "10 mins"
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 50
        } else {
            return 60
        }
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
    
    // MARK: Fetch routines
    
    func initializeFetchedResultsController() {
        //http://stackoverflow.com/questions/4217849/core-data-nspredicate-for-many-to-many-relationship-to-many-key-not-allowed
        self.stopsFetch = itemFetchRequest()
        //request.predicate =  NSPredicate(format:"ANY route.routeName =[cd] %@ && ANY route.company =[cd] %@", (route?.routeName)!, (route?.company)!) //argumentArray:[route?.routeName])
        
        //request.predicate =  NSPredicate(format:"ANY route.routeName =[cd] %@ && route.company CONTAINS[cd] %@", (route?.routeName)!, (route?.company)!)
        //[NSPredicate predicateWithFormat:@"phone_number.phone_number like[cd] %@",  @"+972-54*"];
        self.frc = NSFetchedResultsController(
            fetchRequest: self.stopsFetch, managedObjectContext: moc,
            // set this to routeName so that creates sections or set to nil
            // if not nil then we can display header with TableView:
            sectionNameKeyPath: nil, //"routeName", // "routeName",
            cacheName: "stopsCache")
        self.frc.delegate = self
        
    }
    
    func itemFetchRequest() -> NSFetchRequest {
        let request = NSFetchRequest(entityName: "Stop")
        //let routeNameSort = NSSortDescriptor(key: "department.name", ascending: true)
//        let routeNameSort = NSSortDescriptor(key: "routeName", ascending: true)
//        let createdSort = NSSortDescriptor(key: "created", ascending: false)
        request.sortDescriptors = [] //createdSort, routeNameSort]  //departmentSort,
        //request.predicate =  NSPredicate(format:"ANY  route.routeName = %@", (route?.routeName)!)
        print("Route Object ID: \(route?.objectID)")
        print("")
        request.predicate =  NSPredicate(format:"ANY route == %@", route!.objectID)
        //request.predicate =  NSPredicate(format:"ANY route.routeName =[cd] %@ && route.company CONTAINS[cd] %@", (route?.routeName)!, (route?.company)!)
        //let myStops = self.route?.stops
        //request.predicate =  NSPredicate(format:"ANY route.routeName =[cd] %@ && ANY route.company =[cd] %@",
        //    (route?.routeName)!, (route?.company)!)

        
        return request
    }
    
    func performFetch() {
        do {
            try self.frc.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
    }
    
    func executeStopFetchResult() {
        do {
            fetchStopResults = try moc.executeFetchRequest(stopsFetch) as! [Stop]
            //print("\(fetchStopResults)")
        } catch let error as NSError {
            print("\(error.localizedDescription)")
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
                self.configureSpotsCell(cell: self.tableView.cellForRowAtIndexPath(indexPath!)! as! RouteStopsTableViewCell, indexPath: indexPath!)
            case .Move:
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                self.tableView.insertRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

    // MARK: segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("\(segue.identifier) in Route Info")
        if segue.identifier == "EditRoute" {
            //let routeDetailNavigationController =  segue.destinationViewController as! UINavigationController
            let routeDetailViewController = segue.destinationViewController as! RouteDetailViewController
            
            routeDetailViewController.routeDict = ["routeName": route!.routeName!, "company": route!.company!]
            routeDetailViewController.route = route
            routeDetailViewController.isEdit = true
            //routeDetailViewController.index = indexPath
            

        }
        else if segue.identifier == "AddItem" {
            print("adding a new route")
            
        }
        
    }
    
    @IBAction func unwindToRouteView(sender: UIStoryboardSegue) {
        // use the same name as the segue in the RootViewController
        
        if let sourceViewController = sender.sourceViewController as? RouteDetailViewController, route  = sourceViewController.route {
                print("Coming from Route Info Table View Controller")
            // call reload here so we can refresh any changed Route data
                self.tableView.reloadData()
//                self.routeDict = ["routeName": route.routeName!, "company": route.company! ]
//                editRoute()
//                self.routeDict = ["routeName": "", "company": "" ]
//                
                //sender.destinationViewController = sourceViewController
        }
        
    }
    

    
    


}
