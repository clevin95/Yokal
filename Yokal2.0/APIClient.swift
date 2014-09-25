//
//  APIClient.swift
//  YokalSwift
//
//  Created by Carter Levin on 7/19/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
let homeURL:String = "http://localhost:8080/api/" // "http://yokalrest.herokuapp.com/api/" //"http://beingthere.herokuapp.com/"
class APIClient: NSObject {
    class func getCloudPosts (arrayPassback:((NSArray) -> Void)){
        let url = NSURL(string: homeURL + "travellers/posts")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let outputArray:NSArray = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
            arrayPassback(outputArray)
        }
        task.resume()
    }
    class func getCloudPostsForTraveller (travellerID:NSString, arrayPassback:((NSArray) -> Void)){
        let url = NSURL(string: homeURL + "travellers/" + travellerID + "/posts")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let outputArray:NSArray? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSArray
            if (outputArray != nil){
                arrayPassback(outputArray!)
            }
        }
        task.resume()
    }
    
    class func createCloudPostFromDictionary (postDictionary:[String:AnyObject], forTraveller traveller:Traveller){
        var session:NSURLSession = NSURLSession.sharedSession()
        var error:NSError?
        let travellerID = traveller.uniqueID
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: homeURL + "travellers/"+travellerID!+"/posts"))
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(postDictionary, options: nil, error: &error)
        request.HTTPMethod = "POST"
        if (error != nil) {
            println("\(error?.localizedDescription)")
            return
        }
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            if ((error) != nil){
                println("\(error)")
            }else {
            }
            })
        task.resume()
    }
    
    class func validateTraveller (email:String, password:String, arrayPassback:((NSDictionary?) -> Void)){
        let travellerDataString = "email=" + email + "&password=" + password
        let url = NSURL(string: homeURL + "travellers?" + travellerDataString)
        print(url)
        var session:NSURLSession = NSURLSession.sharedSession()
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let validationDictionary = ["email" : email, "password" : password]
        var error:NSError?
//        let requestData:NSData = travellerDataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(validationDictionary, options: nil, error: &error)
        [request .addValue("application/json", forHTTPHeaderField: "Content-Type")]
        request.HTTPMethod = "PUT"
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            if let outputDictionary:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary{
                if (outputDictionary["message"] != nil){
                        print(outputDictionary["message"])
                        arrayPassback(nil)
                    }
                else {
                    arrayPassback(outputDictionary)
//                    var mutableDictionary:NSMutableDictionary = outputDictionary.mutableCopy() as NSMutableDictionary
//                    print(mutableDictionary)
//                    var travellerID:String = (mutableDictionary["unique_id"] as NSNumber).stringValue
//                    self.getProfileImageForTravellerID(travellerID, successPassback: { (testImage:NSData) -> Void in
//                        print(testImage)
//                        mutableDictionary["profilepicture"] = testImage
//                        
//                    })

                }
            }
        })
        task.resume()
    }
    
    class func getAllTravellers (arrayPassback:((NSArray) -> Void)){
        let url = NSURL(string: homeURL + "travellers")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            let outputArray:NSArray? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSArray
            if (outputArray != nil){
                arrayPassback(outputArray!)
            }
        }
        task.resume()
    }
    
    
    class func createTravellerRemotely (travellerDictionary:[String:String], idPassback:((NSString) -> Void)) {
        var session:NSURLSession = NSURLSession.sharedSession()
        var error:NSError?
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string: homeURL + "travellers"))
        request.HTTPMethod = "POST"
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(travellerDictionary, options: nil, error: &error)
        if (error != nil) {
            println("\(error?.localizedDescription)")
            return
        }
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            if ((error) != nil){
                print(error)
            }else {
                let responseID:NSDictionary? = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary?
                print(responseID)
                let userID:NSNumber = responseID!["unique_id"] as NSNumber
                //let userID:Int = userID
                
                idPassback(userID.stringValue)
            }
            })
        task.resume()
    }
    
    class func updateRemoteProfileImage(traveller:Traveller, successPassback:((Void) -> Void)) {
        let url = NSURL(string: homeURL + "travellers/" + traveller.uniqueID!)
        var session:NSURLSession = NSURLSession.sharedSession()
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var error:NSError?
        request.HTTPBody = traveller.profilePicture!
        request.HTTPMethod = "PUT"
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        print(error)
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            successPassback()
            })
        task.resume()
    }
    
    class func getProfileImageForTravellerID(travellerID:String, successPassback:((NSData?) -> Void)) {
        let url = NSURL(string: homeURL + "travellers/" + travellerID + "/profile_picture")
        var session:NSURLSession = NSURLSession.sharedSession()
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        var error:NSError?
        request.HTTPMethod = "GET"
        print(error)
        let task = session.dataTaskWithRequest(request, completionHandler: {(data,response,error) in
            print(error)
            print(data)
            if (error != nil) {
                print(error)
                successPassback(nil)
            }
            successPassback(data)
        })
        task.resume()
    }
}
