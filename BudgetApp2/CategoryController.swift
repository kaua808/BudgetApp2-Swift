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
    
    
    
    //Delete Category
    //EditCategory
    
}