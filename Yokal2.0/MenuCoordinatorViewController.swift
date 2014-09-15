//
//  MenuViewController.swift
//  scrollViewTest
//
//  Created by Carter Levin on 7/21/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class MenuCoordinatorViewController: UIViewController, menuContainerDelegate, UIScrollViewDelegate {

    //@IBOutlet var scrollContainerView: UIView
    @IBOutlet weak var dropDownScrollView: UIScrollView!
    @IBOutlet weak var dragDownCenterFrame: UIView!
    @IBOutlet weak var leftRightScrollView: UIScrollView!
    
    @IBOutlet weak var leftContainer: UIView!
    @IBOutlet weak var centerContainer: UIView!
    @IBOutlet weak var rightContainer: UIView!
    @IBOutlet weak var bottomContainer: UIView!
    
    var bottomMenuController:BottomMenuViewController?
    let imageHolderMenu:MenuContainer = MenuContainer(frame: CGRectMake(0, 0, 0, 0))
    let imageScroller:UIScrollView = UIScrollView()
    let profileImageView:UIImageView = UIImageView()
    
    var bottomContainerHeight:CGFloat?
    
    var centralParentController:CentralViewController?
    var delegate:MenuCoordinatorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfileImageView()
        setUpDragDownFrames()
        setUpLeftRightFrams()
        setUpVerticleContraints()
        setUpHorrozontalConstraints()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpVerticleContraints () {
        bottomContainerHeight = CGFloat(view.frame.height / 7.1)
        var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
        var metrics: NSMutableDictionary = NSMutableDictionary()
        metrics["contentHeight"] = view.frame.height * 2 - bottomContainerHeight!
        viewBindingsDict.setValue(dragDownCenterFrame, forKey: "dragDownCenterFrame")
        viewBindingsDict.setValue(dropDownScrollView, forKey: "dropDownScrollView")
        viewBindingsDict.setValue(dropDownScrollView, forKey: "dropDownScrollView")
        view.removeConstraints(view.constraints())
        dropDownScrollView.removeConstraints(dropDownScrollView.constraints())
        dragDownCenterFrame.removeConstraints(dragDownCenterFrame.constraints())
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dropDownScrollView]|", options: nil, metrics: nil, views: viewBindingsDict))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[dropDownScrollView]|", options: nil, metrics: nil, views: viewBindingsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[dragDownCenterFrame(==contentHeight)]|", options: nil, metrics: metrics, views: viewBindingsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[dragDownCenterFrame(==dropDownScrollView)]|", options: nil, metrics: nil, views: viewBindingsDict))
    }
    
    
    func setUpHorrozontalConstraints () {
        var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
        var metrics: NSMutableDictionary = NSMutableDictionary()
        metrics["viewHeight"] = view.frame.height - bottomContainerHeight!
        metrics["bottomContainerHeight"] = bottomContainerHeight
        viewBindingsDict.setValue(dragDownCenterFrame, forKey: "dragDownCenterFrame")
        viewBindingsDict.setValue(dropDownScrollView, forKey: "dropDownScrollView")
        viewBindingsDict.setValue(leftRightScrollView, forKey: "leftRightScrollView")
        viewBindingsDict.setValue(leftContainer, forKey: "leftContainer")
        viewBindingsDict.setValue(centerContainer, forKey: "centerContainer")
        viewBindingsDict.setValue(rightContainer, forKey: "rightContainer")
        viewBindingsDict.setValue(bottomContainer, forKey: "bottomContainer")
        
        leftRightScrollView.removeConstraints(leftRightScrollView.constraints())
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[leftRightScrollView(==viewHeight)]", options: nil, metrics: metrics, views: viewBindingsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[leftRightScrollView]|", options: nil, metrics: nil, views: viewBindingsDict))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(viewHeight)-[bottomContainer(==bottomContainerHeight)]", options: nil, metrics:metrics, views: viewBindingsDict))
    
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bottomContainer]|", options: nil, metrics: nil, views: viewBindingsDict))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[leftContainer(==dragDownCenterFrame)][centerContainer(==dragDownCenterFrame)][rightContainer(==dragDownCenterFrame)]|", options: nil, metrics: nil, views:
            viewBindingsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[leftContainer(==leftRightScrollView)]|", options: nil, metrics: nil, views: viewBindingsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[centerContainer(==leftRightScrollView)]|", options: nil, metrics: nil, views: viewBindingsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[rightContainer(==leftRightScrollView)]|", options: nil, metrics: nil, views: viewBindingsDict))
    }
    
    
    func shouldInterceptTouchAtPoint(point: CGPoint, event: UIEvent, view:UIView) -> Bool {
        if (view == imageHolderMenu){
            return CGRectContainsPoint(profileImageView.frame , CGPointMake(point.x + view.frame.width, point.y))
        }else {
            let offsetTop:CGRect = CGRectOffset(leftRightScrollView.frame, -dropDownScrollView!.contentOffset.x, -dropDownScrollView!.contentOffset.y)
            let offsetBottom:CGRect = CGRectOffset(bottomContainer.frame, -dropDownScrollView!.contentOffset.x, -dropDownScrollView!.contentOffset.y)
            return (CGRectContainsPoint(offsetTop , point) || CGRectContainsPoint(offsetBottom , point))
        }
    }
    func setUpDragDownFrames() {
        dropDownScrollView!.delegate = self
        leftRightScrollView!.delegate = self
        dropDownScrollView!.showsHorizontalScrollIndicator = false
        dropDownScrollView!.showsVerticalScrollIndicator = false
        dropDownScrollView!.bounces = false
        dropDownScrollView!.decelerationRate = UIScrollViewDecelerationRateFast
        dragDownCenterFrame!.layer.masksToBounds = false;
        dragDownCenterFrame!.layer.shadowOffset = CGSizeMake(0, 3)
        dragDownCenterFrame!.layer.shadowRadius = 5;
        dragDownCenterFrame!.layer.shadowOpacity = 0.5;
        dropDownScrollView!.contentOffset = CGPointMake(0, view.frame.height - 60)
        dropDownScrollView!.contentSize = CGSizeMake(view.frame.width , view.frame.height * 2 - 60)
    }
    
    func setUpLeftRightFrams() {
        leftRightScrollView!.contentSize = CGSizeMake(view.frame.width * 3, leftRightScrollView!.frame.height)
        leftRightScrollView!.contentOffset = CGPointMake(view.frame.width, 0)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        if (scrollView == dropDownScrollView){
            let offset:CGFloat = CGFloat((dropDownScrollView!.contentOffset.y as NSNumber))
            let imageRescale:CGFloat = (view.frame.height  - offset) / (view.frame.height - 70)
            profileImageView.frame.size = CGSizeMake(50 + 30 * imageRescale, 50 + 30 * imageRescale)
            profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
            delegate?.moveSearchBarWithOffset(offset)
            
            // move left right scroller closer to center location
            let displacement:CGFloat = view.frame.width - leftRightScrollView.contentOffset.x
            if (offset > 70 && leftRightScrollView!.contentOffset.x != view.frame.width){
                UIView.animateWithDuration(0.3, animations: {
                     self.leftRightScrollView!.contentOffset = CGPointMake(self.view.frame.width, 0 )
                    })
            }
        }
        if (scrollView == leftRightScrollView){
            imageScroller.contentOffset = scrollView.contentOffset
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if let bottomMenu:BottomMenuViewController = segue.destinationViewController as? BottomMenuViewController {
            bottomMenuController = bottomMenu
            bottomMenuController!.delegate = centralParentController
        }
    }
    
    func setUpProfileImageView () {
        imageScroller.frame = CGRectMake(0, 0, view.frame.width , bottomContainer.frame.height * 2)
        imageHolderMenu.frame = imageScroller.frame
        imageHolderMenu.delegate = self
        imageScroller.layer.backgroundColor = UIColor.clearColor().CGColor
        imageScroller.contentSize = CGSizeMake(view.frame.width * 3, view.frame.height)
        profileImageView.frame = CGRectMake(view.frame.width + 5, 20, imageScroller.frame.height - 30, imageScroller.frame.height - 30)
        profileImageView.layer.borderWidth = 1.5
        profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        
        
        imageScroller.scrollEnabled = false
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2.0
        profileImageView.layer.backgroundColor = UIColor.greenColor().CGColor
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = UIViewContentMode.ScaleAspectFill
        profileImageView.image = UIImage(named: "defaultImage.jpg")
        view.addSubview(imageHolderMenu)
        imageHolderMenu.addSubview(imageScroller)
        imageScroller.addSubview(profileImageView)
        imageScroller.contentOffset = CGPoint(x: view.frame.width, y: 0)
        let profileImageTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "profileImageTapped")
        imageHolderMenu.addGestureRecognizer(profileImageTap)
    }
    func profileImageTapped () {
        bottomMenuController?.profileImageTapped()
    }
}



protocol MenuCoordinatorDelegate {
    func moveSearchBarWithOffset(offset:CGFloat)
}

