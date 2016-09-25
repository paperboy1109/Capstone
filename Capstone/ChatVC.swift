//
//  ChatVC.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/24/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatVC: JSQMessagesViewController {
    
    // MARK: - Properties
    
    var chatMessages = [JSQMessage]()
    var chatMessagesRef: FIRDatabaseReference!
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    let themeColor = UIColor(red: 96.0/255.0, green: 237.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("ChatVC loaded ")
        
        /* Initialize messagesRef */
        chatMessagesRef = FirebaseClient.sharedInstance().databaseRootRef.child(FirebaseClient.Constants.FirebaseDatabaseParameterKeys.DatabaseRootRefChildPathString)
        
        /* Configure the chat bubbles */
        setupBubbles()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        navigationItem.rightBarButtonItem?.title = "Done"
        
    }
    
    // MARK: - Actions    
    
    @IBAction func leftNavigationBarButtonTapped(sender: AnyObject) {
        print("Tap successfully detected")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        FirebaseClient.sharedInstance().sendMessage(senderId, messageText: text, chatMessagesRef: chatMessagesRef)
    }
    
    
}

// MARK: - JSQMessagesCollectionView message data delegate methods

extension ChatVC {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        return FirebaseClient.sharedInstance().chatMessages[indexPath.item] //chatMessages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return FirebaseClient.sharedInstance().chatMessages.count //chatMessages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = FirebaseClient.sharedInstance().chatMessages[indexPath.item] //chatMessages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
        
        
    }
}


// MARK: - Message Bubble methods

extension ChatVC {
    
    func setupBubbles() {
        
        let factory = JSQMessagesBubbleImageFactory()
        
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(themeColor)
        
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = chatMessages[indexPath.item]
        
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
}