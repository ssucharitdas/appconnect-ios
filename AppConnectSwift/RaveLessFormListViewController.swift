//
//  RaveLessFormListViewController.swift
//  AppConnectSwift
//
//  Created by Suman Sucharit Das on 3/31/16.
//  Copyright © 2016 Medidata Solutions. All rights reserved.
//

import UIKit

class RaveLessFormListViewController: UITableViewController {
    
    var forms = [String]()
    var userID : Int64!
    var formID : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        forms = ["Image Upload","Video Upload","Image Path Selection"]
        
        let backButton = UIBarButtonItem(title: "Log Out", style: UIBarButtonItemStyle.Plain, target: self, action: "doLogout")
        self.navigationItem.setLeftBarButtonItem(backButton, animated: true)
        
        // Begin loading the forms for the logged-in user
        loadForms()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Populate the list with forms that are already in the datastore
        populateForms()
    }
    
    func loadForms() {
         
    }
    
    func populateForms() {
                self.tableView.reloadData()
    }
    
    func doLogout() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            if self.formID == "ImageCapture"{
                let controller = segue.destinationViewController as! ImageCapture
                controller.navigationItem.title = nil
                controller.formID = "Image"
            } else if self.formID == "VideoCapture"{
                let controller = segue.destinationViewController as! VideoCapture
                navigationItem.title = nil
                controller.formID = "Video"
            }
            else if self.formID == "ImagePathCapture"{
                let controller = segue.destinationViewController as! ImagePathCapture
                navigationItem.title = nil
                controller.formID = "ImagePath"
            }
        }
    }
    
    // MARK: - Table View
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            self.formID = "ImageCapture"
        }
        else if(indexPath.row == 1){
            self.formID = "VideoCapture"
        }
        else if(indexPath.row == 2){
            self.formID = "ImagePathCapture"
        }
        let sequeIdentifier = self.formID
        performSegueWithIdentifier(sequeIdentifier!, sender: self)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forms.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        cell.textLabel!.text = forms[indexPath.row]
        return cell
    }
    
    
}

