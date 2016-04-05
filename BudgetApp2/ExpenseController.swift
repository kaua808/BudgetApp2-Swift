//
//  ExpenseController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/24/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class ExpenseController {
    
    static func addNewExpense(date: NSDate, price: Float, comment: String, categoryID: String, completion: (success: Bool, expense: Expense?) -> Bool) {
        
        var newExpense = Expense(date: date, price: price, comment: comment, categoryID: categoryID)
        
        newExpense.save()
        
    }
    
    
    // filet the query base on the month they were added
    static func fetchExpensesForCategories(category: Category, completion: (expense: [Expense]?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("expense").queryOrderedByChild("categoryID").queryEqualToValue(category.identifier).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let expenseDictionary = snapshot.value as? [String: AnyObject] {
                
                let expenses = expenseDictionary.flatMap{Expense(json: $0.1 as! [String : AnyObject], identifier: $0.0)}
                
//                let date = NSDate()
//                let calendar = NSCalendar.currentCalendar()
//                let components = calendar.component(.Month, fromDate: date)
//                let month = components
//                
//                let filteredExpense = expenses.sort(<#T##isOrderedBefore: (Expense, Expense) -> Bool##(Expense, Expense) -> Bool#>)
                
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
    
//    static func fetchExpnseForIdentifier(identifier: String, completion:(expense: Expense?) -> Void) {
//        
//        FirebaseController.dataAtEndpoint("/expense/\(identifier)") { (data) -> Void in
//            
//            if let expense = data as? [String: AnyObject] {
//                
//                let jsonExpense = Expense(json: expense, identifier: identifier)
//                completion(expense: jsonExpense)
//                
//            } else {
//                completion(expense: nil)
//            }
//            
//        }
//        
//    }
//    
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