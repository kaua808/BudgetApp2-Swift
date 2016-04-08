//
//  LoginSignupChoiceViewController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/17/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class LoginSignupChoiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.backgroundColor = UIColor(red:0.38, green:0.70, blue:0.16, alpha:1.0)
        self.view.backgroundColor = UIColor(red:0.51, green:0.55, blue:0.51, alpha:1.0)
        
    }

    override func viewWillAppear(animated: Bool) {
        
        navigationController?.navigationBar.hidden = true
        
    }
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "toSignup" {
            let destinationViewController = segue.destinationViewController as? LoginSignupViewController
            destinationViewController?.viewMode = LoginSignupViewController.ViewMode.Signup
        } else if segue.identifier == "toLogin" {
            let destinationViewController = segue.destinationViewController as? LoginSignupViewController
            destinationViewController?.viewMode = LoginSignupViewController.ViewMode.Login
        }
        
    }
    

}
