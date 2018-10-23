
//
//  FancyBtn.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/10/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class FancyBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        layer.shadowColor = UIColor(red: Shadow_Gray , green: Shadow_Gray, blue: Shadow_Gray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
        
        
        
    }

}
