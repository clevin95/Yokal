//
//  ProfileView.swift
//  Yokal2.0
//
//  Created by Carter Levin on 8/8/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    @IBOutlet weak var piChart: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var townLabel: UILabel!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let xibView:UIView = NSBundle.mainBundle().loadNibNamed("ProfileView", owner: self, options: nil)[0] as UIView
        addSubview(xibView)
        setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let xibView:UIView = NSBundle.mainBundle().loadNibNamed("ProfileView", owner: self, options: nil)[0] as UIView
        xibView.frame = self.frame
        addSubview(xibView)
        
        setUpView()
    }
    
    
    func setUpView () {
        piChart.layer.cornerRadius = piChart.frame.height / 2
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
