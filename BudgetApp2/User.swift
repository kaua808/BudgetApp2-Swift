//
//  User.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/17/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import Foundation

class User: Equatable, FirebaseType {
    
    private let kName = "name"
    
    var name = ""
    var identifier: String?
    var endpoint: String {
        return "users"
    }
    var jsonValue: [String: AnyObject] {
        let json: [String: AnyObject] = [kName: name]
        
        return json
    }
    
    required init?(json: [String: AnyObject], identifier: String) {
        
        guard let name = json[kName] as? String else { return nil }
        
        self.name = name
        self.identifier = identifier
    }
    
    init(name: String, uid: String) {
        
        self.name = name
        self.identifier = uid
    }
}

func ==(lhs: User, rhs: User) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.name == rhs.name)
}

    
