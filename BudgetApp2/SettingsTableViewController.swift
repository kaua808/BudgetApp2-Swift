//
//  SettingsTableViewController.swift
//  BudgetApp2
//
//  Created by Kaleo Kim on 4/5/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit
import MessageUI

class SettingsTableViewController: UITableViewController, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
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
        return 1
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
            showMailForFeedback()
        case 2 :
            UIApplication.sharedApplication().openURL(NSURL(string: "itms://itunes.apple.com/us/app/money-watch-month-to-month/id1099329001?mt=8")!)
        default :
            print("my website")
        }
        
    }
    
    func showMailForFeedback() {
        let feedbackViewController = MFMailComposeViewController()
        
        feedbackViewController.setToRecipients(["moneywatchbudgetapp@gmail.com"])
        feedbackViewController.setSubject("Hey MoneyWatch!")
        feedbackViewController.setMessageBody("Dear MoneyWatch,", isHTML: false)
        feedbackViewController.mailComposeDelegate = self
        
        presentViewController(feedbackViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
