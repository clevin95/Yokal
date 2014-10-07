//
//  MiddleMenuViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/25/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class MiddleMenuViewController: UIViewController {
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var profileContainer: UIScrollView!
    weak var profileView:ProfileView?
    var delegate:MiddleMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundView:UIView = UIView(frame: view.frame)
        backgroundView.alpha = 0.3
        backgroundView.layer.backgroundColor = UIColor.myGreen().CGColor
        
        UIGraphicsBeginImageContextWithOptions(flagImageView.image!.size, false, UIScreen.mainScreen().scale); // for correct resolution on retina, thanks @MobileVet
        let context = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(context, 0, flagImageView.image!.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        let rect = CGRectMake(0, 0, flagImageView.image!.size.width, flagImageView.image!.size.height);
        
        profileContainer.backgroundColor = UIColor.clearColor()
        // image drawing code here
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        view.insertSubview(backgroundView, atIndex: 0)
        NSNotificationCenter.defaultCenter().addObserver(self,selector: "updateProfile", name:"updateProfile", object:nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        addProfile()
    }
    
    func addProfile () {
        let profileRect:CGRect = CGRectMake(0, 0, profileContainer.frame.width, profileContainer.frame.height * 2.4)
        
        let tempProfileView:ProfileView = ProfileView(frame: profileRect)

        ProfileView.initialize()
        print(profileView);
        
        profileContainer.clipsToBounds = true
        profileContainer!.contentSize = profileRect.size
        tempProfileView.piChart.layer.cornerRadius = tempProfileView.piChart.frame.height / 2 - 20
        profileContainer.addSubview(tempProfileView)
        profileView = tempProfileView;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let store:DataStore = DataStore.sharedInstance
        super.viewWillAppear(animated)
        if(store.currentTraveller != nil){
             //nameLabel.text = store.currentTraveller?.name
        }
    }
    
    func updateProfile (){
        NSOperationQueue.mainQueue().addOperationWithBlock({
            let store:DataStore = DataStore.sharedInstance
            self.profileView!.nameLabel.text = store.currentTraveller!.name
        })
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol MiddleMenuDelegate {
    
}
