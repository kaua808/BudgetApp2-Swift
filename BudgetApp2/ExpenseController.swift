//
//  ExpenseController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/24/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class ExpenseController {
    
    static func addNewExpense(date: String, price: Float, comment: String, categoryID: String, completion: (success: Bool, expense: Expense?) -> Bool) {
        
        var newExpense = Expense(date: date, price: price, comment: comment, categoryID: categoryID)
        
        newExpense.save()
        
    }
    
    
    // filet the query base on the month they were added
    static func fetchExpensesForCategories(category: Category, completion: (expense: [Expense]?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("expense").queryOrderedByChild("categoryID").queryEqualToValue(category.identifier).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let expenseDictionary = snapshot.value as? [String: AnyObject] {
                
                let expenses = expenseDictionary.flatMap{Expense(json: $0.1 as! [String : AnyObject], identifier: $0.0)}
                
                completion(expense: expenses)
            } else {
                completion(expense: nil)
            }
            
        })
        
    }
    
}