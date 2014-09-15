//
//  PostCollectionViewCell.swift
//  Yokal2.0
//
//  Created by Carter Levin on 8/15/14.
//  Copyright (c) 2014 Carter Levin. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    var delegate:postCellDelegate?
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var postContent: UITextView!
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func starButton(sender: AnyObject) {
        delegate!.starTapped()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let xibView:UIView = NSBundle.mainBundle().loadNibNamed("PostCollectionViewCell", owner: self, options: nil)[0] as UIView
        profileImage.layer.cornerRadius = profileImage.frame.height / 2
        profileImage.clipsToBounds = true
        profileImage.contentMode = UIViewContentMode.ScaleAspectFill
        xibView.frame.size = frame.size
        xibView.backgroundColor = UIColor.myDarkBlue()
        
        addSubview(xibView)
    }
}

protocol postCellDelegate {
    func starTapped()
}
