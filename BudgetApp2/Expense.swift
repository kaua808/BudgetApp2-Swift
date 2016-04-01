//
//  Expense.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/24/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class Expense: Equatable, FirebaseType {
    
    private let kDate = "date"
    private let kPrice = "price"
    private let kComment = "comment"
    private let kCategoryID = "categoryID"
    
    var date: String
    var price: Float
    var comment: String
    var categoryID: String
    var identifier: String?
    var endpoint: String {
        return "expense"
    }
    var jsonValue: [String: AnyObject] {
        let json: [String: AnyObject] = [kDate: date, kPrice: price, kComment: comment, kCategoryID: categoryID]
        
        return json
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        
        guard let date = json[kDate] as? String,
            let price = json[kPrice] as? Float,
            let comment = json[kComment] as? String,
            let categoryID = json[kCategoryID] as? String else {
                
                self.date = ""
                self.price = 0
                self.comment = ""
                self.categoryID = ""
                
                return nil
        }
        
        self.date = date
        self.price = price
        self.comment = comment
        self.categoryID = categoryID
        
    }
    
    init(date: String, price: Float, comment: String, categoryID: String) {
     
        self.date = date
        self.price = price
        self.comment = comment
        self.categoryID = categoryID
        
    }
    
}

func ==(lhs: Expense, rhs: Expense) -> Bool {
    
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}