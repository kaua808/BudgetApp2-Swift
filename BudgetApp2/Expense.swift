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
    private let kCategoryName = "categoryName"
    
    var date: NSDate
    var price: Float
    var comment: String
    var categoryName: String
    let calendar: NSCalendar = NSCalendar.currentCalendar()
    var year: Int {
        let component = calendar.component(.Year, fromDate: date)
        return component
    }
    
    var month: Int {
        let month = calendar.component(.Month, fromDate: date)
        return month
    }
    
    var isCurrentYear: Bool {
        let currentYear = calendar.component(.Year, fromDate: NSDate())
        return currentYear == year
    }
    var category: Category?
    
    var identifier: String?
    var endpoint: String {
        return "expense"
    }
    var jsonValue: [String: AnyObject] {
        let json: [String: AnyObject] = [kDate: date.timeIntervalSince1970, kPrice: price, kComment: comment, kCategoryName: categoryName]
        
        return json
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        
        guard let dateInterval = json[kDate] as? NSTimeInterval,
            let price = json[kPrice] as? Float,
            let comment = json[kComment] as? String,
            let categoryName = json[kCategoryName] as? String else {
                
                self.date = NSDate()
                self.price = 0
                self.comment = ""
                self.categoryName = ""
                
                return nil
        }
        
        self.date = NSDate(timeIntervalSince1970: dateInterval)
        self.price = price
        self.comment = comment
        self.identifier = identifier
        self.categoryName = categoryName
        
    }
    
    init(date: NSDate, price: Float, comment: String, categoryName: String) {
        
        self.date = date
        self.price = price
        self.comment = comment
        self.categoryName = categoryName
        
    }
    
}

func ==(lhs: Expense, rhs: Expense) -> Bool {
    
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}