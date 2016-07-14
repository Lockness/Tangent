//
//  LoginViewController.swift
//  Tangent
//
//  Created by Justin Carruthers on 7/12/16.
//  Copyright © 2016 Lockness. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UIAlertViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func handleLogin(sender: AnyObject) {
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {
            user, error in
            
            if let error = error { //If error isn't nil, then login didn't work
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            //perform segue inside the closure so that it only runs if login was successful
            self.performSegueWithIdentifier("toConversationTableView", sender: self)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.9 as CGFloat, alpha: 1 as CGFloat)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let id = textField.restorationIdentifier {
            if id == "emailField" {
                passwordField.becomeFirstResponder()
            } else if id == "passwordField" {
                passwordField.resignFirstResponder()
            }
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func backgroundWasTapped(sender: AnyObject) {
        view.endEditing(true)
    }

}

