//
//  TipAnnotation.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/26/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import MapKit

class TipAnnotation: NSObject, MKAnnotation {
    var coordinate:CLLocationCoordinate2D
    var selected:Bool = false
    lazy var annotationView:MKAnnotationView = self.initializeView()
    var post:Post
    
    init(post:Post) {
        self.coordinate = CLLocationCoordinate2D(latitude: post.latitude, longitude: post.longitude)
        self.post = post
    }

    func initializeView() -> MKAnnotationView {
        let annotationView:MKAnnotationView = MKAnnotationView(annotation: self, reuseIdentifier: "TipAnnotation")
        annotationView.frame = CGRectMake(0, 0, 30, 30)
        
        annotationView.layer.cornerRadius = annotationView.frame.height / 2
        
        
        annotationView.layer.backgroundColor = UIColor(red: 0.3, green: 0.5, blue: 0.6, alpha: 1).CGColor
        

        
        return annotationView
    }
}
