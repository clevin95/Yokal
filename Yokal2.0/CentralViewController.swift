//
//  CentralViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/20/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class CentralViewController: UIViewController, makePostDelegate, BottomMenuDelegate, LeftMenuDelegate, RightMenuDelegate, MiddleMenuDelegate, MenuCoordinatorDelegate, SearchDelegate, mapControllerDelegate, postDisplayDelegate, UIViewControllerTransitioningDelegate {
    @IBOutlet var makePostContainer: UIView?
    @IBOutlet var menuContainer: MenuContainer?
    @IBOutlet var searchContainer: MenuContainer?
    @IBOutlet weak var postDisplayContainer: MenuContainer!
    @IBOutlet weak var mapViewContainer: UIView!
    var makePostChildController:MakePostViewController?
    var mapChildController:MapViewController?
    var searchController:SearchViewController?
    var bottomMenuChildController:BottomMenuViewController?
    var postDisplayController:PostDisplayViewController?
    var mapController:MapViewController?
    var menuCoordinatorController:MenuCoordinatorViewController?
    var searchContainerIsDismissed:Bool = false
    var isLogedIn:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChildControllerDelegates()
    }
    
    override func viewDidAppear(animated: Bool) {
        displayLogInView()
    }
    
    func displayLogInView () {
        if (!isLogedIn){
            let loginController:CentralLoginViewController = self.storyboard!.instantiateViewControllerWithIdentifier("centralLogin") as CentralLoginViewController
            loginController.transitioningDelegate = self.transitioningDelegate;
            loginController.modalPresentationStyle = UIModalPresentationStyle.Custom
            self.presentViewController(loginController, animated: true, completion: {
                self.isLogedIn = true
            })
        }
    }

    func setChildControllerDelegates (){
        for childController in childViewControllers {
            if let menuCoordinator:MenuCoordinatorViewController = childController as? MenuCoordinatorViewController{
                menuCoordinator.delegate = self
                menuCoordinatorController = menuCoordinator
            }else if let searchController:SearchViewController = childController as? SearchViewController{
                searchController.delegate = self
            }else if let makePostController:MakePostViewController = childController as? MakePostViewController{
                makePostController.delegate = self
                makePostChildController = makePostController
            }else if let tempPostDysplayController:PostDisplayViewController = childController as? PostDisplayViewController{
                postDisplayController = tempPostDysplayController
                postDisplayController!.delegate = self
                postDisplayContainer.delegate = postDisplayController
                postDisplayContainer.clipsToBounds = false
            }else if let tempMapController:MapViewController = childController as? MapViewController{
                
                mapController = tempMapController
                tempMapController.delegate = self
            }
            let childViewController = childController as UIViewController
            for grandChild in childViewController.childViewControllers {
                if let leftMenu:LeftMenuViewController = grandChild as? LeftMenuViewController{
                    leftMenu.delegate = self
                }else if let bottomMenu:BottomMenuViewController = grandChild as? BottomMenuViewController{
                    bottomMenu.delegate = self
                    bottomMenuChildController = bottomMenu
                }else if let middleController:MiddleMenuViewController = grandChild as? MiddleMenuViewController{
                    middleController.delegate = self
                }else if let rightController:RightMenuViewController = grandChild as? RightMenuViewController{
                    rightController.delegate = self
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if let centralLoginController:CentralLoginViewController = segue.destinationViewController as? CentralLoginViewController{
        }
        if let makePostViewController:MakePostViewController = segue.destinationViewController as? MakePostViewController
        {
            //makePostChildController = makePostViewController
            //makePostChildController!.delegate = self
        }else if let menuCoordinatorController:MenuCoordinatorViewController = segue.destinationViewController as? MenuCoordinatorViewController
        {
            menuContainer!.delegate = menuCoordinatorController
        }else if let searchViewController:SearchViewController = segue.destinationViewController as? SearchViewController
        {
            searchContainer!.delegate = searchViewController
            searchController = searchViewController
        }else if let mapViewController:MapViewController = segue.destinationViewController as? MapViewController
        {
            mapChildController = mapViewController
        }
    }
    
    func moveSearchBarWithOffset(offset:CGFloat){
        searchController?.moveWithMenuOffset(offset)
    }
    
    //methods for coordinatorPanelDelegate
    func makePost() {
        dismissDropDownMenu()
        makePostChildController!.postLocation = mapChildController!.currentLocation
        mapChildController!.transitionToMakePost()
        fadeOutView(menuContainer!)
        fadeInView(makePostContainer!)
    }
    
    
    
    //Move to searched location, called from SearchViewController
    func moveToSearchedLocation(searchedLocation:CLPlacemark){
        mapChildController!.moveToSearchedLocation(searchedLocation)
    }
    
    func fadeInView(viewToFadeIn : UIView){
        viewToFadeIn.alpha = 0;
        viewToFadeIn.hidden = false
        UIView.animateWithDuration(0.5, animations: {
            viewToFadeIn.alpha = 1;
            })
    }
    
    func fadeOutView(viewToFadeOut : UIView){
        UIView.animateWithDuration(0.5, animations: {
            viewToFadeOut.alpha = 0
            })
    }
    
    func finishedPosting() {
        reenterMenu()
        mapChildController!.moveToPreviousRegion()
        fadeOutView(makePostContainer!)
        fadeInView(menuContainer!)
    }
    
    func beginSearching() {
        bottomMenuChildController!.beginSearchingAnimation()
    }
    
    func endSearching() {
        bottomMenuChildController!.endSearchingAnimation()
    }
    
    func postTapped(postArray: [Post])  {
        
        searchContainer!.hidden = true
        postDisplayController!.displayPost(postArray)
    }
    
    func finishedViewingPost()  {
        searchContainer!.hidden = false
        mapController!.deselectCurrentlySelected()
    }
    
    func viewingPostAtIndex(index: Int) {
        mapController!.inPostView = true
        mapController!.selectAnnotationFromSetAtIndex(index)
        mapController!.inPostView = false
    }
    
    func dismissDropDownMenu () {
        UIView.animateWithDuration(0.5, animations: {
            self.menuContainer!.frame.origin.y = -50
        })
    }
    func reenterMenu (){
        UIView.animateWithDuration(0.5, animations: {
            self.menuContainer!.frame.origin.y = 0
        })
    }
}

