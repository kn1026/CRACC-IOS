//
//  ModifiedCameraFrontView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/15/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ModifiedCameraFrontView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //layer.cornerRadius = self.frame.height / 26
        //clipsToBounds = true
        
        layer.borderWidth = 3.5
        layer.borderColor = UIColor(red: 0.59, green: 0.34, blue: 0.71, alpha: 1.0).cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 16
        
        clipsToBounds = true
        
    }
}
