//
//  ExpandedDetailTableViewCell.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/28/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class ExpandedDetailTableViewCell: UITableViewCell {

    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithExpense(expense: Expense) {
        
        let myDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "MM/dd"
        
        self.dateLabel.text = myDateFormatter.stringFromDate(expense.date)
        self.priceLabel.text = "$\(expense.price)"
        self.commentLabel.text = expense.comment
        
    }

}
