//
//  FirebaseClient.swift
//  Capstone
//
//  Created by Daniel J Janiak on 9/25/16.
//  Copyright © 2016 Daniel J Janiak. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class FirebaseClient: NSObject {
    
    // MARK: - Properties
    
    var chatMessages = [JSQMessage]()
    
    let databaseRootRef = FIRDatabase.database().reference()
    
    
    // MARK: - Methods for chat
    
    func createNewMessage(senderId: String, messageText: String) {
        
        let newMessage = JSQMessage(senderId: senderId, senderDisplayName: "", date: returnCurrentDateAsNSDate(), text: messageText)        
        
        chatMessages.append(newMessage)
    }
    
    func sendMessage(senderId: String, messageText: String, chatMessagesRef: FIRDatabaseReference) {
        
        let chatItemRef = chatMessagesRef.childByAutoId()
        
        let chatMessageItem = [
            
            FirebaseClient.Constants.FirebaseDatabaseParameterKeys.SenderId: senderId,
            FirebaseClient.Constants.FirebaseDatabaseParameterKeys.MessageText: messageText
        
        ]
        
        chatItemRef.setValue(chatMessageItem)                        
        
    }
    
    func setMessageObserver(chatMessagesRef: FIRDatabaseReference, maxMessagesToReturn: UInt, completionHandlerForSetMessageObserver: (data: FIRDataSnapshot) -> Void ) {
        
        let chatMessageQuery = chatMessagesRef.queryLimitedToLast(maxMessagesToReturn)
        
        chatMessageQuery.observeEventType(.ChildAdded, withBlock: { snapshot in
            
            guard snapshot.value != nil else {
                return
            }
            
            let id = snapshot.value![FirebaseClient.Constants.FirebaseDatabaseParameterKeys.SenderId] as! String
            let text = snapshot.value![FirebaseClient.Constants.FirebaseDatabaseParameterKeys.MessageText] as! String 
            
            self.createNewMessage(id, messageText: text)
            
            completionHandlerForSetMessageObserver(data: snapshot)
            
        })
        
    }
    
    func returnCurrentDateAsNSDate() -> NSDate {
        
        return NSDate()
        
    }
    
    func returnCurrentDateAsString() -> String {
        
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"                
        
        return dateFormatter.stringFromDate(currentDate)
    }
    
    
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> FirebaseClient {
        struct Singleton {
            static var sharedInstance = FirebaseClient()
        }
        return Singleton.sharedInstance
    }
    
    

}
