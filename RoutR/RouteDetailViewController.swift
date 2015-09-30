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
    
    
    //let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let isEdit: Bool = false
    var routeDict: [String: String]?
    
    @IBOutlet weak var routeNameLabel: UITextField!
    @IBOutlet weak var companyLabel: UITextField!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        routeNameLabel.delegate = self
        companyLabel.delegate = self
        
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
    

    


    // MARK: - Navigation
    @IBAction func cancel(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // see https://developer.apple.com/library/prerelease/ios/referencelibrary/GettingStarted/DevelopiOSAppsSwift/Lesson8.html#//apple_ref/doc/uid/TP40015214-CH16-SW1
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if saveButton === sender {
            let routeName = routeNameLabel.text!
            let company = companyLabel.text!
            self.routeDict = ["routeName": routeName, "company": company ]
        }
        
    }


}
