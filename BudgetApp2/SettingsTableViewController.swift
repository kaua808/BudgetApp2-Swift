//
//  SettingsTableViewController.swift
//  BudgetApp2
//
//  Created by Kaleo Kim on 4/5/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
        var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if user == nil {
            user = UserController.sharedController.currentUser
            
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 1 {
            return 2
        } else {
            return 1
        }
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0 :
            guard let user = user else { return }
            
            if user == UserController.sharedController.currentUser {
                
                UserController.logoutCurrentUser()
                if let navController = self.navigationController {
                    navController.popViewControllerAnimated(true)
                }
                
            }
        case 1 :
            if indexPath.row == 0 {
                print("moneywatch website")
            } else {
                print("icon 8 website")
            }
        case 2 :
            print("app store rating")
        default :
            print("my website")
        }
        
    }

}
