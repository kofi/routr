//
//  RouteDetailViewController.swift
//  RoutR
//
//  Created by Kofi on 9/30/15.
//  Copyright © 2015 38atkins. All rights reserved.
//

import UIKit
import CoreData

class RouteDetailViewController: UIViewController, UITextFieldDelegate {
    
    var isEdit: Bool = false
    var routeDict: [String: String]?
    var route: Route?
    //var index: NSIndexPath?
    var moc =  (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    //: NSManagedObjectContext?
    
    @IBOutlet weak var routeNameLabel: UITextField!
    @IBOutlet weak var companyLabel: UITextField!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        routeNameLabel.delegate = self
        companyLabel.delegate = self
        
        if let route = route {
            navigationItem.title = route.routeName
            routeNameLabel.text = route.routeName
            companyLabel.text = route.company
        }
        
        checkValidRouteInfo()   
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func textFieldDoneEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func backgroundTap(sender: UIControl) {
        routeNameLabel.resignFirstResponder()
        companyLabel.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Disable the Save button while editing.
        checkValidRouteInfo()
        navigationItem.title = routeNameLabel.text!
    }
    
    
    func checkValidRouteInfo() {
        // Disable the Save button if the text field is empty.
        let isRouteNameLabel = (routeNameLabel.text ) ?? ""
        let isCompanyLabel = (companyLabel.text ) ?? ""
        saveButton.enabled = ( !isRouteNameLabel.isEmpty && !isCompanyLabel.isEmpty)
    }

    
    // MARK - Route Editing
    
    func editRoute() {
        
        let routeName = routeNameLabel.text!
        let company = companyLabel.text!
        
        route?.company = company
        route?.routeName = routeName
        do {
            try moc.save()
            print("saved route \(route)")
            
        } catch let error as NSError {
            print("Could not save edit (root) \(error.localizedDescription)")
        }
        
    }
    
    private func saveRouteFromDict(routeDict routeDict : [String: String]) {
        let route = NSEntityDescription.insertNewObjectForEntityForName("Route", inManagedObjectContext: self.moc) as! Route
        //let route1 = Route(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        route.company = routeDict["company"]
        route.created = NSDate()
        route.routeName = routeDict["routeName"]
        
        do {
            try moc.save()
            print("saved route \(route)")
            
        } catch let error as NSError {
            print("Could not save (root) \(error.localizedDescription)")
        }
    }
    

    // MARK: - Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        let isPresentingInAddRouteMode = presentingViewController is UINavigationController
        if isPresentingInAddRouteMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            //dismissViewControllerAnimated(true, completion: nil)
            navigationController!.popViewControllerAnimated(true)
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // see https://developer.apple.com/library/prerelease/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson8.html#//apple_ref/doc/uid/TP40015214-CH16-SW1
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("RouteDetailViewController: within prepareForseque")
        if saveButton === sender {
            let routeName = routeNameLabel.text!
            let company = companyLabel.text!
            self.routeDict = ["routeName": routeName, "company": company ]
            
            if self.isEdit == false {
                //self.saveRouteFromDict(routeDict: self.routeDict!)
                print("RouteDetailViewController: will save")
                
            } else {
                print("RouteDetailViewController: will edit")
                editRoute()
                let routeInfoTableViewController =  segue.destinationViewController as! RouteInfoTableViewController
                routeInfoTableViewController.route = route
                //self.routeDict = ["routeName": "", "company": "" ]
            }
        }

        
    }
    


}
