//
//  modifiedSearchBarAddChat.swift
//  CRACC
//
//  Created by Khoi Nguyen on 2/8/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation


class modifiedSearchBarAddChat: UISearchBar {
    
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
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
        
    }
    
}
