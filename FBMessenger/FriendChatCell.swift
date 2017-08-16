//
//  FriendChatCell.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/22/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit
import Firebase

class FriendChatCell: UICollectionViewCell {
    

    var friendImageView: UIImageView!
    var messageBubbleView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        friendImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        friendImageView.center = CGPoint(x: 12 + friendImageView.frame.width/2, y: frame.height-friendImageView.frame.height/2)
        friendImageView.layer.cornerRadius = friendImageView.frame.width/2
        friendImageView.layer.masksToBounds = true
        addSubview(friendImageView)
        
        messageBubbleView = UITextView(frame: CGRect(x: friendImageView.frame.origin.x + friendImageView.frame.width + 12, y: 0, width: frame.width*0.5, height: frame.height))
        messageBubbleView.layer.cornerRadius = 10
        messageBubbleView.backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 1.0)
        messageBubbleView.textColor = .black
        messageBubbleView.font = UIFont.systemFont(ofSize: 16)
        addSubview(messageBubbleView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
