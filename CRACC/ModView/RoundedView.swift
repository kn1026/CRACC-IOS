//
//  RoundedView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/1/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation
import UIKit

class RoundedView: UIView {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //layer.cornerRadius = self.frame.height / 2
        //clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
        
    }
    
    
}
