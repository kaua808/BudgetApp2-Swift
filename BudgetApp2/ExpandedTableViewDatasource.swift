//
//  ExpandedTableViewDatasource.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/28/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class ExpandedTableViewDatasource: NSObject, UITableViewDataSource {
    
    var expandedDetailTableView: UITableView!
    var expenses: [Expense]?
    
    func updateDatasource(expenses: [Expense], expandedTableView: UITableView) {
        self.expenses = expenses
        print(self.expenses?.count ?? "NO EXPENSES")
        self.expandedDetailTableView = expandedTableView
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = expandedDetailTableView.dequeueReusableCellWithIdentifier("expandedDetailCell", forIndexPath: indexPath) as! ExpandedDetailTableViewCell
        
        if let expense = expenses where expenses!.count > 0 {
            cell.updateWithExpense(expense[indexPath.row])
        }
        
        cell.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
        return cell
    }
    
}
