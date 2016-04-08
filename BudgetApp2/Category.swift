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
    
    var name: String
    var budgetAmount: Float
    var isVisible: Bool
    var userID: String
    var identifier: String?
    var endpoint: String {
        return "category"
    }
    var jsonValue: [String: AnyObject] {
        let json: [String: AnyObject] = [kName: name, kBudgetAmount: budgetAmount, kIsVisible: isVisible, kUserID: userID]
        
        return json
    }
    
    required init?(json: [String : AnyObject], identifier: String) {
        guard let name = json[kName] as? String,
            let budgetAmount = json[kBudgetAmount] as? Float,
            let isVisible = json[kIsVisible] as? Bool,
            let userID = json[kUserID] as? String else {
                
                self.name = ""
                self.budgetAmount = 0
                self.isVisible = true
                self.userID = ""
                
                return nil
        }
        
        self.name = name
        self.budgetAmount = budgetAmount
        self.userID = userID
        self.isVisible = isVisible
        self.identifier = identifier
        
    }
    
    init(name: String, budgetAmount: Float, isVisible: Bool, userID: String) {
        self.name = name
        self.budgetAmount = budgetAmount
        self.isVisible = isVisible
        self.userID = userID
    }
}

func ==(lhs: Category, rhs: Category) -> Bool {
    
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}