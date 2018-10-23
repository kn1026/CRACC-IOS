//
//  RoundBtn.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/1/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation
import UIKit


class RoundBtn: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView?.contentMode = .scaleAspectFit
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
    
}



