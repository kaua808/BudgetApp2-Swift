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
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        let dateStringToNSDate: NSDate? = dateFormatter.dateFromString(expense.date)
        
        let myDateFormatter = NSDateFormatter()
        myDateFormatter.dateFormat = "MM/dd"
        
        self.dateLabel.text = myDateFormatter.stringFromDate(dateStringToNSDate!)
        self.priceLabel.text = "$\(expense.price)"
        self.commentLabel.text = expense.comment
        
    }

}
