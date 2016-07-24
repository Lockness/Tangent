//
//  MainViewController.swift
//  Tangent
//
//  Created by Justin Carruthers on 7/12/16.
//  Copyright © 2016 Lockness. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ConversationTableViewController: UITableViewController {
    
    var messageRef = FIRDatabase.database().reference().child("Branches/B1/Messages")
    var userRef = FIRAuth.auth()
    //var user: FIRUser?
    
    @IBAction func logout(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
        try! FIRAuth.auth()!.signOut()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Default", forIndexPath: indexPath)        
        cell.textLabel?.text = "conversation number \(indexPath.row)"

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = messageRef.observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            print(snapshot.key)
            // ...
        })
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showConversation" {
            if (tableView.indexPathForSelectedRow?.row) != nil {
                let conversation = Conversation()
                let conversationViewController = segue.destinationViewController as! ConversationViewController
                conversationViewController.conversation = conversation
            }
        }
    }
    
    
}
