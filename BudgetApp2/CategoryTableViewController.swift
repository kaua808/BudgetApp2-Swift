//
//  CategoryTableViewController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/16/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

let reuseIdentifier = "categoryCell"

class CategoryTableViewController: UITableViewController, CategoryTableViewCellDelegate {
    
    // this is for the expanding cell
    var selectedIndexPath: NSIndexPath?
    var indexPaths: Array<NSIndexPath> = []
    
    //hoding all the categories the user has
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.backgroundColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.0)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if let currentUser = UserController.sharedController.currentUser {
            
            loadCategories(currentUser)
            
            self.title = "money watcher"
            
            //Set Color
//            let attributes: AnyObject = [ NSForegroundColorAttributeName: UIColor.redColor()]
//            self.navigationController!.navigationBar.titleTextAttributes = attributes as? [String : AnyObject]
            
            self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

            //Set Font Size
            self.navigationController!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: "AvenirNext-Bold", size: 25.0)!];
            
        } else {
            navigationController?.performSegueWithIdentifier("noCurrentUserSegue", sender:nil)
        }
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
    
    @IBAction func addCategoryTapped(sender: AnyObject) {
        
        let alert = UIAlertController(title: "Add Category", message: "Enter name and budget amount below", preferredStyle: UIAlertControllerStyle.Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        let save = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action) -> Void in
            if let textFields = alert.textFields,
                let name = textFields[0].text,
                let budgetText = textFields[1].text {
                
                if name == "" || budgetText == "" {
                    let alert = UIAlertController(title: nil, message: "Please fill in all of the fields", preferredStyle: .Alert)
                    
                    let okay = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                    
                    alert.addAction(okay)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                } else {
                    let trimmedBudgetAmount = budgetText.stringByReplacingOccurrencesOfString("$", withString: "")
                    
                    let budgetAmount = Float(trimmedBudgetAmount)
                    
                    CategoryController.addNewCategory(name, budgetAmount: budgetAmount!, completion: { (success, category) -> Bool in
                        
                        if category != nil {
                            return true
                        } else {
                            print("could not add Category")
                            return false
                        }
                        
                    })
                }
                
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        alert.addTextFieldWithConfigurationHandler { (nameField) -> Void in
            nameField.placeholder = "Name"
        }
        alert.addTextFieldWithConfigurationHandler { (nameField) -> Void in
            nameField.placeholder = "Budget Amount"
        }
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Expanding Cell Stuff
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        //        var indexPaths: Array<NSIndexPath> = []
        indexPaths = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            
            tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
            
        }
        
        
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as? CategoryTableViewCell)?.watchFrameChanges()
    }
    
    override func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        (cell as? CategoryTableViewCell)?.ignoreFrameChanges()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [CategoryTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return CategoryTableViewCell.expandedHeight
        } else {
            return CategoryTableViewCell.defaultHeight
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CategoryTableViewCell
        
        let category = categories[indexPath.row]
        
        if indexPaths.count == 2 && indexPath.row == indexPaths[0].row {
            cell.updateWithCategory(category, shouldReload: false)
        } else {
            cell.updateWithCategory(category, shouldReload: true)
        }
        //cell.backgroundColor = UIColor(red:0.55, green:0.76, blue:0.29, alpha:1.0)
        
        cell.delegate = self
        
        return cell
    }
    
    
    
    
    // MARK: - Navigation
    
    //    func toCategoryDetailButtonTapped() {
    //        self.performSegueWithIdentifier("toCategoryDetail", sender: self)
    //    }
    
    func expenseButtonTapped(cell: CategoryTableViewCell) {
        self.performSegueWithIdentifier("toCategoryDetail", sender: cell)
    }
    
    func editButtonTapped(cell: CategoryTableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let alert = UIAlertController(title: "Add Category", message: "Enter name and budget amount below", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
            
            let save = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action) -> Void in
                if let textFields = alert.textFields,
                    let name = textFields[0].text,
                    let budgetText = textFields[1].text {
                    
                    let trimmedBudgetAmount = budgetText.stringByReplacingOccurrencesOfString("$", withString: "")
                    
                    let budgetAmount = Float(trimmedBudgetAmount)
                    
                    
                    CategoryController.updateCategory(self.categories[indexPath.row], name: name, budgetAmount: budgetAmount)
                    
                }
            }
            
            alert.addAction(cancel)
            alert.addAction(save)
            
            alert.addTextFieldWithConfigurationHandler { (nameField) -> Void in
                nameField.placeholder = "Name (Optional)"
            }
            alert.addTextFieldWithConfigurationHandler { (nameField) -> Void in
                nameField.placeholder = "Budget Amount (Optional)"
            }
            
            presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "toCategoryDetail" {
            
            let destinationViewController = segue.destinationViewController as? CategoryDetailTableViewController
            
            if let cell = sender as? UITableViewCell, indexPath = tableView.indexPathForCell(cell) {
                let category = self.categories[indexPath.row]
                destinationViewController?.category = category
            }
        }
    }
    
}

extension CategoryTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
