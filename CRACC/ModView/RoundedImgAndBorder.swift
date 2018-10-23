//
//  RoundedImgAndBorder.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/12/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class RoundedImgAndBorder: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // add border
        layer.borderWidth = 3.0
        layer.borderColor = UIColor(red: 0, green: 0.98, blue: 0.99, alpha: 1.0).cgColor
        
        
        //print(self.frame.height)
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }

}
