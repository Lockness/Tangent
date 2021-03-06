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
    @IBOutlet var signUpButton: UIButton!
    
    var validPassword: Bool = false
    var validEmail: Bool = false
    var confirmedEmail: Bool = false
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    let container: UIView = UIView()
    
    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor(white: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(white: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.Gray
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
                                    loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.hidesWhenStopped = true
        actInd.startAnimating()
    }
    
    @IBAction func handleSignUp(sender: AnyObject) {
        showActivityIndicator(self.view)
        self.signUpButton.enabled = false
        self.signUpButton.alpha = 1.0
        validateFields()
        
        if (!validPassword || !validEmail || !confirmedEmail) {
            self.actInd.stopAnimating()
            self.loadingView.removeFromSuperview()
            self.container.removeFromSuperview()
            self.signUpButton.enabled = true
            return
        }
        
        FIRAuth.auth()?.createUserWithEmail(emailField.text!, password: passwordField.text!, completion: {
            user, error in
            
            if let error = error {
                print(error.localizedDescription)
                self.signUpButton.enabled = true
            } else {
                self.performSegueWithIdentifier("toConversationTableView", sender: self)
            }
            self.actInd.stopAnimating()
            self.loadingView.removeFromSuperview()
            self.container.removeFromSuperview()
            
        })
    }
    
    @IBAction func backgroundWasTapped(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.9 as CGFloat, alpha: 1 as CGFloat)
        self.confirmEmailField.addTarget(self, action: #selector(SignUpViewController.changeConfirmEmailColor(_:)), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        let lengthRule = NJOLengthRule(min: 6, max: 15)
        let uppercaseRule = NJORequiredCharacterRule(preset: .LowercaseCharacter)
        let numberRule = NJORequiredCharacterRule(preset: .DecimalDigitCharacter)
        let validator = NJOPasswordValidator(rules: [lengthRule, uppercaseRule, numberRule])
        
        let failingRules = validator.validatePassword(password)
        
        if failingRules != nil {
            return false
        }
        
        return true
    }
    
}

