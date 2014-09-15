//
//  SearchViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 7/23/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit
import CoreLocation

//I created all views programatically for this controller

class SearchViewController: UIViewController, menuContainerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    var searchBar: UISearchBar?
    var scrollView: UIScrollView?
    var resultsTable: UITableView?
    var isSearching: Bool = false
    var searchResults: NSArray = []
    
    var delegate:SearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAllViews()
    }
    
    func createAllViews () {
        let searchViewStartPoint: CGFloat = view.frame.height
        let searchBarHeight: CGFloat = 40
        
        searchBar = UISearchBar(frame: CGRectMake(0, searchViewStartPoint, view.frame.width, searchBarHeight))
        searchBar!.delegate = self
        searchBar!.searchBarStyle = UISearchBarStyle.Minimal
        
        scrollView = UIScrollView(frame: view.frame)
        scrollView!.contentSize = CGSizeMake(view.frame.width, view.frame.height * 2)
        scrollView!.contentOffset = CGPointMake(0, searchBarHeight)
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(searchBar!)
        scrollView!.scrollEnabled = false
        
        //Set up UITableView resultsTable
        resultsTable = UITableView(frame: CGRectMake(0, searchBar!.frame.origin.y + searchBarHeight + 20, view.frame.width, view.frame.height - searchBarHeight))
        resultsTable!.alpha = 0.7
        resultsTable!.backgroundColor = UIColor.myPeach()
        scrollView!.addSubview(resultsTable!)
        resultsTable!.delegate = self
        resultsTable!.dataSource = self
        resultsTable!.separatorStyle = UITableViewCellSeparatorStyle.None
        
        var blur1:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let animatedEffectView:UIVisualEffectView = UIVisualEffectView(effect: blur1)
        animatedEffectView.frame = resultsTable!.frame
        animatedEffectView.alpha = 0.7;
        scrollView!.insertSubview(animatedEffectView, atIndex: 0)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar!) -> Bool {
        delegate!.beginSearching()
        isSearching = true
        var yOffset : CGFloat = view.frame.height
        var topLayoutGuid: CGFloat = 20
        searchBar!.setShowsCancelButton(true, animated: true)
        animateTransitionToOffset(yOffset - topLayoutGuid)
        return true
    }
    
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar!)  {
        finishSearchingAnimation()
    }
    
    func animateTransitionToOffset (offset:CGFloat) {
        UIView.animateWithDuration(0.2, animations: {
            self.scrollView!.contentOffset = CGPointMake(0, offset)
            })
    }
    
    func finishSearchingAnimation() {
        isSearching = false
        searchBar!.resignFirstResponder()
        searchBar!.setShowsCancelButton(false, animated: true)
        animateTransitionToOffset(self.searchBar!.frame.height)
        delegate!.endSearching()
    }
    
    func shouldInterceptTouchAtPoint(point: CGPoint, event: UIEvent, view:UIView) -> Bool {
        if (isSearching){
            return true
        }
        else {
            let frame:CGRect = CGRectMake(0, searchBar!.frame.origin.y - scrollView!.contentOffset.y, searchBar!.frame.width, searchBar!.frame.height)
            CGRectContainsPoint(searchBar!.frame, point)
            return CGRectContainsPoint(frame, point)
        }
    }
    
    func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
        SearchResultsFinder.getAllAddressesForString(searchText, arrayPassback: {(passBack:NSArray) in
            self.searchResults = passBack
            NSOperationQueue.mainQueue().addOperationWithBlock({
                self.resultsTable!.reloadData()
                })
            })
    }
    
    func moveWithMenuOffset (menuOffset:CGFloat) {
        if menuOffset > 0 {
            scrollView!.contentOffset.y = menuOffset / view.frame.height * 40 + 3
        }
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        
        makeSearchFromText(searchBar.text)
    }
    
    func makeSearchFromText(text:String) {
        
        var geocoder:CLGeocoder = CLGeocoder()
        self.finishSearchingAnimation()
        geocoder.geocodeAddressString(text, completionHandler: {(placemarks:[AnyObject]?, error:NSError!) in
            if (placemarks != nil){
                let searchPlacemark: CLPlacemark = placemarks![0] as CLPlacemark
                let centralParentController: CentralViewController = self.parentViewController as CentralViewController
                centralParentController.moveToSearchedLocation(searchPlacemark)
            }
            })
    }

    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let searchText:String = searchResults[indexPath.row] as String
        makeSearchFromText(searchText)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var addressCell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("addressCell") as? UITableViewCell
        if (addressCell == nil){
            addressCell = UITableViewCell(style: UITableViewCellStyle.Default , reuseIdentifier: "addressCell")
        }
        addressCell!.layer.backgroundColor = UIColor.clearColor().CGColor
        addressCell!.textLabel!.text = searchResults[indexPath.row] as? String
        return addressCell!
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // #pragma mark - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

protocol SearchDelegate{
    func beginSearching()
    func endSearching()
}
