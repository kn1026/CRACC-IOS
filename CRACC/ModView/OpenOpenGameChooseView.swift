//
//  OpenOpenGameChooseView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/11/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class OpenOpenGameChooseView: UIView {

    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //layer.cornerRadius = self.frame.height / 26
        //clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft,.topLeft], cornerRadii: CGSize(width: self.frame.height / 1.25, height: self.frame.height / 1.25)).cgPath
        
        
        //Here I'm masking the textView's layer with rectShape layer
        layer.mask = rectShape
        clipsToBounds = true
        
    }
   
}
