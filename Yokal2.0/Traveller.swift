//
//  Traveller.swift
//  Yokal2.0
//
//  Created by Carter Levin on 10/1/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import Foundation
import CoreData
import UIKit


@objc(Traveller)

class Traveller: NSManagedObject {

    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var password: String?
    @NSManaged var profilePicture: NSData?
    @NSManaged var uniqueID: String?
    @NSManaged var facebook_id: String?
    @NSManaged var posts: NSSet?
    var profilePictureImage:UIImage?
    var hasImage:Bool = false
}
