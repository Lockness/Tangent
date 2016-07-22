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
    @IBOutlet var loginButton: UIButton!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    let loadingView: UIView = UIView()
    let container: UIView = UIView()

    var firebase = FIRDatabase.database().reference()
    var userRef: FIRDatabaseReference {
        get {
            return self.firebase.child("Users")
        }
    }
    
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
    
    @IBAction func handleLogin(sender: AnyObject) {
        loginButton.enabled = false
        loginButton.alpha = 1.0
        showActivityIndicator(self.view)
        FIRAuth.auth()?.signInWithEmail(emailField.text!, password: passwordField.text!, completion: {
            user, error in
            if let error = error { //If error isn't nil, then login didn't work
                self.loginButton.enabled = true
                let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                self.actInd.stopAnimating()
                self.loadingView.removeFromSuperview()
                self.container.removeFromSuperview()
                return
            }
            
            self.firebase.child("Users").child(user!.uid).child("email").setValue("jtcruthers@gmail.com")
            //perform segue inside the closure so that it only runs if login was successful
            self.performSegueWithIdentifier("toConversationTableView", sender: self)
            self.actInd.stopAnimating()
            self.loadingView.removeFromSuperview()
            self.container.removeFromSuperview()
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

