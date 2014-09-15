//
//  MakePostViewController.swift
//  YokalSwift
//
//  Created by Carter Levin on 7/19/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import CoreLocation

class MakePostViewController: UIViewController {
    var delegate : makePostDelegate? = nil
    var postLocation:CLLocationCoordinate2D?
    @IBOutlet var postTextView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let backgroundColor = UIColor(white: 1, alpha: 0.4)
        //view.layer.backgroundColor = backgroundColor.CGColor
        postTextView!.layer.cornerRadius = 8
        postTextView!.layer.borderWidth = 0.5
        postTextView!.layer.borderColor = UIColor.blackColor().CGColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews()  {
        /*
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView:UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = postTextView!.frame
        effectView.layer.cornerRadius = 10
        effectView.clipsToBounds = true

        view.insertSubview(effectView, atIndex: 1)
*/
    }
    
    @IBAction func cancel(sender: AnyObject) {
        postTextView!.resignFirstResponder()
        delegate?.finishedPosting()
    }

    @IBAction func post(sender: AnyObject) {
        postTextView!.resignFirstResponder()
        let postContent:String = postTextView!.text
        let store:DataStore = DataStore.sharedInstance
        if postLocation != nil {
            let postDictionary:[String:AnyObject] = ["content" : postContent, "latitude" : postLocation!.latitude, "longitude" : postLocation!.longitude]
            store.createPostWithContentDictionary(postDictionary)
        }
        delegate?.finishedPosting()
    }
}

protocol makePostDelegate {
    func finishedPosting ()
}