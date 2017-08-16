//
//  MessagesCell.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/14/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit

class MessagesCell: UICollectionViewCell {

    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }
    var messageText: String? {
        didSet {
            if let text = messageText {
                messageLabel.text = text
            }
        }
    }
    var date: NSDate? {
        didSet {
            
            if let regDate = date as? Date {
            
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                timeLabel.text = formatter.string(from: regDate)
            }
            
        }
    }
    
    var profileImageView: UIImageView!
    var smallProfileImageView: UIImageView!
    var messengerImageView: UIImageView!
    var nameLabel: UILabel!
    var messageLabel: UILabel!
    var timeLabel: UILabel!
    var dividerLine: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        profileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width*0.17, height: frame.width*0.17))
        profileImageView.center = CGPoint(x: frame.width*0.1 + 10, y: frame.height/2)
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        addSubview(profileImageView)
        
        smallProfileImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width*0.07, height: frame.width*0.07))
        smallProfileImageView.center = CGPoint(x: frame.width*0.9, y: frame.height*0.65)
        smallProfileImageView.layer.cornerRadius = smallProfileImageView.frame.width/2
        smallProfileImageView.layer.masksToBounds = true
        addSubview(smallProfileImageView)
        
        messengerImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width*0.05, height: frame.width*0.05))
        messengerImageView.center = CGPoint(x: profileImageView.center.x + profileImageView.frame.width/2 - messengerImageView.frame.width/2, y: profileImageView.center.y + profileImageView.frame.height/2 - messengerImageView.frame.height/2)
        messengerImageView.image = #imageLiteral(resourceName: "messenger")
        messengerImageView.layer.cornerRadius = messengerImageView.frame.width/2
        messengerImageView.layer.masksToBounds = true
        messengerImageView.layer.borderWidth = 2.5
        messengerImageView.layer.borderColor = UIColor.white.cgColor
        messengerImageView.backgroundColor = .white
        addSubview(messengerImageView)
        
        nameLabel = UILabel(frame: CGRect(x: profileImageView.frame.origin.x + profileImageView.frame.width + 10, y: 0, width: frame.width*0.5, height: 30))
        nameLabel.center = CGPoint(x: nameLabel.center.x, y: frame.height*0.35)
        nameLabel.font = nameLabel.font.withSize(17)
        addSubview(nameLabel)
        
        messageLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.height, width: frame.width*0.6, height: 15))
        messageLabel.textColor = .lightGray
        messageLabel.font = messageLabel.font.withSize(12)
        addSubview(messageLabel)
        
        timeLabel = UILabel(frame: CGRect(x: 0, y: nameLabel.frame.origin.y, width: frame.width*0.2, height: 20))
        timeLabel.center = CGPoint(x: smallProfileImageView.center.x + smallProfileImageView.frame.width/2 - timeLabel.frame.width/2, y: timeLabel.center.y)
        timeLabel.textAlignment = .right
        timeLabel.font = timeLabel.font.withSize(13)
        addSubview(timeLabel)
        
        dividerLine = UIView(frame: CGRect(x: 16, y: frame.height-1, width: frame.width-32, height: 0.5))
        dividerLine.backgroundColor = UIColor.lightGray
        addSubview(dividerLine)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

