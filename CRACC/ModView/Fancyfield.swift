//
//  Fancyfield.swift
//  
//
//  Created by Khoi Nguyen on 8/24/16.
//  Copyright © 2016 Khoi Nguyen. All rights reserved.
//

import UIKit

class Fancyfield: UITextField {

   
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.borderColor = UIColor(red: Shadow_Gray, green: Shadow_Gray, blue: Shadow_Gray, alpha: 0.2).cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 2.0
        
        
        
    }
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    
}
