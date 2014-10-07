//
//  TravellerExtension.swift
//  Yokal2.0
//
//  Created by Carter Levin on 9/23/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import Foundation
import UIKit

extension Traveller{
    
   /// var profileImageAsImage:Image?
    func getProfilePictureImage(imagePassback:((UIImage?) -> Void)) {
        
        
        if (profilePictureImage != nil){
            imagePassback(profilePictureImage!)
        }
        else if (hasImage){
            APIClient.getProfileImageForTravellerID(uniqueID!, successPassback: { (imageData) -> Void in
                
                
                if (imageData != nil) {
                    self.profilePicture = imageData;
                    self.profilePictureImage = UIImage(data: imageData!);
                    imagePassback(self.profilePictureImage)
                }
                else {
                    self.hasImage = false;
                    imagePassback(nil)
                }
            })
        }
        else {
            imagePassback(nil)
        }
    }
    
    func setUpTraveller () {
    }
}