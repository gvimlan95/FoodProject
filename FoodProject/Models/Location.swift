//
//  Location.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/23/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Parse

typealias locationCallback = String? -> Void

class Location: PFObject,PFSubclassing {
    
    @NSManaged var name : String?
    @NSManaged var coordinates : PFGeoPoint?
    
    var locationObjectId : String?
    
    static func parseClassName() -> String {
        return "Location"
    }
    
    override init(){
        
        super.init()
        
        self.getCurrentUserLocation()
    }
    
    override class func initialize(){
        var onceToken : dispatch_once_t = 0
        dispatch_once(&onceToken){
            self.registerSubclass()
        }
    }
    
    func getCurrentUserLocation(){
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error:NSError?) -> Void in
            
            self.coordinates = geoPoint
        }
    }
    
    func uploadLocation(){
        
        self.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            
            if error == nil{
                print("object id \(self.objectId)")
                self.locationObjectId = self.objectId!
            }
        }
    }
}
