//
//  CategoryController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/23/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class CategoryController {
    
    //Add Category
    
    static func addNewCategory(name: String, budgetAmount: Float, completion: (success: Bool, category: Category?) -> Bool) {
        
        let userID = UserController.sharedController.currentUser.identifier!
        
        var newCategory = Category(name: name, budgetAmount: budgetAmount, userID: userID)
        newCategory.save()
        
        
    }
    
    //Get all Cateogries for user
    
    static func fetchCategoriesForUSer(user: User, completion: (categories: [Category]?) -> Void) {
        
        FirebaseController.base.childByAppendingPath("category").queryOrderedByChild("userID").queryEqualToValue(user.identifier).observeEventType(.Value, withBlock: { (snapshot) -> Void in
            
            if let categoryDictionaries = snapshot.value as? [String: AnyObject] {
                
                let categories = categoryDictionaries.flatMap{Category(json: $0.1 as! [String : AnyObject], identifier: $0.0)}
                
                completion(categories: categories)
            } else {
                completion(categories: nil)
            }
        })
    }
    
    static func updateCategory(category: Category, name: String?, budgetAmount: Float?) {
        
        guard let categoryID = category.identifier else {return}
        
        CategoryController.fetchCategoryForIdentifier(categoryID) { (category) in
            if var updatedCategory = category {
                
                if let newAmount = budgetAmount {
                    updatedCategory.budgetAmount = newAmount
                    
                }
                if let newName = name {
                    updatedCategory.name = newName
                }
             
                updatedCategory.save()

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
    
    
    
}