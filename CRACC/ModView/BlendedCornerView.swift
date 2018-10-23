//
//  BlendedCornerView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/2/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class BlendedCornerView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //layer.cornerRadius = self.frame.height / 11
       // clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 27
        clipsToBounds = true
        
    }
}
