//
//  addBorderAndRoundedCornerImgView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/7/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class addBorderAndRoundedCornerImgView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // add border
        
        
        
        //print(self.frame.height)
        
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
        layer.borderWidth = 5
        layer.borderColor = UIColor(red: 0, green: 0.98, blue: 0.99, alpha: 1.0).cgColor
        
        
    }

}
