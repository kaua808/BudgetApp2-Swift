//
//  CategoryDetailTableViewController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/17/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class CategoryDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var category: Category?
    var expenses: [Expense] = []
    
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var commentTextField: UITextField!
    @IBOutlet var expenseHeaderView: UIView!
    @IBOutlet var expenseDetailTableView: UITableView!
    @IBOutlet var myTableHeaderView: UIView!
    @IBOutlet var fillerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillerView.backgroundColor = UIColor(red:0.38, green:0.70, blue:0.16, alpha:1.0)
        myTableHeaderView.backgroundColor = UIColor(red:0.38, green:0.70, blue:0.16, alpha:1.0)
        expenseHeaderView.backgroundColor = UIColor(red:0.51, green:0.55, blue:0.51, alpha:1.0)
        expenseDetailTableView.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
        self.view.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
        
    // Dismiss Keybaord when view is touched
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.commentTextField.delegate = self
        self.dateTextField.delegate = self
        self.priceTextField.delegate = self
        
        self.expenseHeaderView.hidden = true
        
    // gets the category so that the view know what expenses to load
        if let category = category {
            self.title = category.name
            loadExpensesForCategory(category)
        }
    }
    
    // Dismiss Keybaord when view is touched
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func loadExpensesForCategory(category: Category) {
        
        ExpenseController.fetchExpensesForCategories(category) { (expense) -> Void in
            
            if let expenses = expense {
                if expenses.count == 0  {
                    
                } else {
                    self.expenses = expenses.sort({$0.0.date < $0.1.date})
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.expenseDetailTableView.reloadData()
                        self.expenseHeaderView.hidden = false
                    })
                }
            }
        }
    }
    
    @IBAction func priceTextFieldTapped(sender: UITextField) {
        
        sender.inputAccessoryView = doneButtonToolbar(sender)
    }
    // Make the DatePicker comeup for the dat input field
    
    @IBAction func datePickerForTextfield(sender: UITextField) {
        
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.maximumDate = NSDate()
        
        sender.inputView = datePickerView
        sender.inputAccessoryView = doneButtonToolbar(sender)
        
        datePickerView.addTarget(self, action: #selector(handleDatePicker), forControlEvents: UIControlEvents.ValueChanged)
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        dateTextField.text = dateFormatter.stringFromDate(currentDate)
        
    }
    
    func handleDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func doneButtonToolbar(textField: UITextField) -> UIView {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let cancel = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancelTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(doneTapped))
        toolBar.setItems([cancel, spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        return toolBar
    }
    
    func cancelTapped() {
        dateTextField.text = ""
        priceTextField.text = ""
        
        dateTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
    }
    
    func doneTapped() {

        dateTextField.resignFirstResponder()
        priceTextField.resignFirstResponder()
    }
    
    
    @IBAction func addButtonTapped(sender: AnyObject) {
        
        if dateTextField.text == "" || priceTextField.text == "" || commentTextField.text == ""{
            let alert = UIAlertController(title: nil, message: "Please fill in all of the fields", preferredStyle: .Alert)
            
            let okay = UIAlertAction(title: "Okay", style: .Default, handler: nil)
            
            alert.addAction(okay)
            
            presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            if let date = dateTextField.text, price = priceTextField.text, comment = commentTextField.text {
                
                
                
                let formatter = NSDateFormatter()
                formatter.dateFormat = "dd MMM yyyy"
                let formattedDate = formatter.dateFromString(date)
                
                ExpenseController.addNewExpense(formattedDate!, price: Float(price)!, comment: comment, categoryID: (category?.identifier)!, completion: { (success, expense) -> Bool in
                    
                    if expense != nil {
                        
                        self.expenseDetailTableView.reloadData()
                        return true
                    } else {
                        return false
                    }
                })
            }
            self.dateTextField.text = ""
            self.priceTextField.text = ""
            self.commentTextField.text = ""
        }
    }
    
    // MARK: TableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return expenses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = expenseDetailTableView.dequeueReusableCellWithIdentifier("expenseDetailCell", forIndexPath: indexPath) as! ExpenseDetailTableViewCell
        
        let expense = expenses[indexPath.row]
        
        cell.updateWithExpense(expense)
        cell.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
        tableView.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            ExpenseController.deleteExpense(expenses[indexPath.row])
            expenses.removeAtIndex(indexPath.row)
        }
    }
}

extension CategoryDetailTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
