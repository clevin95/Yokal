//
//  MenuContainer.swift
//  scrollViewTest
//
//  Created by Carter Levin on 7/20/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class MenuContainer: UIView {

    var delegate : menuContainerDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Initialization code
    }
required     
    init(coder aDecoder: (NSCoder!))
    {
        super.init(coder: aDecoder)
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent!) -> Bool
    {
        if (delegate != nil){
            return delegate!.shouldInterceptTouchAtPoint(point, event: event, view: self)
        }
        return true
    }
    

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */
}

protocol menuContainerDelegate {
    func shouldInterceptTouchAtPoint(point : CGPoint, event : UIEvent, view:UIView) -> Bool
}
