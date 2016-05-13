//
//  HistoryCategoryTableViewCell.swift
//  BudgetApp2
//
//  Created by Kaleo Kim on 4/23/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class HistoryCategoryTableViewCell: UITableViewCell {

    @IBOutlet var categoryNameLabel: UILabel!
    @IBOutlet var budgetLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithCategoryAndExpenses(category: Category, expenses: [Expense]) {
        
        categoryNameLabel.text = category.name
        
        // add up value of expenses
        var totalExpense = 0
        
        for expense in expenses {
            totalExpense += Int(expense.price)
        }
        
        budgetLabel.text = "$\(totalExpense) / $\(category.budgetAmount)"
        
    }

}
