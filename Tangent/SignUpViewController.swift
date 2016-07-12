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

class SignUpViewController: UIViewController {
    
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
                self.performSegueWithIdentifier("toMainViewController", sender: self)
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

