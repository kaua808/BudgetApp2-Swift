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
        
        // set label to \(value of expenses) / (category.budgetAmount)
    }

}
