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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
