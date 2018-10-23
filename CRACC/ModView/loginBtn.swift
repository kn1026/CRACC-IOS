//
//  loginBtn.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/7/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class loginBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
       // layer.cornerRadius = self.frame.width / 20
       // clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = self.frame.width / 20
        clipsToBounds = true
    }

}
