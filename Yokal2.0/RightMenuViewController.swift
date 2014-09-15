//
//  RightMenuViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/25/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class RightMenuViewController: UIViewController {
    var delegate:RightMenuDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundView:UIView = UIView(frame: view.frame)
        backgroundView.backgroundColor = UIColor.mySalmon()
        backgroundView.alpha = 0.3
        view.insertSubview(backgroundView, atIndex: 0)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

protocol RightMenuDelegate {
    
}
