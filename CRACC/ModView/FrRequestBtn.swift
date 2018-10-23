//
//  FrRequestBtn.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/11/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class FrRequestBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //layer.cornerRadius = self.frame.width / 7
        //clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = self.frame.width / 15
        clipsToBounds = true
        
        
    }
    

}
