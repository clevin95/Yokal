//
//  CentralLoginViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/27/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit



class CentralLoginViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var scroller:UIScrollView = UIScrollView()
    var loginController:LoginViewController?
    var signUpController:SignUpViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginController = self.storyboard!.instantiateViewControllerWithIdentifier("login") as? LoginViewController
        signUpController = self.storyboard!.instantiateViewControllerWithIdentifier("signup") as? SignUpViewController
        addChildViewController(signUpController!)
        addChildViewController(loginController!)

        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView:UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = view.frame
        effectView.layer.cornerRadius = 10
        self.view.insertSubview(effectView, atIndex: 0)
        scroller.showsHorizontalScrollIndicator = false
        
        let scrollerHeight = view.frame.height / 2;
        
        let scrollerStart:CGFloat = 140
        scroller.frame = CGRect(x: 0, y:scrollerStart, width: view.frame.width, height: scrollerHeight)
        let signUpView:UIView = UIView(frame: CGRect(x: 0, y: 0, width:view.frame.width, height: scrollerHeight))
        let loginView:UIView = UIView(frame: CGRectOffset(signUpView.frame, view.frame.width, 0))
        view.insertSubview(scroller, atIndex: 2)
        scroller.addSubview(signUpView)
        scroller.addSubview(loginView)
        signUpView.backgroundColor = UIColor.clearColor()
        loginView.backgroundColor = UIColor.clearColor()
        scroller.contentSize = CGSize(width: scroller.frame.width * 2, height: scroller.frame.height)
        scroller.pagingEnabled = true;
        signUpView.addSubview(signUpController!.view)
        loginView.addSubview(loginController!.view)
        
    
        /*
        
        let backgroundImage:UIImage = UIImage(named: "backgroundScreen.png")
        let backgroungImageView:UIImageView = UIImageView(frame: view.frame)
        backgroungImageView.contentMode = UIViewContentMode.ScaleAspectFit
        backgroungImageView.image = backgroundImage
        view.insertSubview(backgroungImageView, atIndex: 0)
        
        var blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let effectView:UIVisualEffectView = UIVisualEffectView(effect: blur)
        effectView.frame = view.frame
        view.insertSubview(effectView, atIndex: 1)
*/
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        /*
        scroller.frame = view.frame
        scroller.contentSize = CGSizeMake(view.frame.width * 2, view.frame.height)
        loginContainer.frame = CGRectOffset(view.frame, 0, 100)
        signUpContainer.frame = CGRectOffset(view.frame, view.frame.width, 100)

*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func signUpTapped(sender: AnyObject) {
        
        UIView.animateWithDuration(0.2, animations: {
             self.scroller.contentOffset = CGPoint(x: 0, y: 0)
        })
    }
    

    
    
    @IBAction func submitTapped(sender: AnyObject) {
        
        
        if scroller.contentOffset.x == 0{
            signUpController!.submitAction()
        }
        else {
            
            loginController!.submitTapped()
        }
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        UIView.animateWithDuration(0.2, animations: {
            self.scroller.contentOffset = CGPoint(x: self.view.frame.width, y: 0)
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
