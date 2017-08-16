//
//  ChatViewController.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/20/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var inputContainerView: UIView!
    var dividerLine: UIView!
    var messageTextField: UITextField!
    var sendButton: UIButton!
    var backBarButtonItem: UIBarButtonItem!
    
    var user1Id: String!
    var user2Id: String!
    var friendProfileImage: UIImage!
    var currentUserId: String = (Auth.auth().currentUser?.uid)!
    var friendId: String!
    
    var messagesArray: [Message] = [Message]()
    var messagesCell: MessagesCell!
    
//    var messagesCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide return button from navigation bar
        self.navigationItem.hidesBackButton = true
        backBarButtonItem = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(returnToMessagesViewController))
        self.navigationItem.leftBarButtonItem = backBarButtonItem
        
        collectionView?.backgroundColor = .white
        collectionView?.register(CurrentUserChatCell.self, forCellWithReuseIdentifier: "currentUserChatCellId")
        collectionView?.register(FriendChatCell.self, forCellWithReuseIdentifier: "friendChatCellId")
        collectionView?.alwaysBounceVertical = true
        setupViews()
        
        // check if current user is sender or receiver
        if (currentUserId == user1Id) {
            friendId = user2Id
        } else {
            friendId = user1Id
        }
        
        // set friend's name as title of navigation bar
        Database.database().reference().child("users").child(friendId).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:Any] {
                let friendName = dictionary["name"]
                self.title = friendName as! String
            }
        }, withCancel: nil)
    
        observeMessagesForChat()

        // Do any additional setup after loading the view.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messagesArray[indexPath.item]
        if message.receiverId == currentUserId {
            // friend sent the message
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "friendChatCellId", for: indexPath) as! FriendChatCell
            cell.friendImageView.image = friendProfileImage
            cell.messageBubbleView.text = message.text
            return cell
        } else {
            // friend receives the message
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "currentUserChatCellId", for: indexPath) as! CurrentUserChatCell
            cell.messageBubbleView.text = message.text
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // calculate height for message's text at indexPath.item
        let text = messagesArray[indexPath.item].text as! String
        
        // calculate estimated frame for the text
        // note: CGSize height just needs to be a big number and the width is width of the bubble message view
        let frameForMessage = NSString(string: text).boundingRect(with: CGSize(width: view.frame.width*0.5, height: 2000) , options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        let height = frameForMessage.height + 20
        return CGSize(width: view.frame.width, height: height)
    }

    func setupViews() {
        
        inputContainerView = UIView(frame: CGRect(x: 0, y: view.frame.height-45, width: view.frame.width, height: 45))
        view.addSubview(inputContainerView)
        view.bringSubview(toFront: inputContainerView)
        
        dividerLine = UIView(frame: CGRect(x: 12, y: 0, width: view.frame.width-24, height: 2))
        dividerLine.backgroundColor = .lightGray
        inputContainerView.addSubview(dividerLine)
        
        messageTextField = UITextField(frame: CGRect(x: 12, y: 0, width: view.frame.width*0.80, height: 25))
        messageTextField.center = CGPoint(x: messageTextField.center.x, y: inputContainerView.frame.height/2)
        messageTextField.placeholder = "Enter message..."
        // create inset for textfield to shift where text starts. x is shifted by 12px
        messageTextField.layer.sublayerTransform = CATransform3DMakeTranslation(12, 0, 0)
        messageTextField.layer.cornerRadius = 10
        messageTextField.layer.borderWidth = 0.5
        messageTextField.layer.borderColor = UIColor.lightGray.cgColor
        messageTextField.font = UIFont.systemFont(ofSize: 15)
        inputContainerView.addSubview(messageTextField)
        
        sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width*0.1, height: 25))
        sendButton.center = CGPoint(x: (view.frame.width - messageTextField.frame.origin.x-messageTextField.frame.width)/2 + messageTextField.frame.origin.x + messageTextField.frame.width, y: inputContainerView.frame.height/2)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.blue, for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        inputContainerView.addSubview(sendButton)
        
    }
    
    func sendMessage() {
        
        // take the message from input text field and save to database
        let messagesRef = Database.database().reference().child("messages")
        let childIDRef = messagesRef.childByAutoId()
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedDate = dateFormatter.string(from: date as Date)
        let timeSince1970: Int = Int(NSDate().timeIntervalSince1970)
        let values = ["text": messageTextField.text, "senderId": currentUserId, "receiverId": friendId, "date": formattedDate, "timeSince1970": timeSince1970] as [String : Any]
        childIDRef.updateChildValues(values)
        messageTextField.text = nil
        
        
        
        let currentUserIDRef = Database.database().reference().child("user-messages").child(currentUserId)
        currentUserIDRef.updateChildValues([childIDRef.key: 0]) // the 0 is not important, just need it as a value for key
        
        let friendIDRef = Database.database().reference().child("user-messages").child(friendId)
        friendIDRef.updateChildValues([childIDRef.key: 0]) // the 0 is not important, just need it as a value for key
        
    }
    
    
    
    func observeMessagesForChat() {
        
        // update messagesArray anytime a message is sent between friend and logged in user
        
        Database.database().reference().child("user-messages").child(currentUserId).observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            Database.database().reference().child("messages").child(messageId).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String:Any] {
                    // check if this message is between the current user and friendId
                    let messageReceiverId = dictionary["receiverId"] as! String
                    let messageSenderId = dictionary["senderId"] as! String
                    if (messageReceiverId == self.friendId || messageSenderId == self.friendId) {
                        let message = Message()
                        message.receiverId = messageReceiverId
                        message.senderId = messageSenderId
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        message.date = dateFormatter.date(from: dictionary["date"] as! String) as! NSDate
                        message.text = dictionary["text"] as! String
                        message.timeSince1970 = dictionary["timeSince1970"] as! Int
                        self.messagesArray.append(message)

                        // sort messages
                        self.messagesArray.sort(by: { (message1, message2) -> Bool in
                            return message1.timeSince1970! < message2.timeSince1970!
                        })
                        
                        // reload collection view
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                    
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    
    func returnToMessagesViewController() {
//        if let collectionView = messagesCollectionView {
//            collectionView.reloadData()
//        }
        
        let lastMessage = messagesArray[messagesArray.count - 1]
        messagesCell.messageText = lastMessage.text
        messagesCell.date = lastMessage.date
        self.navigationController?.popViewController(animated: true)
    }
    

    
    
}
