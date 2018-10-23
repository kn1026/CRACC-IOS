//
//  Modified2cornerView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/7/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class Modified2cornerView: UIView {

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
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: self.frame.height / 14, height: self.frame.height / 14)).cgPath
        
        
        //Here I'm masking the textView's layer with rectShape layer
        layer.mask = rectShape
        
    }

}
