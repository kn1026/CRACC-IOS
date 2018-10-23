//
//  ModifiedBtnCorner.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/9/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ModifiedBtnCorner: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //layer.cornerRadius = self.frame.width / 7
        //clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = self.frame.width / 7
        clipsToBounds = true
    }

}

@IBDesignable extension UIButton {
    
    
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}
