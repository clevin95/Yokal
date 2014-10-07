//
//  LoginWebViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 9/26/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class LoginWebViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var signInWebView: UIWebView!
    var urlString:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        signInWebView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        var cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
        for (var i = 0; i < cookies?.count; i = i + 1) {
            let cookie:NSHTTPCookie = cookies![i] as NSHTTPCookie
            NSHTTPCookieStorage.sharedHTTPCookieStorage().deleteCookie(cookie)
        }
    
        signInWebView.loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")))
        super.viewDidAppear(animated)
        var url = NSURL(string: urlString!)
        var request = NSURLRequest(URL: url)
        signInWebView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        //print(webView)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        println("NEW LOAD :: \n\n")
        
        print(request)
        var urlString:NSString = request.URL.absoluteString!
        var splitByCode:[String] = urlString.componentsSeparatedByString("access_token=") as [String];

        if splitByCode.count == 2 {
            let accessToken = splitByCode[1].componentsSeparatedByString("&")[0];
            println("\n\n\n\n")
            print(accessToken)
            println("\n\n\n\n")
            FacebookAPIClient.startLogInWithAccessToken(accessToken, successCallback: { (success) -> Void in
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            });
            /*
            
            let urlString = "https://graph.facebook.com/oauth/access_token?client_id=579052432201400&redirect_uri=http://www.facebook.com/connect/login_success.html&client_secret=590cfada059181acc6e564f07a9c037d&code=" + codeString
            let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)) {(data, response, error) in

                println("\n\n")
            }

            task.resume()
*/

        }
        return true;
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
