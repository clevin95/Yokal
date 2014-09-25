//
//  SearchResultsFinder.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/24/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class SearchResultsFinder: NSObject {
    
    
    class func getAllAddressesForString (searchString:String, arrayPassback:((NSArray) -> Void)) {
        arrayPassback([])

        let allowedCharacters:NSCharacterSet = NSCharacterSet.URLHostAllowedCharacterSet()
        
        let searchString:String = searchString.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters)!
        let apiKeyString:String = "AIzaSyCYW2e6uvo2O1LR1p7mbJC_ku--FsLe2Lw"
        let urlString:String = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=" + searchString + "&types=geocode&key=" + apiKeyString
        
        
        let url = NSURL(string: urlString)
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {(data, response, error) in
            if( (error != nil)){
                arrayPassback(["no"])
            }else {
            
                let outputArray:NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error:nil) as NSDictionary
                let predictions:NSArray = outputArray["predictions"] as NSArray
                var allAddresses:[String] = []
                for prediction:AnyObject in predictions  {
                    let description:String = (prediction as NSDictionary)["description"] as String
                    allAddresses.append(description)
                }
                arrayPassback(allAddresses)
            }
        }
        task.resume()

    }

    
}
