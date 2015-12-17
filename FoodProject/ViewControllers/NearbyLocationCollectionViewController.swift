//
//  NearbyLocationCollectionViewController.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/27/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "LocationCell"

class NearbyLocationCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var posts : [AnyObject] = []
    
    let screenSize : CGRect = UIScreen.mainScreen().bounds
    
    var coordinates : PFGeoPoint = PFGeoPoint(latitude: 0, longitude: 0)
    
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 2, bottom: 10.0, right: 2)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestLocation()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("Done")
        self.nearbyLocationPostRequest()
    }
    
    func requestLocation(){
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint:PFGeoPoint?, error:NSError?) -> Void in
            print("Users are currently at \(geoPoint)")
            self.coordinates = geoPoint!
        }
    }
    
    func nearbyLocationPostRequest(){
        
        ParseHelper.nearbyLocationRequestForCurrentUser(self.coordinates) { (results:[AnyObject]?, error:NSError?) -> Void in
            
            //results = results?.filter { result in result[ParseHelper.ParseLocationCoordinates] != nil}
            
            //            self.posts = (results?.map { result in
            //
            //                let like = result
            //                print("like \(like)")
            //                let fromUser = like[ParseHelper.ParsePostLocationCoordinates] as! PFObject
            //                let fromUser1 = fromUser[ParseHelper.ParseLocationCoordinates]
            //                print("fromUser \(fromUser1)")
            //                return result
            //            })!
            
            print("\(results)")
        }
    }
    
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NearbyLocationCollectionViewCell
        cell.backgroundColor = UIColor.orangeColor()
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: screenSize.width / 2 - 10 , height: screenSize.width / 2 - 10)
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
}

