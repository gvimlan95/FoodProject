//
//  FriendSearchTableViewCell.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/26/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Parse

protocol FriendSearchTableViewCellDelegate:class{
    func cell(cell:FriendSearchTableViewCell, didSelectFollowUser user:PFUser)
    func cell(cell:FriendSearchTableViewCell, didSelectUnfollowUser user:PFUser)
}

class FriendSearchTableViewCell: UITableViewCell {

    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    weak var delegate: FriendSearchTableViewCellDelegate?
    
    var user: PFUser? {
        didSet {
            usernameLabel.text = user?.username
        }
    }
    
    var canFollow: Bool? = true {
        didSet {
            if let canFollow = canFollow {
                followButton.selected = !canFollow
            }
        }
    }
    
    @IBAction func followButtonTapped(sender: AnyObject) {
        if let canFollow = canFollow where canFollow == true {
            delegate?.cell(self, didSelectFollowUser: user!)
            self.canFollow = false
        } else {
            delegate?.cell(self, didSelectUnfollowUser: user!)
            self.canFollow = true
        }
    }
}