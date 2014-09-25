 //
//  MapViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/25/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import QuartzCore

class MapViewController: UIViewController, CLLocationManagerDelegate, postFetcherDelegate, MKMapViewDelegate{
    @IBOutlet weak var mapOfWorld: MKMapView!
    let locationManager = CLLocationManager()
    let postFetcherInsance = PostFetcher()
    var currentLocation:CLLocationCoordinate2D?
    var previousRegion:MKCoordinateRegion?
    //var selectedAnotationView:MKAnnotationView = MKAnnotationView()
    var delegate:mapControllerDelegate?
    var inPostView:Bool = false
    var annotationSet:[TipAnnotation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPostFetcher()
        setUpLocationManager()
        mapOfWorld.delegate = self
        mapOfWorld.rotateEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let tipAnnotation:TipAnnotation = annotation as? TipAnnotation {
            var annotationView:MKAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("TipAnnotation")
            if (annotationView == nil){
                annotationView = tipAnnotation.annotationView
            } else {
                annotationView!.annotation = annotation
            }
            let profileImageView:UIImageView = UIImageView(frame: annotationView!.frame)
            let store:DataStore = DataStore.sharedInstance
            
            
            tipAnnotation.post.traveller.getProfilePictureImage({ (profileImage) -> Void in
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    annotationView!.image = profileImage;
                    annotationView!.clipsToBounds = true
                    annotationView!.contentMode = UIViewContentMode.ScaleAspectFill
                    annotationView!.layer.borderWidth = 2.5
                    annotationView!.layer.borderColor = UIColor.myPeach().CGColor
                    annotationView!.frame = CGRectMake(0, 0, 45, 45)
                    annotationView!.frame = CGRectMake(0, 0, 45, 45)
                    annotationView!.layer.cornerRadius = annotationView!.frame.size.height / 2
                })
            })
 
            annotationView!.clipsToBounds = true
            annotationView!.contentMode = UIViewContentMode.ScaleAspectFill
            annotationView!.layer.borderWidth = 2.5
            annotationView!.layer.borderColor = UIColor.myPeach().CGColor
            annotationView!.frame = CGRectMake(0, 0, 45, 45)
            annotationView!.frame = CGRectMake(0, 0, 45, 45)
            annotationView!.layer.cornerRadius = annotationView!.frame.size.height / 2
            return annotationView
        }else {
            return nil
        }
    }
    
    func selectAnnotationFromSetAtIndex(index:Int) {
        inPostView = true
        let viewingAnnotation:MKAnnotation = annotationSet[index]
        mapOfWorld.selectAnnotation(viewingAnnotation, animated: false)
        inPostView = false
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView annotationView: MKAnnotationView!) {
        
        growAnnotationView(annotationView)
        if let tipAnnotation = annotationView.annotation as? TipAnnotation {
            if (!inPostView){
                println("Selected: \(tipAnnotation.post.content) \n")
                var posts:[Post] = getAllPostsForRegionExcluding(tipAnnotation)
                posts.insert(tipAnnotation.post, atIndex: 0)
                print(posts[0].content)
                delegate?.postTapped(posts)
            }
        }
    }
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
       // println("Deselected: \(tipAnnotation.post.content)")
        //println("Deselected: \((view.annotation as TipAnnotation).post.content) \n")
        shrinkAnnotationView(view)
    }
    
    
    func mapView(mapView: MKMapView!, regionDidChangeAnimated animated: Bool) {
        //println("dsklfjsjfaklj")
    }
    
    func getAllPostsForRegionExcluding (excludeAnnotation:TipAnnotation) -> [Post] {
        annotationSet = []
        annotationSet.append(excludeAnnotation)
        var postsArray:[Post] = []
        let objects = mapOfWorld.annotationsInMapRect(mapOfWorld.visibleMapRect).allObjects
        for var i = 0; i < objects.count; i++ {
            if let tipAnnotation:TipAnnotation = objects[i] as? TipAnnotation {
                if tipAnnotation != excludeAnnotation {
                    annotationSet.append(tipAnnotation)
                    postsArray.append(tipAnnotation.post)
                }
            }
        }
        return postsArray
    }
    
    func deselectCurrentlySelected () {
        
        
        let allAnnotations = mapOfWorld.selectedAnnotations;
        if (allAnnotations != nil) {
            for (var i = 0; i < allAnnotations.count; i = i + 1) {
                let selectedAnnotation:MKAnnotation = allAnnotations[i] as MKAnnotation
                mapOfWorld.deselectAnnotation(selectedAnnotation, animated: false)
            }
        }
    }

    func setUpPostFetcher() {
        postFetcherInsance.delegate = self
        postFetcherInsance.beginFetching()
    }
    
    func setUpLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func transitionToMakePost() {
        moveToCurrentLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let updatedLocation:CLLocation = locations[0] as CLLocation
        currentLocation = updatedLocation.coordinate
    }
    
    func moveToSearchedLocation(searchedLocation:CLPlacemark){
        var radius:Double = (searchedLocation.region as CLCircularRegion).radius / 1000 //Convert to km
        var span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: radius / 112.0, longitudeDelta: radius / 112.0)
        var regionCenter = CLLocationCoordinate2D(latitude: searchedLocation.location.coordinate.latitude, longitude: searchedLocation.location.coordinate.longitude)
        var region:MKCoordinateRegion = MKCoordinateRegion(center: regionCenter, span: span)
        mapOfWorld.setRegion(region, animated: true)
    }
    
    func addPost(fetchedPost: Post)
    {
        let postPoint:TipAnnotation = TipAnnotation(post: fetchedPost)
        //let latitude = fetchedPost.latitude.doubleValue
        //let longitude = fetchedPost.longitude.doubleValue
        //postPoint.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        mapOfWorld.addAnnotation(postPoint)
    }
    
    func moveToCurrentLocation (){
        if ((currentLocation) != nil){
            previousRegion = mapOfWorld!.region
            let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region : MKCoordinateRegion = MKCoordinateRegion(center:currentLocation!, span: span)
            mapOfWorld!.setRegion(region, animated: true)
        }
    }
    
    func moveToPreviousRegion (){
        if (previousRegion != nil) {
            mapOfWorld!.setRegion(previousRegion!, animated: true)
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func shrinkAnnotationView(annotationView: MKAnnotationView) {
        let currentCenter = annotationView.center
        let smallFrame = CGSizeMake(45, 45)
        let reduceCornerRadius:CABasicAnimation = CABasicAnimation(keyPath: "cornerRadius")
        reduceCornerRadius.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        reduceCornerRadius.fromValue = 45.0
        reduceCornerRadius.toValue = 45.0 / 2
        reduceCornerRadius.duration = 0.5
        annotationView.layer.cornerRadius = 45.0 / 2
        annotationView.layer.addAnimation(reduceCornerRadius, forKey: "cornerRadius")
        UIView.animateWithDuration(0.5, animations: {
            annotationView.frame.size = smallFrame
            annotationView.center = currentCenter
            }, completion: {(succes:Bool) in
                
            })
    }
    
    func growAnnotationView(annotationView: MKAnnotationView) {
        let currentCenter = annotationView.center
        let largeFrame = CGSizeMake(90, 90)
        
        
        let increaseCornerRadius:CABasicAnimation = CABasicAnimation(keyPath: "cornerRadius")
        increaseCornerRadius.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        increaseCornerRadius.fromValue = 45 / 2
        increaseCornerRadius.toValue = 45.0
        increaseCornerRadius.duration = 0.5
        annotationView.layer.cornerRadius = 45.0
        annotationView.layer.addAnimation(increaseCornerRadius, forKey: "cornerRadius")
        //self.selectedAnotationView = annotationView


        UIView.animateWithDuration(0.5, animations: {
            annotationView.frame.size = largeFrame
            annotationView.center = currentCenter
            }, completion: {(succes:Bool) in
               
            })
    }
}

protocol mapControllerDelegate {
    func postTapped(postArray:[Post])
}
