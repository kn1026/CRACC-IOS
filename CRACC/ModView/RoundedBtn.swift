//
//  RoundedBtn.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/7/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class RoundedBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //layer.cornerRadius = self.frame.width / 30
        //clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = self.frame.width / 30
        clipsToBounds = true
    }

}


