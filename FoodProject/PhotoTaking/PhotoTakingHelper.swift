//
//  PhotoTakingHelper.swift
//  FoodProject
//
//  Created by VIMLAN.G on 8/22/15.
//  Copyright © 2015 VIMLAN.G. All rights reserved.
//

import UIKit

typealias PhotoTakingHelperCallback = UIImage? -> Void

class PhotoTakingHelper: NSObject {
    
    weak var viewController : UIViewController!
    var callback : PhotoTakingHelperCallback
    var imagePickerController : UIImagePickerController?
    
    init(viewController:UIViewController,callback: PhotoTakingHelperCallback){
        self.viewController = viewController
        self.callback = callback
        
        super.init()
        
        showPhotoSourceSelection()
    }
    
    func showPhotoSourceSelection(){
        
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if(UIImagePickerController.isCameraDeviceAvailable(.Rear)){
            let cameraAction = UIAlertAction(title: "From Camera", style: UIAlertActionStyle.Default) { (action) -> Void in
                //camera function
                self.showImagePickerController(.Camera)
            }
            alertController.addAction(cameraAction)
        }
        
        let photoLibraryAction = UIAlertAction(title: "From Library", style: UIAlertActionStyle.Default) { (action) -> Void in
            //photoLibrary function
            self.showImagePickerController(.PhotoLibrary)
        }
        alertController.addAction(photoLibraryAction)
        
        self.viewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showImagePickerController(sourceType:UIImagePickerControllerSourceType){
        
        imagePickerController = UIImagePickerController()
        imagePickerController?.sourceType = sourceType
        imagePickerController!.delegate = self
        self.viewController.presentViewController(imagePickerController!, animated: true, completion: nil)
    }
}

// MARK: PhotoTakingHelper:Delegates
extension PhotoTakingHelper:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
        
        callback(image)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
