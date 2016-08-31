//
//  LoginSignupViewController.swift
//  BudgetApp
//
//  Created by Kaleo Kim on 3/17/16.
//  Copyright © 2016 Kaleo Kim. All rights reserved.
//

import UIKit

class LoginSignupViewController: UIViewController {

    enum ViewMode {
        case Login
        case Signup
        case Edit
    }
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet var cangeViewModeLabel: UILabel!
    @IBOutlet var changeViewModeButton: UIButton!
    
    var viewMode = ViewMode.Login
    
    var fieldsAreValid: Bool {
        get {
            switch viewMode {
            case .Login:
                return !(emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty)
            case .Signup:
                return !(usernameTextField.text!.isEmpty || emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty)
            case .Edit:
                return !(usernameTextField.text!.isEmpty)
            }
        }
    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        let img = UIImage()
        self.navigationController?.navigationBar.shadowImage = img
        self.navigationController?.navigationBar.setBackgroundImage(img, forBarMetrics: .Default)
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.51, green:0.55, blue:0.51, alpha:1.0)
        
        self.view.backgroundColor = UIColor(red:0.51, green:0.55, blue:0.51, alpha:1.0)
        updateViewBasedOnMode()
        navigationController?.navigationBar.hidden = false
 
        changeViewModeButton.setTitleColor(UIColor(red:0.38, green:0.70, blue:0.16, alpha:1.0), forState: .Normal)
        
        self.usernameTextField.delegate = self
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
    }
    
    @IBAction func changeViewModeTapped(sender: AnyObject) {
        
        if viewMode == ViewMode.Login {
            viewMode = ViewMode.Signup

            updateViewBasedOnMode()
        } else {
            viewMode = ViewMode.Login
            
            updateViewBasedOnMode()
        }
    }
    
    func updateViewBasedOnMode() {
        
        switch viewMode {
        case .Login:
            usernameTextField.hidden = true
            actionButton.setTitle("Login", forState: .Normal)
            cangeViewModeLabel.text = "Dont have an account?"
            changeViewModeButton.setTitle("Signup here", forState: .Normal)
        case .Signup:
            usernameTextField.hidden = false
            actionButton.setTitle("Signup", forState: .Normal)
            cangeViewModeLabel.text = "Already have an account?"
            changeViewModeButton.setTitle("Login here", forState: .Normal)
        case .Edit:
            actionButton.setTitle("Update", forState: .Normal)
            emailTextField.hidden = true
            passwordTextField.hidden = true
            
            if let user = self.user {
                
                usernameTextField.text = user.name
            }
        }
    }
    
    func updateWithUser(user: User) {
        
        self.user = user
        viewMode = .Edit
    }
    
    @IBAction func actionButtonTapped() {
        
        if fieldsAreValid {
            switch viewMode {
            case .Login:
                UserController.authenticateUser(emailTextField.text!, password: passwordTextField.text!, completion: { (success, user) -> Void in
                    if success, let _ = user {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Log In", message: "Please check your information and try again.")
                    }
                })
            case .Signup:
                UserController.createUser(emailTextField.text!, name: usernameTextField.text!, password: passwordTextField.text!, completion: { (success, user) -> Void in
                    if success, let _ = user {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Signup", message: "Please check your information and try again.")
                    }
                })
            case .Edit:
                UserController.updateUser(self.user!, name: self.usernameTextField.text!, completion: { (success, user) -> Void in
                    
                    if success {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        self.presentValidationAlertWithTitle("Unable to Update User", message: "Please check your information and try again.")
                    }
                })
            }
        } else {
            presentValidationAlertWithTitle("Missing Information", message: "Please check your information and try again.")
        }
    }
    
    func presentValidationAlertWithTitle(title: String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        presentViewController(alert, animated: true, completion: nil)
    }
}

extension LoginSignupViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}