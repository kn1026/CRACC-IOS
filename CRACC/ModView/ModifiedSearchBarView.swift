//
//  ModifiedSearchBarView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/28/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ModifiedSearchBarView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: Shadow_Gray , green: Shadow_Gray, blue: Shadow_Gray, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 6
        
        clipsToBounds = true
        
    }
    
    
    
}
