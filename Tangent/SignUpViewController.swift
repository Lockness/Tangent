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
        
        print(email)
        print(confirmEmail)
        if email != confirmEmail {
            confirmEmailField.textColor = UIColor.redColor()
        } else {
            confirmEmailField.textColor = UIColor.blackColor()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmEmailField.addTarget(self, action: #selector(SignUpViewController.confirmEmailAddress(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.emailField.addTarget(self, action: #selector(SignUpViewController.confirmEmailAddress(_:)),
            forControlEvents: UIControlEvents.EditingChanged)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

