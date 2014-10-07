//
//  FacebookAPIClient.swift
//  Yokal2.0
//
//  Created by Carter Levin on 9/26/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class FacebookAPIClient: NSObject {
    
    class func startLogInWithAccessToken(token:String, successCallback:((Bool)-> Void)) {
        let urlString = "https://graph.facebook.com/me?access_token=" + token
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)) {(data, response, error) in
            let userDictionary:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
            print(userDictionary)
            let userID:String = userDictionary["id"] as String;
            let store = DataStore.sharedInstance
            store.validateTravellerForFacebookID(userID, successBlock: { (success) -> Void in
                
                
                if (!success) {
                    var travellerDictionary:NSMutableDictionary = NSMutableDictionary()
                    travellerDictionary["username"] = userDictionary["first_name"] as? String
                    travellerDictionary["facebook_id"] = userDictionary["id"] as? String
                    travellerDictionary["email"] = userDictionary["email"] as? String
                    self.getProfilePictureWithToken(token, successCallback: { (imageData) -> Void in
                        travellerDictionary["profileImage"] = imageData;
                        store.createTravellerWithContentDictionary(travellerDictionary, completed: { () -> Void in
                            successCallback(true)
                        })
                    })
                }
                else {
                    successCallback(true)
                }
            })
        }
        task.resume()
    }
    
    class func getProfilePictureWithToken(token:String, successCallback:((NSData)-> Void)) {
        let urlString = "https://graph.facebook.com/me/picture?height=200&type=normal&width=200&access_token=" + token
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)) {(data, response, error) in
            successCallback(data);
        }
        task.resume()
    }
    

    class func checkforUserWithID(facebook_id:String, withCompletion:(() -> Void)) {
        
    }
    
    class func signUpUserWithSecret(secret:String) {
        //getUserName(secret)
    }
}

