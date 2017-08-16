//
//  MessagesViewController.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/14/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var userId: String!
    var userName: String! {
        didSet {
            self.title = userName
        }
    }
    var messages: Messages = Messages(messageArray: [Message]())
    var friendIds: FriendIds = FriendIds(friendIdsArray: [String]())
    
    
    var signOutBarButtonItem: UIBarButtonItem!
    var newMessageBarButtonItem: UIBarButtonItem!
    
    var userMessageChildrenCount: Int! {
        didSet {
            updateMessagesArray(childrenCount: userMessageChildrenCount)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView?.backgroundColor = .white
        collectionView?.register(MessagesCell.self, forCellWithReuseIdentifier: "messagesCellId")
        collectionView?.alwaysBounceVertical = true
        
        // get logged in user's name from Firebase Database
        Database.database().reference().child("users").child(self.userId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let userInfoDictionary = snapshot.value as? [String:Any] {
                let name = userInfoDictionary["name"] as! String
                self.userName = name
                
            }
        }, withCancel: nil)
        
        // get the count for number of messages under user-messages associated with userId THEN trigger didSet block
        Database.database().reference().child("user-messages").child(self.userId).observeSingleEvent(of: .value, with: { (snapshot) in
            self.userMessageChildrenCount = Int(snapshot.childrenCount)
        }, withCancel: nil)
        
        setupBarButtons()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "messagesCellId", for: indexPath) as! MessagesCell
        if let messageArray = messages.messageArray {
            let message = messageArray[indexPath.item]
            // check if friend is receiver or sender
            
            var friendId: String = ""
            if message.receiverId == userId {
                friendId = message.senderId!
            } else {
                friendId = message.receiverId!
            }
            
            // retreieve info(name, email, profileImageURL) of friend
            Database.database().reference().child("users").child(friendId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let receiverInfoDictionary = snapshot.value as? [String:Any] {
                    cell.name = receiverInfoDictionary["name"] as! String
                    
                    let profileImageURLString = receiverInfoDictionary["profileImageURL"] as! String
                    let profileImageURL = URL(string: profileImageURLString)
                    URLSession.shared.dataTask(with: profileImageURL!, completionHandler: { (data, response, error) in
                        if (error != nil) {
                            print(error)
                            return
                        }
                        
                        DispatchQueue.main.async {
                            let receiverProfileImage = UIImage(data: data!)
                            cell.profileImageView.image = receiverProfileImage
                            cell.smallProfileImageView.image = receiverProfileImage
                        }
                    }).resume()
                    
                    
                }
            }, withCancel: nil)
            cell.messageText = message.text
            cell.date = message.date
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = messages.messageArray {
            return array.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MessagesCell
        let friendProfileImage = cell.profileImageView.image
        
        let layout = UICollectionViewFlowLayout()
        let chatViewController = ChatViewController(collectionViewLayout: layout)
        chatViewController.user1Id = messages.messageArray?[indexPath.item].senderId
        chatViewController.user2Id = messages.messageArray?[indexPath.item].receiverId
//        chatViewController.messagesCollectionView = collectionView
        chatViewController.friendProfileImage = friendProfileImage
        chatViewController.messagesCell = cell
        navigationController?.pushViewController(chatViewController, animated: true)
    }
    
    
    func logOut() {
        if (Auth.auth().currentUser != nil) {
            do {
                try(Auth.auth().signOut())
                self.navigationController?.popViewController(animated: true)
            } catch let err {
                print(err)
                return
            }
        }
    }
    
    func newMessageSelected() {
        let friendsController = FriendsTableViewController()
        friendsController.messages = messages
        friendsController.friendIds = friendIds
        friendsController.messagesCollectionView = collectionView
        navigationController?.pushViewController(friendsController, animated: true)
    }
    
    func updateMessagesArray(childrenCount: Int) {
        
        var counter = childrenCount
        
        // look at messages related to logged in user
        Database.database().reference().child("user-messages").child(userId).observe(.childAdded, with: { (snapshot) in
            
            // messageID is ID for one of the related messages
            let messageID = snapshot.key
            
            // retrieve info(text, date, timeSince1970, senderId, and receiverId) of messageID
            Database.database().reference().child("messages").child(messageID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let messageInfoDictionary = snapshot.value as? [String:Any] {
                    let text = messageInfoDictionary["text"] as! String
                    let timeSince1970 = messageInfoDictionary["timeSince1970"] as! Int
                    let formatter = DateFormatter()
                    formatter.dateFormat = "h:mm a"
                    let date = formatter.date(from: messageInfoDictionary["date"] as! String) as! NSDate
                    let receiverId = messageInfoDictionary["receiverId"]  as! String
                    let senderId = messageInfoDictionary["senderId"] as! String
                    
                    // check if friend is sender or receiver
                    var friendId: String
                    let currentUserId = Auth.auth().currentUser?.uid
                    if (currentUserId == receiverId) {
                        friendId = senderId
                    } else {
                        friendId = receiverId
                    }
                    
                    
                    if (self.friendIds.friendIdsArray?.contains(friendId) == false) {
                        // the friend of the messageID has never sent a message to logged in user before
                        self.friendIds.friendIdsArray!.append(friendId)
                        let message = Message()
                        message.receiverId = receiverId
                        message.senderId = messageInfoDictionary["senderId"] as! String
                        message.timeSince1970 = timeSince1970
                        message.text = text
                        message.date = date
                        self.messages.messageArray?.append(message)
                        // sort messages array depending on latest message
                        self.messages.messageArray?.sort(by: { (message1, message2) -> Bool in
                            return message1.timeSince1970! > message2.timeSince1970!
                        })
                    } else {
                        // there is already a message between logged in user and friendId
                        // BUT, we need to check if this message was sent earlier or later
                        
                        //find index of latest message corresponding to friend
                        var index: Int = 0
                        for (message) in self.messages.messageArray! {
                            if (message.receiverId == friendId || message.senderId == friendId) {
                                break
                            } else {
                                index = index + 1
                            }
                        }
                        let latestMessage = self.messages.messageArray?[index]
                        let latestMessageTimeSince1970 = latestMessage?.timeSince1970
                        let currentMessageTimeSince1970 = messageInfoDictionary["timeSince1970"] as! Int
                        if (currentMessageTimeSince1970 > latestMessageTimeSince1970!) {
                            latestMessage?.text = text
                            latestMessage?.date = date
                            latestMessage?.timeSince1970 = timeSince1970
                        }
                    }
                }
                DispatchQueue.main.async {
                    counter = counter - 1
                    if counter == 0 {
                        self.collectionView?.reloadData()
                    }

                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func setupBarButtons() {
        signOutBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))
        self.navigationItem.leftBarButtonItem = signOutBarButtonItem
        
        
        let button = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "new_message"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(newMessageSelected), for: .touchUpInside)
        newMessageBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = newMessageBarButtonItem
    }

    
    
}
