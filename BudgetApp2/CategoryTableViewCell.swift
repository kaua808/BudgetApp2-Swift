//
//  CategoryTableViewCell.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/16/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    var isObseving = false
    
    var delegate: CategoryTableViewCellDelegate?
    
    @IBOutlet var mainViewCell: UIView!
    @IBOutlet var categoryTitleLabel: UILabel!
    @IBOutlet var categoryDetailTableView: UITableView!
    @IBOutlet var addExpenseButton: UIButton!
    @IBOutlet var addExpenseLabel: UILabel!
    @IBOutlet var expenseSummeryLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var editButtonTapped: UIButton!
    
    var expenses: [Expense] = []
    
    class var expandedHeight: CGFloat { get { return 410} }
    class var defaultHeight: CGFloat { get { return 101} }
    
    func checkHeight() {
        categoryDetailTableView.hidden = (frame.size.height > CategoryTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObseving {
            addObserver(self, forKeyPath: "frame", options: .New, context: nil)
            isObseving = true
        }
    }

    func ignoreFrameChanges() {
        if isObseving {
            removeObserver(self, forKeyPath: "frame")
            isObseving = false
            (self.categoryDetailTableView.dataSource as? ExpandedTableViewDatasource)?.expenses = []
            categoryDetailTableView.reloadData()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    func updateProgressView(expensTotal: Float, category: Category) {
        
        //let moneySpent = category.budgetAmount - expensTotal
        
        let progress = Float(expensTotal) / Float(category.budgetAmount)
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.progressView.setProgress(progress, animated: false)
        })
        
        
    }
    
    func updateWithCategory(category: Category, shouldReload: Bool) {

        ExpenseController.fetchExpensesForCategories(category) { (expense) in
            
            if let expenses = expense {
                
                var totalExpense: Float = 0
                
                self.expenses = expenses
                
                for price in expenses {
                    totalExpense += price.price
                }
                
                self.updateProgressView(totalExpense, category: category)
                self.expenseSummeryLabel.text = "$\(totalExpense) / $\(category.budgetAmount)"
                
                if self.isObseving {
                    if shouldReload == true {
                        let datasource = self.categoryDetailTableView.dataSource as! ExpandedTableViewDatasource
                        datasource.updateDatasource(expenses, expandedTableView: self.categoryDetailTableView)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.categoryDetailTableView.reloadData()
                        })
                    }
                }
                
            } else {
                
                self.progressView.progress = 0
                self.expenseSummeryLabel.text = "$0 / $\(category.budgetAmount)"
            }
            
        }
        
        self.categoryTitleLabel.text = category.name
        self.progressView.transform = CGAffineTransformMakeScale(1, 13)
        self.progressView.layer.cornerRadius = 8
        self.progressView.progressTintColor = UIColor(red:0.51, green:0.55, blue:0.51, alpha:1.0)
        self.progressView.trackTintColor = UIColor(red:0.88, green:0.88, blue:0.88, alpha:1.0)
        self.mainViewCell.backgroundColor = UIColor(red:0.38, green:0.70, blue:0.16, alpha:1.0)
        self.backgroundColor = UIColor(red:0.95, green:0.97, blue:0.91, alpha:1.0)
        
        
    }
    
    @IBAction func editButtonTapped(sender: AnyObject) {
        
        delegate?.editButtonTapped(self)
        
    }
    
    
    @IBAction func addExpenseButtonTapped(sender: AnyObject) {
        
        delegate?.expenseButtonTapped(self)
        
    }
}

protocol CategoryTableViewCellDelegate {
    
    func expenseButtonTapped(cell: CategoryTableViewCell)
    
    func editButtonTapped(cell: CategoryTableViewCell)
    
}


