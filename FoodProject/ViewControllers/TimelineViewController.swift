//
//  TimelineViewController.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/22/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit
import Parse
import UIScrollView_InfiniteScroll

var photoTakingHelper : PhotoTakingHelper?

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts : [Post] = []
    
    var refreshControl : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshData()
        
//        ParseHelper.timelineRequestForCurrentUser { (results:[AnyObject]?, error:NSError?) -> Void in
//            self.posts = results as? [Post] ?? []
//            
//            self.tableView.reloadData()
//        }
    }
    
    func refreshData(){
        
        ParseHelper.timelineRequestForCurrentUser { (results:[AnyObject]?, error:NSError?) -> Void in
            self.posts = results as? [Post] ?? []            
            self.tableView.reloadData()
        }
        
        self.refreshControl.endRefreshing()

    }
}

extension TimelineViewController : UITabBarControllerDelegate{
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        
        if(viewController is PhotoViewViewController){
            takePhoto()
            return false
        }else{
            return true
        }
    }
    
    func takePhoto(){
        
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image:UIImage?) -> Void in
            
            
//            let location = Location()
//            location.uploadLocation()
//            let post = Post()
//            post.image.value = image
//            post.uploadPost()
            
            self.performSegueWithIdentifier("toView", sender: self)

        }
    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }
}

extension TimelineViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        post.downloadImage()
        post.fetchLikes()
        cell.post = post
        return cell
    }
    
    
}
