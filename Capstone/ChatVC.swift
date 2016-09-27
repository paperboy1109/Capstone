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
    
    var idToken: String?
    
    var chatMessagesRef: FIRDatabaseReference!
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    let themeColor = UIColor(red: 96.0/255.0, green: 237.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        /* Initialize messagesRef */
        chatMessagesRef = FirebaseClient.sharedInstance().databaseRootRef.child(FirebaseClient.Constants.FirebaseDatabaseParameterKeys.DatabaseRootRefChildPathString)
        
        /* Configure the chat bubbles */
        setupBubbles()
        
        /* Check Firebase for messages old and new */
        observeForNewMessages()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.rightBarButtonItem?.title = "Done"
        inputToolbar.contentView.leftBarButtonItem = nil
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        checkNetworkConnection()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* Greet and guide the user */
        FirebaseClient.sharedInstance().createNewMessage("Daniel", messageText: "What utility should I include in this app next?", date: FirebaseClient.sharedInstance().returnCurrentDateAsString())
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        /* Don't show duplicate messages */
        FirebaseClient.sharedInstance().chatMessages.removeAll()
        
    }
    
    // MARK: - Helpers
    
    func observeForNewMessages() {
        
        FirebaseClient.sharedInstance().setMessageObserver(chatMessagesRef, maxMessagesToReturn: 50) { data in                        
            
            guard data != nil else {
                performUIUpdatesOnMain(){
                    self.showConnectionFailAlert()
                }
                return
            }
            
            self.finishReceivingMessage()
            
            performUIUpdatesOnMain(){
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            
        }
        
    }
    
    func checkNetworkConnection() {
        
        let currentUser = FIRAuth.auth()?.currentUser
        
        /* Try to obtain an authentication token; if an error is returned this implies the network is not accessible */
        currentUser?.getTokenForcingRefresh(true) { idToken, error in
            
            if let error = error {
                print(error)
                
                performUIUpdatesOnMain() {
                    self.showConnectionFailAlert()
                }
                
                return
            }
            
            self.idToken = idToken
            
        }
    }
    
    func showConnectionFailAlert() {
        
        let alertView = UIAlertController(title: "Error", message: "A network connection is unavailable at this time, or your device may be offline.  No worries, you can check back later -- and the other features of the app are all still available in the meantime. ", preferredStyle: UIAlertControllerStyle.Alert)
        
        let alertAction = UIAlertAction(title: "OK", style: .Default) { void in
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        alertView.addAction(alertAction)
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func leftNavigationBarButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        FirebaseClient.sharedInstance().sendMessage(senderId, messageText: text, chatMessagesRef: chatMessagesRef)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()  // clears out the text field after send is tapped
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
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
        
        let message = FirebaseClient.sharedInstance().chatMessages[indexPath.item] //chatMessages[indexPath.item]
        
        if message.senderId == senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    /* Display the date */
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = FirebaseClient.sharedInstance().chatMessages[indexPath.item]
        
        return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return 21.0
    }
    
    /* Hide the keyboard */
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapCellAtIndexPath indexPath: NSIndexPath!, touchLocation: CGPoint) {
        self.view.endEditing(true)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        self.view.endEditing(true)
    }
}

// MARK: - Improve Keyboard behavior

extension ChatVC {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
}