//
//  ParseHelper.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/23/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Parse

class ParseHelper {
    
    static let ParseFollowClass = "Follow"
    static let ParseFollowFromUser = "FromUser"
    static let ParseFollowToUser = "toUser"
    
    static let ParseLikeClass = "Like"
    static let ParseLikeToPost = "toPost"
    static let ParseLikeFromUser = "fromUser"
    
    static let ParsePostUser = "user"
    static let ParsePostCreatedAt = "createdAt"
    static let ParsePostLocationCoordinates = "locationCoordinates"
    
    static let ParseFlaggedContentClass = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost = "toPost"
    
    static let ParseUserUsername = "username"
    
    static let ParseLocationClass = "Location"
    static let ParseLocationName = "name"
    static let ParseLocationCoordinates = "coordinates"
    static let ParseLocationObjectId = "objectId"
    
    static func timelineRequestForCurrentUser(completionBlock:PFArrayResultBlock){
        
        let followingQuery = PFQuery(className: ParseFollowClass)
        followingQuery.whereKey(ParseFollowFromUser, equalTo: PFUser.currentUser()!)
        
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers?.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
        
        let postsFromThisUser = Post.query()
        postsFromThisUser?.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!,postsFromThisUser!])
        
        query.includeKey(ParsePostUser)
        
        query.orderByDescending(ParsePostCreatedAt)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    //MARK:Like
    
    static func likePost(user:PFUser,post:Post){
        
        let likeObject = PFObject(className: ParseLikeClass)
        likeObject[ParseLikeToPost] = post
        likeObject[ParseLikeFromUser] = user
        
        likeObject.saveInBackgroundWithBlock(nil)
    }
    
    static func unlikePost(user:PFUser,post:Post){
        
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeFromUser, equalTo: user)
        query.whereKey(ParseLikeToPost, equalTo: post)
        
        query.findObjectsInBackgroundWithBlock { (results:[AnyObject]?, error:NSError?) -> Void in
            
            if let results = results as? [PFObject]{
                for like in results{
                    
                    like.delete()
                }
            }
        }
    }
    
    static func likesForPost(post:Post,completionBlock:PFArrayResultBlock){
        
        let query = PFQuery(className: ParseLikeClass)
        query.whereKey(ParseLikeToPost, equalTo: post)
        query.includeKey(ParseLikeFromUser)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    // MARK: Following
    
    static func getFollowingUsersForUser(user: PFUser, completionBlock: PFArrayResultBlock) {
        let query = PFQuery(className: ParseFollowClass)
        
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
    static func addFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let followObject = PFObject(className: ParseFollowClass)
        followObject.setObject(user, forKey: ParseFollowFromUser)
        followObject.setObject(toUser, forKey: ParseFollowToUser)
        
        followObject.saveInBackgroundWithBlock(nil)
    }
    
    static func removeFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
        let query = PFQuery(className: ParseFollowClass)
        query.whereKey(ParseFollowFromUser, equalTo:user)
        query.whereKey(ParseFollowToUser, equalTo: toUser)
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            let results = results as? [PFObject] ?? []
            
            for follow in results {
                follow.delete() //not using deleteInBackground
            }
        }
    }
    
    // MARK: Users
    
    static func allUsers(completionBlock: PFArrayResultBlock) -> PFQuery {
        let query = PFUser.query()!
        // exclude the current user
        query.whereKey(ParseHelper.ParseUserUsername,
            notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    static func searchUsers(searchText: String, completionBlock: PFArrayResultBlock)
        -> PFQuery {
            
            let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
                matchesRegex: searchText, modifiers: "i")
            
            query.whereKey(ParseHelper.ParseUserUsername,
                notEqualTo: PFUser.currentUser()!.username!)
            
            query.orderByAscending(ParseHelper.ParseUserUsername)
            query.limit = 20
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            return query
    }
    
    // MARK:Nearby Location
    
    static func nearbyLocationRequestForCurrentUser(userCurrentCoordinates:PFGeoPoint,completionBlock:PFArrayResultBlock){
        
        let locationParseQuery = PFQuery(className: ParseLocationClass)
        locationParseQuery.whereKey(ParseLocationCoordinates, nearGeoPoint: userCurrentCoordinates, withinKilometers: 1)
        
        let nearbyLocationQuery = Post.query()
        nearbyLocationQuery?.whereKey(ParsePostLocationCoordinates, matchesKey: ParseLocationObjectId, inQuery: locationParseQuery)
        
        nearbyLocationQuery!.findObjectsInBackgroundWithBlock(completionBlock)
    }
}


public func containsParseUser(element:PFObject,array:[PFObject]) -> Bool {
    
    for item in array {
        if item.objectId == element.objectId{
            return true
        }
    }
    return false
}

public func removeObjectFromArray(user: PFUser, array: [PFUser]) -> [PFUser] {
    var a = array
    for i in 0..<a.count {
        if a[i].objectId == user.objectId {
            a.removeAtIndex(i)
            return a
        }
    }
    return a
}
