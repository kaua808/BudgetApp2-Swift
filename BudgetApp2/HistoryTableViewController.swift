//
//  HistoryTableViewController.swift
//  BudgetApp2
//
//  Created by Kaleo Kim on 4/7/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var user: User?
    
    var years: [String] = []
    
    @IBOutlet var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if user == nil {
            user = UserController.sharedController.currentUser
        }
        
        for i in 1990 ..< 2025 {
            let iString = String(i)
            self.years.append(iString)
        }
    }
    
    //MARK: - UIPickerView Protocol Methods
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.years.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.years[row]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */
}
