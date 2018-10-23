//
//  ModiferFriendSearchBar.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/23/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ModiferFriendSearchBar: UISearchBar {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //  let rectShape = CAShapeLayer()
        //rectShape.bounds = frame
        // rectShape.position = center
        // rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: self.frame.height / 14, height: self.frame.height / 14)).cgPath
        
        //Here I'm masking the textView's layer with rectShape layer
        // layer.mask = rectShape
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = frame.height / 2.75
        clipsToBounds = true
        
    }

}
