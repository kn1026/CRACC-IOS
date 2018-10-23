//
//  ModifiedGameListView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/22/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ModifiedGameListView: UIButton {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: self.frame.height / 37, height: self.frame.height / 37)).cgPath
       
        
        //Here I'm masking the textView's layer with rectShape layer
        layer.mask = rectShape
        
    }

}
