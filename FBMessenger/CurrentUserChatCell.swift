//
//  CurrentUserChatCell.swift
//  FBMessenger
//
//  Created by Kevin Chan on 7/22/17.
//  Copyright © 2017 Kevin Chan. All rights reserved.
//

import UIKit

class CurrentUserChatCell: UICollectionViewCell {
    
    var messageBubbleView: UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        messageBubbleView = UITextView(frame: CGRect(x: frame.width - frame.width*0.5 - 12, y: 0, width: frame.width*0.5, height: frame.height))
        messageBubbleView.backgroundColor = .blue
        messageBubbleView.layer.cornerRadius = 10
        messageBubbleView.textColor = .white
        messageBubbleView.font = UIFont.systemFont(ofSize: 16)
        addSubview(messageBubbleView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
