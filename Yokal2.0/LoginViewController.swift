//
//  LoginViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/27/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func submitTapped() {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()   
        let store:DataStore = DataStore.sharedInstance
        let interumView:UIView = UIView(frame: view.frame)
        interumView.alpha = 0.8
        interumView.backgroundColor = UIColor.grayColor()
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.parentViewController!.view.addSubview(interumView)
        })
        store.validateTraveller(emailField.text, password: passwordField.text, successBlock: {(success:Bool) in
            
            if (success){
                NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
            }
            else {
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    interumView.removeFromSuperview()
                })
            }
         })
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
