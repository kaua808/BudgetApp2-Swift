//
//  ExpenseDetailTableViewCell.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/26/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class ExpenseDetailTableViewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateWithExpense(expense: Expense) {

        let myDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "MM/dd"
        
        self.dateLabel.text = myDateFormatter.stringFromDate(expense.date)
        self.priceLabel.text = "$\(expense.price)"
        self.commentLabel.text = expense.comment
    }
}
