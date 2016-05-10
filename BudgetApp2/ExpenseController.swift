//
//  ExpenseController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/24/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class ExpenseController {
    
    static func addNewExpense(date: NSDate, price: Float, comment: String, categoryName: String, completion: (success: Bool, expense: Expense?) -> Bool) {
        
        var newExpense = Expense(date: date, price: price, comment: comment, categoryName: categoryName)
        
        newExpense.save()
        
    }
    
    
    // filet the query base on the month they were added
    static func fetchExpensesForCategories(category: Category, completion: (expense: [Expense]?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("expense").queryOrderedByChild("categoryName").queryEqualToValue(category.name).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let expenseDictionary = snapshot.value as? [String: AnyObject] {
                
                let expenses = expenseDictionary.flatMap{Expense(json: $0.1 as! [String : AnyObject], identifier: $0.0)}
                
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Month, .Year], fromDate: NSDate())
                let filteredExpenses = expenses.filter { (expense) -> Bool in
                    let expenseComponents = calendar.components([.Month, .Year], fromDate:expense.date)
                    return expenseComponents.month == components.month && expenseComponents.year == components.year
                }
                
                completion(expense: filteredExpenses)
            } else {
                completion(expense: nil)
            }
            
        })
        
    }
    
    // fetch expenses for the history view
    
    static func fetchExpensesForHistory(year: Int, completion: (expenses: [String: [Expense]]) -> Void) {
        
        guard let dateRange = ExpenseController.timeIntervalForYear(year) else { return }
        
        FirebaseController.base.childByAppendingPath("expense").queryOrderedByChild("date").queryStartingAtValue(dateRange.0).queryEndingAtValue(dateRange.1).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            if let expenseDictionary = snapshot.value as? [String: AnyObject] {
                
                // serialize into expense objects
                let expenses = expenseDictionary.flatMap{Expense(json: $0.1 as! [String : AnyObject], identifier: $0.0)}
                // map categories to a set
                let categoriesNameSet = Set(expenses.map{$0.categoryName})
                
                // create dictionary with categories as keys and filter list as values
                var dictionary: [String: [Expense]] = [:]
                
                for key in categoriesNameSet {
                    dictionary.updateValue(expenses.filter({$0.categoryName == key}), forKey: key)
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completion(expenses: dictionary)
                })
            }
        })
    }
    
    static func timeIntervalForYear(year: Int) -> (start: NSTimeInterval, end: NSTimeInterval)? {
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy"
        
        guard let formattedYear = formatter.dateFromString(String(year)),
        let firstDayOfTheYear = NSCalendar.currentCalendar().dateWithEra(1, year: NSCalendar.currentCalendar().component(.Year, fromDate: formattedYear), month: 1, day: 1, hour: 0, minute: 0, second: 0, nanosecond: 0),
            let lastDayOfTheYear = NSCalendar.currentCalendar().dateWithEra(1, year: NSCalendar.currentCalendar().component(.Year, fromDate: formattedYear), month: 12, day: 31, hour: 23, minute: 59, second: 59, nanosecond: 0) else {
            return nil
        }
        return (firstDayOfTheYear.timeIntervalSince1970, lastDayOfTheYear.timeIntervalSince1970)
    }
    
    
    static func deleteExpense(expense: Expense) {
        
        expense.delete()
        
    }
    
}

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }