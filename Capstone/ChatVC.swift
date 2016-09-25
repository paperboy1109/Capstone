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
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("ChatVC loaded ")
        
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
    
    
}

// MARK: - JSQMessagesCollectionView message data delegate methods

extension ChatVC {
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        
        return chatMessages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return chatMessages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = chatMessages[indexPath.item]
        
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
        
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        
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