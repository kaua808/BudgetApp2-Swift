//
//  Category.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/17/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class Category: Equatable, FirebaseType {
 
    private let kName = "name"
    private let kBudgetAmount = "budgetAmount"
    private let kIsVisible = "isVisible"
    private let kUserID = "userID"
    private let kCreatedDate = "createdDate"
    private let kDeletedDate = "deletedDate"
    
    var name: String
    var budgetAmount: Float
    var isVisible: Bool
    let createdDate: NSDate
    var deletedDate: NSDate? = nil
    var userID: String
    var identifier: String?
    var endpoint: String {
        return "category"
    }
    var jsonValue: [String: AnyObject] {
        
        var json: [String: AnyObject] = [kName: name, kBudgetAmount: budgetAmount, kIsVisible: isVisible, kCreatedDate: createdDate.timeIntervalSince1970, kUserID: userID]
        
        if let deletedDate = deletedDate {
            json.updateValue(deletedDate.timeIntervalSince1970, forKey: kDeletedDate)
        }
        
        return json
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let name = json[kName] as? String,
            let budgetAmount = json[kBudgetAmount] as? Float,
            let isVisible = json[kIsVisible] as? Bool,
            let createdDate = json[kCreatedDate] as? NSTimeInterval,
            let userID = json[kUserID] as? String else {
                
                self.name = ""
                self.budgetAmount = 0
                self.isVisible = true
                self.createdDate = NSDate()
                self.deletedDate = NSDate()
                self.userID = ""
                
                return nil
        }
        
        self.name = name
        self.budgetAmount = budgetAmount
        self.userID = userID
        self.isVisible = isVisible
        self.createdDate = NSDate(timeIntervalSince1970: createdDate)
        self.deletedDate = json[kDeletedDate] as? NSDate
        self.identifier = identifier
        
    }
    
    init(name: String, budgetAmount: Float, isVisible: Bool, createdDate: NSDate, deletedDate: NSDate?, userID: String) {
        self.name = name
        self.budgetAmount = budgetAmount
        self.isVisible = isVisible
        self.createdDate = createdDate
        self.deletedDate = deletedDate
        self.userID = userID
    }
}

func ==(lhs: Category, rhs: Category) -> Bool {
    
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}