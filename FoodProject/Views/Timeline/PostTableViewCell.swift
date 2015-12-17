//
//  PostTableViewCell.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/23/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    var post:Post?{
        didSet{
            if let post = post {
                post.image.bindTo(self.postImageView.bnd_image)
                
                post.likes.observe { [unowned self] likeList in
                    
                    if let likeList = likeList {
                        
                        if likeList.count > 1{
                            self.likesLabel.text = ("\(likeList.count) likes")
                        }else if likeList.count == 1 {
                            self.likesLabel.text = ("\(likeList.count) like")
                        }else{
                            self.likesLabel.text = ""
                        }
                        
                        self.likeButton.selected = containsParseUser(PFUser.currentUser()!,array: likeList)
                        
                        self.likesIconImageView.hidden = (likeList.count == 0)
                    } else {
                        
                        self.likesLabel.text = ""
                        self.likeButton.selected = false
                        self.likesIconImageView.hidden = true
                    }
                }
            }
        }
    }
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
    }
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    
    //    func stringFromUserList(userList: [PFUser]) -> String {
    //        // 1
    //        let usernameList = userList.map { user in user.username! }
    //        // 2
    //        let commaSeparatedUserList = ", ".join(usernameList)
    //
    //        return commaSeparatedUserList
    //    }
}
