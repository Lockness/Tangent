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
import Navajo_Swift

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var firstNameField: UITextField!
    @IBOutlet var lastNameField: UITextField!
    @IBOutlet var emailField: UITextField!
    @IBOutlet var confirmEmailField: UITextField!
    @IBOutlet var passwordField: UITextField!
    
    var validPassword: Bool = false
    var validEmail: Bool = false
    var confirmedEmail: Bool = false
    
    @IBAction func handleSignUp(sender: AnyObject) {
        validateFields()
        if (!validPassword || !validEmail || !confirmedEmail) {
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: {
            user, error in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegueWithIdentifier("toConversationTableView", sender: self)
            }
            
        })
    }
    
    func validateFields() {
        validPassword = confirmValidPassword(inField: passwordField)
        validEmail = confirmValidEmail(inField: emailField)
        confirmedEmail = confirmEmailAddress(Field: emailField, isSameAs: confirmEmailField)
    }
    
    func confirmValidEmail(inField textField: UITextField) -> Bool {
        guard let email = textField.text else { return false }
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluateWithObject(email) && email[email.startIndex] != "."
    }
    
    
    func confirmEmailAddress(Field textField: UITextField, isSameAs secondTextField: UITextField) -> Bool {
        guard let email = textField.text,
              let confirmEmail = secondTextField.text else { return false }
        
        if email != confirmEmail {
            return false
        }
        return true
        
    }
    
    func changeConfirmEmailColor(textField: UITextField) {
        if confirmEmailAddress(Field: textField, isSameAs: emailField) == true {
            confirmEmailField.textColor = UIColor.blackColor()
        } else {
            confirmEmailField.textColor = UIColor.redColor()
        }
    }
    
    func confirmValidPassword(inField textfield: UITextField) -> Bool {
        guard let password = passwordField.text else { return false }
        
        var lengthRule = NJOLengthRule(min: 6, max: 15)
        var uppercaseRule = NJORequiredCharacterRule(preset: .LowercaseCharacter)
        var numberRule = NJORequiredCharacterRule(preset: .DecimalDigitCharacter)
        var validator = NJOPasswordValidator(rules: [lengthRule, uppercaseRule, numberRule])
        
        var failingRules = validator.validatePassword(password)
        
        if failingRules != nil {
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.9 as CGFloat, alpha: 1 as CGFloat)
        self.confirmEmailField.addTarget(self, action: #selector(SignUpViewController.changeConfirmEmailColor(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

