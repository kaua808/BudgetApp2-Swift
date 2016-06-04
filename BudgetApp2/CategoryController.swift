//
//  CategoryController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/23/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class CategoryController {
    
//    static var expensesByMonth: [[Expense]] = []
//    static var categoriesArrayByMonth: [[String]] = [[],[],[],[],[],[],[],[],[],[],[],[]]
    
    static func addNewCategory(name: String, budgetAmount: Float, completion: (success: Bool, category: Category?) -> Bool) {
        
        let userID = UserController.sharedController.currentUser.identifier!
        
        var newCategory = Category(name: name, budgetAmount: budgetAmount, isVisible: true, createdDate: NSDate(), deletedDate: nil, userID: userID)
        
        newCategory.save()
        
        
    }
    
    //Get all Cateogries for user
    
    static func fetchCategoriesForUSer(user: User, completion: (categories: [Category]?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("category").queryOrderedByChild("userID").queryEqualToValue(user.identifier).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let categoryDictionaries = snapshot.value as? [String: AnyObject] {
                
                let categories = categoryDictionaries.flatMap{Category(json: $0.1 as! [String : AnyObject], identifier: $0.0)}
                let filteredCategories = categories.filter({ (category) -> Bool in
                    
                    var categoryIsVisibleArray: [Category] = []
                    if category.isVisible {
                        categoryIsVisibleArray.append(category)
                        return true
                    } else {
                        
                        return false
                    }
                })
                completion(categories: filteredCategories)
            
            } else {
                completion(categories: nil)
            }
        })
    }
    
    
    // Edit a Category
    
    static func updateCategory(category: Category, budgetAmount: Float?, notVisible: Bool) {
        
        guard let categoryID = category.identifier else {return}

        CategoryController.fetchCategoryForIdentifier(categoryID) { (category) in
            if var updatedCategory = category {
                
                updatedCategory.isVisible = notVisible
    
                updatedCategory.save()

            }
        }
        
        if let budgetAmount = budgetAmount {
            CategoryController.addNewCategory(category.name, budgetAmount: budgetAmount) { (success, category) -> Bool in
                if category != nil {
                    return true
                } else {
                    print("could not add Category")
                    return false
                }
            }
        }
    }
    
    static func fetchCategoryForIdentifier(identifier: String, completion: (category: Category?) -> Void) {
        
        FirebaseController.dataAtEndpoint("/category/\(identifier)") { (data) -> Void in
         
            if let category = data as? [String: AnyObject] {
                
                let updatedCategory = Category(json: category, identifier: identifier)
                completion(category: updatedCategory)
                
            } else {
                completion(category: nil)
            }
        }
    }
    
    static func fetchCategoryForExpense(expense: Expense, completion: (category: Category?) -> Void) {
        
        // fetch categories
        
        FirebaseController.base.childByAppendingPath("category").queryOrderedByChild("name").queryEqualToValue(expense.categoryName).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
        
            if let categoryDictionaries = snapshot.value as? [String: AnyObject] {
                
                let categories = categoryDictionaries.flatMap{Category(json: $0.1 as! [String : AnyObject], identifier: $0.0)}
                
                //sort the array and then filter the array anything passed it.  and then take the firt or last one from it
                let sortedCategories = categories.sort{$0.createdDate > $1.createdDate}
                
                print(sortedCategories)
                
                let filteredCategories = sortedCategories.filter({ (category) -> Bool in
                    return expense.date < category.createdDate
                })
                print(filteredCategories)
                
                completion(category: filteredCategories.first)
            }
        
        })
        
    }
    
//    static func organizeCategoriesByMonth() -> [[String: [Expense]]] {
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
    
}