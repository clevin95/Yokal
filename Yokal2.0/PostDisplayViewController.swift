//
//  PostDisplayViewController.swift
//  Yokal2.0
//
//  Created by Carter Levin on 8/3/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//


import UIKit
let reuseIdentifier:String = "postCell"
class PostDisplayViewController: UIViewController, menuContainerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, postCellDelegate {

    let upDownScroller = UIScrollView()
    var delegate:postDisplayDelegate?
    let userInfoBar:UIView = UIView()
    let nameLabel:UILabel = UILabel()
    var postsCollection:UICollectionView?
    var postsArray:[Post]?
    let store:DataStore = DataStore.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScrollers()
        //setUpSubviews()
        // Do any additional setup after loading the view.
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (postsArray != nil){
            return postsArray!.count
        }
        return 0
    }
    

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var postCell:PostCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PostCollectionViewCell
        postCell.backgroundColor = UIColor.myDarkBlue()
        let postToShow:Post = postsArray![indexPath.row]
        postCell.frame.origin.y = upDownScroller.frame.origin.y + 10
        postCell.delegate = self
        postCell.profileImage.image = store.profileImageDic[postToShow.traveller.uniqueID!]
        postCell.postContent.text = postToShow.content
        postCell.nameLabel.text = postToShow.traveller.name
        postCell.layer.shadowColor = UIColor.blackColor().CGColor
        postCell.layer.shadowOpacity = 0.8
        postCell.layer.shadowOffset = CGSize(width: 3, height: 0)
        postCell.layer.masksToBounds = false
        
        return postCell
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject!) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return UICollectionReusableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView!, willDisplayCell cell: UICollectionViewCell!, forItemAtIndexPath indexPath: NSIndexPath!) {
        //(parentViewController as CentralViewController).viewingPostAtIndex(indexPath.row)
    }
    
    func setUpScrollers () {
        setUpUpDownScroller()
        setUpCollectionView()
    }
    
    func setUpUpDownScroller (){
        upDownScroller.delegate = self
        upDownScroller.clipsToBounds = false
        upDownScroller.frame  = CGRectMake(0, 0, view.frame.width, view.frame.width)
        upDownScroller.contentSize = CGSize(width: upDownScroller.frame.width, height: upDownScroller.frame.height * 2)
        upDownScroller.layer.backgroundColor = UIColor.clearColor().CGColor
        upDownScroller.showsVerticalScrollIndicator = false
        upDownScroller.pagingEnabled = true
        upDownScroller.bounces = false
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        if scrollView == postsCollection {
            let index:Int = Int(scrollView.contentOffset.x / view.frame.width)
            (parentViewController as CentralViewController).viewingPostAtIndex(index)
            print (scrollView.contentOffset.x / view.frame.width)
        }
    }
    
    func setUpCollectionView () {
        let postFlow:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        postFlow.itemSize = upDownScroller.frame.size
        postFlow.scrollDirection = UICollectionViewScrollDirection.Horizontal
        postFlow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        postFlow.minimumInteritemSpacing = 0
        postFlow.minimumLineSpacing = 0
        let postCollectionFrame:CGRect = CGRectOffset(upDownScroller.frame, 0, upDownScroller.frame.height)
        postsCollection = UICollectionView(frame: postCollectionFrame, collectionViewLayout: postFlow)
        postsCollection!.delegate = self
        postsCollection!.dataSource = self
        postsCollection!.frame = CGRectOffset(upDownScroller.frame, 0, upDownScroller.frame.height)
        postsCollection!.registerClass(PostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        postsCollection!.backgroundColor = UIColor.clearColor()
        postsCollection!.pagingEnabled = true
        postsCollection!.bounces = false
        upDownScroller.addSubview(postsCollection!)
        view.addSubview(upDownScroller)
    }
    
    func starTapped() {
        println("star tapped")
    }
    
    func shouldInterceptTouchAtPoint(point: CGPoint, event: UIEvent, view: UIView) -> Bool {
        let pointWithDisplacement = CGPoint(x: point.x, y: point.y + upDownScroller.contentOffset.y)
        return CGRectContainsPoint(postsCollection!.frame, pointWithDisplacement)
    }
    
    func displayPost(passedPosts:[Post]) {
        postsArray = passedPosts
        postsCollection!.reloadData()
        UIView.animateWithDuration(0.5, animations: {
            self.upDownScroller.contentOffset = CGPoint(x: 0, y: self.upDownScroller.frame.height)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        if scrollView === upDownScroller{
            if (scrollView.contentOffset.y < 40) {
                delegate!.finishedViewingPost()
                postsCollection!.contentOffset.x = 0
            }
        }
    }
}




protocol postDisplayDelegate {
    func finishedViewingPost ()
    func viewingPostAtIndex (index:Int)
}
