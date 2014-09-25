//
//  BottomMenuViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/25/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class BottomMenuViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @IBOutlet weak var postFilterSegment: UISegmentedControl!
    @IBOutlet weak var makePostButton: UIToolbar!
    var delegate:BottomMenuDelegate?
    let imagePicker:UIImagePickerController = UIImagePickerController()
    let store:DataStore = DataStore.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "updateProfile", name:"updateProfile", object:nil)
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        let backgroundView:UIView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.myYellow()
        backgroundView.alpha = 0.6
        view.insertSubview(backgroundView, atIndex: 0)
        makePostButton.clipsToBounds = true
        postFilterSegment.tintColor = UIColor.mySalmon()
        makePostButton.backgroundColor = UIColor.clearColor()
        
        makePostButton.setBackgroundImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any,
            barMetrics: UIBarMetrics.Default)
        makePostButton.setShadowImage(UIImage(),
            forToolbarPosition: UIBarPosition.Any)
    }

    func updateProfile () {
        if let parentCoordinator:MenuCoordinatorViewController = self.parentViewController as? MenuCoordinatorViewController {
            parentCoordinator.profileImageView.image = UIImage(named: "defaultImage.jpg")
            self.store.currentTraveller!.getProfilePictureImage({ (profileImage) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    parentCoordinator.profileImageView.image = profileImage
                })
            })
        }
    }
    
    override func viewDidLayoutSubviews()  {
        /*
        profileImage!.layer.cornerRadius = profileImage!.frame.height / 2.0
        profileImage!.clipsToBounds = true
        profileImage.layer.borderWidth = 1.5
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
*/
       // makePostButton!.layer.cornerRadius = makePostButton!.frame.height / 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func profileImageTapped() {
        self.presentViewController(imagePicker, animated: true, completion: {
            
            })
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]!) {
        imagePicker.dismissViewControllerAnimated(true, nil)
        let newProfileImage:UIImage = info[UIImagePickerControllerOriginalImage] as UIImage
        let imageURL:NSURL = info[UIImagePickerControllerReferenceURL] as NSURL
        var error:NSError? = nil
        
        var newHeight:CGFloat = newProfileImage.size.height / 30.0;
        var newWidth:CGFloat = newProfileImage.size.width / 30.0;
        var newSize:CGSize = CGSizeMake(newWidth, newHeight);
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        newProfileImage.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        var resizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        let imageData:NSData = UIImagePNGRepresentation(resizedImage)
        if (store.currentTraveller != nil){
            store.currentTraveller!.profilePicture = imageData
            updateProfile()
            store.updateTravellerProfileImage({
                
                });
        }
    }
    
    
    @IBAction func makePostTapped(sender: AnyObject) {
        delegate?.makePost()
    }
    
    func fadeInView(viewToFadeIn : UIView){
        viewToFadeIn.alpha = 0;
        viewToFadeIn.hidden = false
        UIView.animateWithDuration(0.2, animations: {
            viewToFadeIn.alpha = 1;
            })
    }
    
    func fadeOutView(viewToFadeOut : UIView){
        UIView.animateWithDuration(0.2, animations: {
            viewToFadeOut.alpha = 0
            })
    }
    
    func beginSearchingAnimation (){
        fadeOutView(postFilterSegment!)
        if let parentCoordinator:MenuCoordinatorViewController = parentViewController as? MenuCoordinatorViewController {
            fadeOutView(parentCoordinator.profileImageView)
        }
        fadeOutView(makePostButton)
    }
    
    func endSearchingAnimation (){
        fadeInView(makePostButton)
        fadeInView(postFilterSegment!)
        if let parentCoordinator:MenuCoordinatorViewController = parentViewController as? MenuCoordinatorViewController {
            fadeInView(parentCoordinator.profileImageView)
        }
    }
}

protocol BottomMenuDelegate {
    func makePost()
}