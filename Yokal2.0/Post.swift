//
//  Post.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/20/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import Foundation
import CoreData


@objc(Post)
class Post: NSManagedObject {

    @NSManaged var content: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var uniqueID: NSNumber
    @NSManaged var traveller: Traveller
}
