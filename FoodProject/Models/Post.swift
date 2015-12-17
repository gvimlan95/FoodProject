//
//  Post.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/23/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Parse
import Bond

class Post: PFObject,PFSubclassing {

    @NSManaged var imageFile : PFFile?
    @NSManaged var user : PFUser?
    @NSManaged var locationCoordinates : PFGeoPoint?
    
    var image = Observable<UIImage?>(nil)
    var likes = Observable<[PFUser]?>(nil)
    var photoUploadTask : UIBackgroundTaskIdentifier?
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init(){
        super.init()
    }
    
    override class func initialize(){
        var onceToken : dispatch_once_t = 0
        dispatch_once(&onceToken){
        
        self.registerSubclass()
        }
    }
    
    func uploadPost(){
        
        let imageData = UIImageJPEGRepresentation(image.value!!, 0.2)
        let imageFile = PFFile(data: imageData!)
        
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        imageFile.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
        }
        
        self.imageFile = imageFile
        self.user = PFUser.currentUser()
        saveInBackgroundWithBlock(nil)
    }
    
    func downloadImage(){
        
        if(image.value != nil){
            
            self.imageFile?.getDataInBackgroundWithBlock { (data:NSData?, error:NSError?) -> Void in
               
                if let data = data{
                    let image = UIImage(data:data,scale:1.0)!
                    
                    self.image.value = image
                }
            }
        }
    }
    
    func fetchLikes(){
        
        if let _ = likes.value!{
            return
        }
        
        ParseHelper.likesForPost(self) { (var likes:[AnyObject]?, error:NSError?) -> Void in
            
            likes = likes?.filter { like in like[ParseHelper.ParseLikeFromUser] != nil} //if the user is still active
            
            self.likes.value = likes?.map { like in
                
                let like = like as! PFObject
                let fromUser = like[ParseHelper.ParseLikeFromUser] as! PFUser
                return fromUser
            }
        }
    }
    
    func doesUserLikePost(user:PFUser) -> Bool {
        if let likes = likes.value{
            return containsParseUser(user, array: likes!)
        }else{
            return false
        }
    }
    
    func toggleLikePost(user:PFUser){
        if(doesUserLikePost(user)){
            likes.value = removeObjectFromArray(user, array: likes.value!!)
            ParseHelper.unlikePost(user, post: self)
        }else{
            likes.value??.append(user)
            ParseHelper.likePost(user, post: self)
        }
    }
}
