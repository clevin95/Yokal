//
//  PostAnnotation.swift
//  YokalSwift
//
//  Created by Carter Levin on 7/19/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import MapKit

class PostAnnotation: NSObject, MKAnnotation {
    var coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    init(coordinate : CLLocationCoordinate2D)  {
        super.init()
        self.coordinate = coordinate
        
    }
}
