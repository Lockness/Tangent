//
//  ConversationViewController.swift
//  Tangent
//
//  Created by Justin Carruthers on 7/13/16.
//  Copyright © 2016 Lockness. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var conversation: Conversation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenEdgeRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(didSwipeFromTop))
        screenEdgeRecognizer.edges = .Right
        view.addGestureRecognizer(screenEdgeRecognizer)
    }
    
    func didSwipeFromTop(recognizer: UIScreenEdgePanGestureRecognizer) {
        print("touched")
        if recognizer.state == .Recognized {
            self.performSegueWithIdentifier("showBranches", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBranches" {
            
        }
    }
    
}
