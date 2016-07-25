//
//  MainViewController.swift
//  Tangent
//
//  Created by Justin Carruthers and Ryan Tomlinson.
//  Copyright © 2016 Lockness. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ConversationTableViewController: UITableViewController {
    
    var conversationRef = FIRDatabase.database().reference()
    var userRef = FIRAuth.auth()
    var messageCount = 0
    //var user: FIRUser?
    
    var conversationList = [String]()
    
    @IBAction func logout(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
        try! FIRAuth.auth()!.signOut()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Default", forIndexPath: indexPath)        
        cell.textLabel?.text = conversationList[indexPath.row]

        return cell
    }
    
    @IBAction func addNewConversation(sender: AnyObject) {
        //conversationList.append("convo " + String(conversationList.count))
        
//        // Update Table Data
//        tableView.beginUpdates()
//        tableView.insertRowsAtIndexPaths(
//            [NSIndexPath(forRow: conversationList.count-1, inSection: 0)
//            ], withRowAnimation: .Right)
//        tableView.endUpdates()
        
        // Update Database
        self.conversationRef.child("Conversations").childByAutoId().setValue("new convo")
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            if let conversationUuid = tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text {
                print(conversationUuid)
                conversationRef.child("Conversations/" + conversationUuid).removeValue()
            }
            tableView.beginUpdates()
            conversationList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func viewDidLoad() {
        _ = conversationRef.child("Conversations").observeEventType(FIRDataEventType.ChildAdded, withBlock: { (snapshot) in
            print(snapshot.key)
            self.conversationList.append(snapshot.key)
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(
                [NSIndexPath(forRow: self.conversationList.count-1, inSection: 0)
                ], withRowAnimation: .Right)
            self.tableView.endUpdates()
        })

        // Technically don't need this because you should never delete a convo from the database
        // For example: If user A deletes a chat with user B, user B should still be able to see that chat
        // AKA don't use this method
        
//        _ = conversationRef.child("Conversations").observeEventType(FIRDataEventType.ChildRemoved, withBlock: { (snapshot) in
//            print(snapshot.key)
//            self.conversationList.removeAtIndex(self.conversationList.indexOf(String(snapshot.key))!)
//            print(self.conversationList)
//            self.tableView.beginUpdates()
//            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            self.tableView.endUpdates()
//        })
        
        super.viewDidLoad()
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
