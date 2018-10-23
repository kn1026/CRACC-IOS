//
//  ModifiedChooseGameView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/27/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ModifiedChooseGameView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft,.topLeft], cornerRadii: CGSize(width: self.frame.height / 6, height: self.frame.height / 6)).cgPath
        
        
        //Here I'm masking the textView's layer with rectShape layer
        layer.mask = rectShape
        clipsToBounds = true
        
    }

}
