//
//  Traveller.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/30/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import Foundation
import CoreData


@objc(Traveller)
class Traveller: NSManagedObject {
    @NSManaged var email: String?
    @NSManaged var name: String?
    @NSManaged var password: String?
    @NSManaged var profilePicture: NSData?
    @NSManaged var uniqueID: String?
    @NSManaged var posts: NSSet?
    
}

