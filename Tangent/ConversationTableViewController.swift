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

class MessageTableViewController: UITableViewController {
    
   // var messageRef = FIRDatabase.database().reference()
    //var user: FIRUser?
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Default", forIndexPath: indexPath)
        
        cell.textLabel?.text = "conversation number \(indexPath.row)"

        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showConversation" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let conversation = Conversation()
                let conversationViewController = segue.destinationViewController as! ConversationViewController
                conversationViewController.conversation = conversation
            }
        }
    }
    
    
}
