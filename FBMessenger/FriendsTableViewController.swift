//
//  FriendsTableViewController.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/19/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit
import Firebase

class FriendsTableViewController: UITableViewController {

    var usersToDisplayArray: [User] = [User]()
    var profileImageURLArray: [String] = [String]()
    var messages: Messages!
    var friendIds: FriendIds!
    var messagesCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()


//         Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // retrieve info about users(name, email, profileImageURL)
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            // .childAdded loops this block for each child there is under "users"
            let childId = snapshot.key
            if (self.friendIds.friendIdsArray?.contains(childId) == false && childId != Auth.auth().currentUser?.uid) {
                if let dictionary = snapshot.value as? [String:Any] {
                    let user = User(name: dictionary["name"] as! String, email: dictionary["email"] as! String, usrId: childId)
                    self.usersToDisplayArray.append(user)
                    let profileImageURL = dictionary["profileImageURL"] as! String
                    self.profileImageURLArray.append(profileImageURL)
                    
                    // reload data to update the count
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
            
        tableView.register(FriendCell.self, forCellReuseIdentifier: "friendCellId")
        
        
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersToDisplayArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCellId", for: indexPath) as! FriendCell
        let user = usersToDisplayArray[indexPath.row]
        cell.nameLabel.text = user.name
        cell.emailLabel.text = user.email
        let cellProfileImageURLString = profileImageURLArray[indexPath.row]
        let url = URL(string: cellProfileImageURLString)
        
        // retrieve image from profileImageURL
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if (error != nil) {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                let profileImage = UIImage(data: data!)
                user.profileImage = profileImage
                cell.profileImageView.image = profileImage
            }
            
        }.resume()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // send message "Hello there!" to selected user
        
        
        // update messages, friendIds, and usersToDisplayArray
        let user = usersToDisplayArray[indexPath.row]
        friendIds.friendIdsArray?.insert(user.userId!, at: 0)
        let message = Message()
        message.senderId = Auth.auth().currentUser?.uid
        message.receiverId = user.userId
        message.date = NSDate()
        message.timeSince1970 = Int(NSDate().timeIntervalSince1970)
        message.text = "Hello there!"
        messages.messageArray?.insert(message, at: 0)
        usersToDisplayArray.remove(at: indexPath.row)
        
        
        // add message "Hello there!" to database
        let messagesRef = Database.database().reference().child("messages")
        let childIDRef = messagesRef.childByAutoId()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        let formattedDate = dateFormatter.string(from: message.date as! Date)
        let values = ["text": message.text, "senderId": message.senderId, "receiverId": message.receiverId, "date": formattedDate, "timeSince1970": message.timeSince1970] as [String : Any]
        childIDRef.updateChildValues(values)
        
        
        let currentUserIDRef = Database.database().reference().child("user-messages").child((Auth.auth().currentUser?.uid)!)
        currentUserIDRef.updateChildValues([childIDRef.key: 0]) // the 0 is not important, just need it as a value for key

        let userSelectedIDRef = Database.database().reference().child("user-messages").child(user.userId!)
        userSelectedIDRef.updateChildValues([childIDRef.key: 0]) // the 0 is not important, just need it as a value for key
        
        // navigate to other View Controllers
        let indexPath = IndexPath(item: 0, section: 0)
        messagesCollectionView.insertItems(at: [indexPath])
        navigationController?.popViewController(animated: true)
        
        
        tableView.reloadData()
        

    }
    


}
