//
//  FriendCell.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/19/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    var profileImageView: UIImageView! 
    var nameLabel: UILabel!
    var emailLabel: UILabel!
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        profileImageView = UIImageView(frame: CGRect(x: 12, y: 0, width: 60, height: 60))
        profileImageView.center = CGPoint(x: profileImageView.center.x, y: 50)
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        addSubview(profileImageView)
        
        nameLabel = UILabel(frame: CGRect(x: profileImageView.frame.origin.x + profileImageView.frame.width + 12, y: profileImageView.frame.origin.y, width: frame.width*0.5, height: 25))
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        nameLabel.textColor = .black
        addSubview(nameLabel)
        
        emailLabel = UILabel(frame: CGRect(x: nameLabel.frame.origin.x, y: nameLabel.frame.origin.y + nameLabel.frame.height
            , width: frame.width*0.5, height: 25))
        emailLabel.font = UIFont.systemFont(ofSize: 13)
        emailLabel.textColor = .lightGray
        addSubview(emailLabel)
        
    }
}
