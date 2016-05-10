//
//  HistoryTableViewController.swift
//  BudgetApp2
//
//  Created by Kaleo Kim on 4/7/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    var user: User?
    
    var categories: [Category] = []
    var expenses: [Expense] = []
    
    let monthArray = ["January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var categorizedExpenses: [String : [Expense]] = [:]
    
    
    @IBOutlet var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserController.sharedController.currentUser {
            loadCategories(user)
        }
        
        ExpenseController.fetchExpensesForHistory(2016) { (expenses) in
            self.categorizedExpenses = expenses
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadCategories(user: User) {
        CategoryController.fetchCategoriesForUSer(user) { (categories) -> Void in
            if let categories = categories {
                self.categories = categories.sort({$0.0.name < $0.1.name})
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    // fectch all expenses for categories, sort through that more the month
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return monthArray.count
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 1:
            return CategoryController.sharedController.monthsArray[0].count
        case 2:
            return CategoryController.sharedController.monthsArray[1].count
        case 3:
            return CategoryController.sharedController.monthsArray[2].count
        case 4:
            return CategoryController.sharedController.monthsArray[3].count
        case 5:
            return CategoryController.sharedController.monthsArray[4].count
        case 6:
            return CategoryController.sharedController.monthsArray[5].count
        case 7:
            return CategoryController.sharedController.monthsArray[6].count
        case 8:
            return CategoryController.sharedController.monthsArray[7].count
        case 9:
            return CategoryController.sharedController.monthsArray[8].count
        case 10:
            return CategoryController.sharedController.monthsArray[9].count
        case 11:
            return CategoryController.sharedController.monthsArray[10].count
        case 12:
            return CategoryController.sharedController.monthsArray[11].count
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCategoryCell", forIndexPath: indexPath) as? HistoryCategoryTableViewCell

        let section = CategoryController.sharedController.monthsArray[indexPath.section]
        let category = section[indexPath.row]
        
        //cell?.updateWithCategory(category)
        

        return cell ?? UITableViewCell()
    }
 

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthSectionHeader") as! MonethSectionHeaderTableViewCell
        
        let month = monthArray[section]
        
        cell.monthLabel.text = month
        
        return cell.contentView
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
