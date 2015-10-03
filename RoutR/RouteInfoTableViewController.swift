//
//  RouteInfoTableViewController.swift
//  RoutR
//
//  Created by Kofi on 10/1/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation


class RouteInfoTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, MKMapViewDelegate {
    
    let infoSections = ["Route","Stops","Maps"]
    let infoCell = "routeInfoDetailCell"
    let spotsCell = "routeInfoStopsCell"
    let mapCell = "routeMapCell"
    var route: Route?
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var routeDistances : [Float] = []
    
    var frc: NSFetchedResultsController!
    var stopsFetch = NSFetchRequest() // NSFetchRequest(entityName: "Stop")
    
    var fetchStopResults : [Stop] = []
    var storeLocation: [NSManagedObjectID: StoreLocation] = [NSManagedObjectID: StoreLocation]()
    
    
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
        getAllStopLocations()
        routeDistances = route!.getDistanceBetweenStops()
//        print("\(route)")
//        print("")
//        print("\(route?.stops)")
//        print("")

        

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
        //return section == 0 ? 1:
        switch section {
        case 0:
            return 1
        case 1:
            return (route!.stops?.count)!
        default:
            return 1
        }

    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section != 0 {
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
        switch indexPath.section {
        case 0:
            // we are in the info section
            let cell = tableView.dequeueReusableCellWithIdentifier(infoCell, forIndexPath: indexPath) as! RouteDetailTableViewCell
            configureInfoCell(cell: cell, indexPath: indexPath)
            
            return cell
        case 1:
            // we want to loop over the stops
            let cell = tableView.dequeueReusableCellWithIdentifier(spotsCell, forIndexPath: indexPath) as! RouteStopsTableViewCell
            configureSpotsCell(cell: cell, indexPath: indexPath)
            
            return cell
        
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier(mapCell, forIndexPath: indexPath) as! RouteStopsMapsCell
            configureMapsCell(cell: cell)
            return cell
        }
        
    }
    
    
    // MARK: Configure Map Views
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? StoreLocation {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView { // 2
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                // 3
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            }
            return view
        }
        return nil
        
        
    }
    
    
    // MARK: Configure custom cells

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
        // print("\(indexPath)") //        print("\(indexPath.section)")//        print("\(indexPath.row)")
        //print("Configuring SpotsCell")
        //print("")
        //print("Index path :\(indexPath)")
        //print("Indexpath row: \(indexPath.row)")
        
        let stop = self.fetchStopResults[indexPath.row] // stop = self.frc.objectAtIndexPath(indexPath) as? Stop {
        cell.firstNameLabel.text = "\(stop.firstName!) \(stop.lastName!)"
        //cell.lastNameLabel.text = "\(stop.lastName!)"
        cell.addressLabel.text = "\(stop.houseNumber!) \(stop.street!), \(stop.town!), \(stop.state!), \(stop.zipCode!)"
        let stopIndex = stop.getIndexForRoute((route?.objectID)!)
        //let stopDistance = 0 //routeDistances[stopIndex]
         var stopDistance = Double(routeDistances[stopIndex])
        
        let stopLocation = storeLocation[stop.objectID]  //StoreLocation(title: "", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        //stop.getStoreLocation(stopLocation)
        if stopLocation != nil {
            let stopCLLocation = CLLocation(latitude: stopLocation!.coordinate.latitude, longitude: stopLocation!.coordinate.longitude)
            
            //let stopCount = route!.stops!.count
           
            
            switch stopIndex {
            case 0:
                stopDistance = 0
            default:
                let prevStop = route?.getStopForIndex(stopIndex - 1)
                
                let prevStopLocation = storeLocation[prevStop!.objectID]  // StoreLocation(title: "", locationName: "", discipline: "", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))
                //prevStop!.getStoreLocation(prevStopLocation)
                if prevStopLocation != nil {
                    let prevStopCLLocation = CLLocation(latitude: prevStopLocation!.coordinate.latitude, longitude: prevStopLocation!.coordinate.longitude)
                    
                    stopDistance = stopCLLocation.distanceFromLocation(prevStopCLLocation)
                    
                    stopDistance = stopDistance * 0.000621371
                }
            }
        }
        
        cell.distanceToLabel.text = NSString(format: "%.2f", stopDistance) as String
        cell.timeToLabel.text = "10 mins"
    }
    
    func setStoreLocation(placemark: CLPlacemark, stop: Stop){
        let placemark = placemark
        let placelocation = placemark.location
        let stopCoordinates = placelocation!.coordinate
        let mylocation = StoreLocation(title: stop.getTitle(), locationName: stop.getPatientName(), discipline: "Patient",coordinate: stopCoordinates)
        print("location is \(mylocation)")
        //genLocation = "location is \(mylocation)"
        //print(genLocation)
        storeLocation[stop.objectID] = mylocation
        
        //http://stackoverflow.com/questions/8306792/uitableview-reload-section
        let indexSet: NSMutableIndexSet = NSMutableIndexSet()
        indexSet.addIndex(0)
        indexSet.addIndex(1)
        //let range = NSMakeRange(1,1)
        //indexSet.indexesInRange(range, options: nil, passingTest: nil)
        //self.tableView.reloadData()
        self.tableView.reloadSections(indexSet, withRowAnimation: UITableViewRowAnimation.Left)
        
        //CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589))
        
    }
    
    func getAllStopLocations() {
        for stop in (route?.stops)! {
            let address = (stop as! Stop).getAddress()
            getPlacemarkFromLocation(address, stop: (stop as! Stop))
        }
    }
    
    func configureMapsCell(cell cell: RouteStopsMapsCell) {
        /*
        // See http://stackoverflow.com/questions/31360885/clgeocoder-swift-2-version
        // https://github.com/varshylmobile/LocationManager
        // http://www.techotopia.com/index.php/An_Example_Swift_iOS_8_MKMapItem_Application
        // http://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
        // http://stackoverflow.com/questions/25364418/pairing-mkannotation-to-uitableviewcell
        */
        print("configuring the maps")
        cell.stopsMap.delegate = self
        //cell.initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
        cell.initialLocation = CLLocation(latitude: 42.3601, longitude: -71.0589) // Boston
        cell.centerMapOnLocation(cell.initialLocation!)
        
        
        let stopIndexCount : Int = 0
        
        for stop in (self.route?.stops)!  {
            
            let routeStop = stop as! Stop
            
            let stopIndexInRoute = routeStop.getIndexForRoute((self.route?.objectID)!)
            print("\(stopIndexInRoute)")
            
            let title = "\(routeStop.firstName!) \(routeStop.lastName!)"
            print("Index of \(title) in \(route?.routeName) is \(stopIndexInRoute)")
            
            let discipline = "Patient"
            let locationName = "\(routeStop.houseNumber!) \(routeStop.street!)"
            
            // get the address string we are going to use to find the coordinates
            let addressString = "\(routeStop.houseNumber!) \(routeStop.street!), \(routeStop.town!), \(routeStop.state!), \(routeStop.zipCode!)"
            
            // find the location coordinates from the address using CLGeocoder
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(addressString) { (placemarks, error) -> Void in
                // if we don't get back and address
                if error != nil {
                    print("Error finding location for \(title) | \(error)")
                } else {
                    
                    let placemark = placemarks![0]
                    let location = placemark.location
                    let stopCoordinates = location!.coordinate
                    let stopLocation = StoreLocation(
                        title: title, locationName: locationName, discipline: discipline,coordinate: stopCoordinates)  //CLLocationCoordinate2D(latitude: 42.3601, longitude: -71.0589))
                    
                    if stopIndexCount == 0 {
                        cell.initialLocation = CLLocation(latitude: stopCoordinates.latitude, longitude: stopCoordinates.longitude)  //CLLocation(latitude: 42.3601, longitude: -71.0589) // Boston
                        cell.centerMapOnLocation(cell.initialLocation!)
                    }
                    
                    cell.stopsMap.addAnnotation(stopLocation)
                }
                
            }
            
        }
    
    }
    
    func getPlacemarkFromLocation(address: String, stop: Stop){
        // See http://stackoverflow.com/questions/24345296/swift-clgeocoder-reversegeocodelocation-completionhendler-closure
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if (error != nil) {
                print("geodcode fail: \(error!.localizedDescription)")
            } else {
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    self.setStoreLocation(pm[0] as CLPlacemark, stop: stop)
                }
            }
        })
    }
    
    //func getDistanceBetweenStop
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 50
        case 1:
            return 60
        
        default:
            return 200
        }

    }
    
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
        //let indexSort = NSSortDescriptor(key: "ANY route.getIndexForStop", ascending: true)
        //let routeNameSort = NSSortDescriptor(key: "routeName", ascending: true)
        let createdSort = NSSortDescriptor(key: "created", ascending: false)
        
        request.sortDescriptors = [createdSort]  //departmentSort,
        //request.predicate =  NSPredicate(format:"ANY  route.routeName = %@", (route?.routeName)!)
        //print("Route Object ID: \(route?.objectID)")
        //print("")
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

    // MARK: Navigation
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
