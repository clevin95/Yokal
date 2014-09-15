//
//  SignUpViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/27/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordAgainField: UITextField!
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
    
    func submitAction() {
        let store:DataStore = DataStore.sharedInstance
        let userDictionary:[String:String] = ["username":nameField.text, "email":emailField.text, "password":passwordAgainField.text]
        store.createTravellerWithContentDictionary(userDictionary, {
            self.dismissViewControllerAnimated(true, completion: nil)
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
