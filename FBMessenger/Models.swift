//
//  Models.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/18/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit
import Firebase


class Global {
    
    static func createAlert(title: String, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    
}

class User {
    
    var name: String?
    var email: String?
    var profileImage: UIImage?
    var userId: String?
    
    init(name: String, email: String, usrId: String) {
        self.name = name
        self.email = email
        self.userId = usrId
    }
    
    init(name: String, email: String, profileImage: UIImage) {
        self.name = name
        self.email = email
        self.profileImage = profileImage
    }
}

class Message {
    
    var receiverId: String?
    var senderId: String?
    var text: String?
    var date: NSDate?
    var timeSince1970: Int?

    
    
}

class Messages {
    
    var messageArray: [Message]?
    
    init(messageArray: [Message]) {
        self.messageArray = messageArray
    }
    
}

class FriendIds {
    
    var friendIdsArray: [String]?
    
    init(friendIdsArray: [String]) {
        self.friendIdsArray = friendIdsArray
    }
    
}












