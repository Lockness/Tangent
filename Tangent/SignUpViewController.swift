//
//  SignUpViewController.swift
//  Tangent
//
//  Created by Justin Carruthers on 7/12/16.
//  Copyright © 2016 Lockness. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var confirmEmailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func handleSignUp(sender: AnyObject) {
        
        
        
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: {
            user, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegueWithIdentifier("toMessageTableView", sender: self)
            }
            
        })
    }
    
    func confirmEmailAddress(textField: UITextField) {
        guard let email = emailField.text,
            let confirmEmail = confirmEmailField.text else { return }
        
        if email != confirmEmail {
            confirmEmailField.textColor = UIColor.redColor()
        } else {
            confirmEmailField.textColor = UIColor.blackColor()
        }
        
    }
    
    func confirmValidEmail(textField: UITextField) -> Bool {
        guard let email = textField.text else { return true }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print(emailTest.evaluateWithObject(email) && email[email.startIndex] != ".")
        return emailTest.evaluateWithObject(email) && email[email.startIndex] != "."
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmEmailField.addTarget(self, action: #selector(SignUpViewController.confirmEmailAddress(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.emailField.addTarget(self, action: #selector(SignUpViewController.confirmEmailAddress(_:)),
            forControlEvents: UIControlEvents.EditingDidEnd)
        self.emailField.addTarget(self, action: #selector(SignUpViewController.confirmValidEmail(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

