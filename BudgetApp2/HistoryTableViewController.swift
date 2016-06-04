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
    
    let monthArray = NSCalendar.currentCalendar().monthSymbols
    
    var categorizedExpenseList: CategorizedExpenseList?
    
    var categorizedExpenses: [CategorizedExpenses]?
    
    @IBOutlet var yearTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserController.sharedController.currentUser {
            loadCategories(user)
        }
        
        ExpenseController.fetchExpensesForHistory(2016) { (expenses) in
            
            var fetchedExpenses: [Expense] = []
            
            for (_, value) in expenses {
                fetchedExpenses.appendContentsOf(value)
            }
            
            let fullCategorizedExpenseList: CategorizedExpenseList = ExpenseController.expensesGroupedByCategoryAndDate(fetchedExpenses, selectedYear: 2016)!
            
            var categorizedExpenses: [CategorizedExpenses] = []
            
            for (_, value) in fullCategorizedExpenseList {
                categorizedExpenses.append(value)
            }
            
            self.categorizedExpenses = categorizedExpenses
            
            self.tableView.reloadData()
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
        
        return categorizedExpenseList?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        // number of categories in a month
        
        let key = categorizedExpenseList?.keys[section]
        
        return categorizedExpenseList?[key]?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCategoryCell", forIndexPath: indexPath) as? HistoryCategoryTableViewCell

        // filter self.categorizedExpenses by date
        // get expense at index path
        // set up cell
//        
//        let categoryName = categoriesArrayByMonth[indexPath.section][indexPath.row]
//        let expenses = categoriesByMonth[indexPath.section][categoryName] ?? []
//        guard let category = expenses.first?.category else {return UITableViewCell()}
//        
//        cell?.updateWithCategoryAndExpenses(category, expenses: expenses)
        
        let month = monthArray[indexPath.section]
        let categoryName = categorizedExpenseList?[month]?.first?.0
        let expenses = categorizedExpenseList?[month]?.first?.1
        
        if let categoryName = categoryName,
            let category = self.categories.filter({ $0.name == categoryName }).last,
            let expenses = expenses {
            
            cell?.updateWithCategoryAndExpenses(category, expenses: expenses)
        }
        
        return cell ?? UITableViewCell()
    }
 

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("monthSectionHeader") as! MonethSectionHeaderTableViewCell
        
        let month = monthArray[section]
        
        cell.monthLabel.text = month
        
        return cell.contentView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    
//    func organizeExpensesByMonth() -> [[Expense]] {
//        let expenses = categorizedExpenses.flatMap {$0.1.flatMap {$0}}
//        
//        
//        let group = dispatch_group_create()
//        for expense in expenses {
//            dispatch_group_enter(group)
//            CategoryController.fetchCategoryForExpense(expense, completion: { (category) in
//                expense.category = category
//                dispatch_group_leave(group)
//            })
//        }
//        dispatch_group_notify(group, dispatch_get_main_queue()) {
//            self.tableView.reloadData()
//        }
//        var monthArray: [[Expense]] = [[],[],[],[],[],[],[],[],[],[],[],[]]
//        for (index, _) in monthArray.enumerate() {
//            monthArray[index] += expenses.filter {$0.isCurrentYear && $0.month == index + 1}
//        }
//        return monthArray
//    }
//    
//    func organizeCategoriesByMonth() -> [[String: [Expense]]] {
//        var monthArray: [[String: [Expense]]] = [[:],[:],[:],[:],[:],[:],[:],[:],[:],[:],[:],[:]]
//        for (index, _) in monthArray.enumerate() {
//            let monthExpenses = expensesByMonth[index]
//            for expense in monthExpenses {
//                if var categoryMonthExpenses = monthArray[index][expense.categoryName] {
//                    categoryMonthExpenses += [expense]
//                    monthArray[index][expense.categoryName] = categoryMonthExpenses
//                } else {
//                    monthArray[index][expense.categoryName] = [expense]
//                }
//            }
//        }
//        categoriesArrayByMonth = []
//        for month in monthArray {
//            categoriesArrayByMonth.append(Array(month.keys))
//        }
//        return monthArray
//    }
//    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
