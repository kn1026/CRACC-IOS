//
//  modifiedCancelAndSaveBtn.swift
//  CRACC
//
//  Created by Khoi Nguyen on 2/22/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class modifiedCancelAndSaveBtn: UIButton {

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //layer.cornerRadius = self.frame.width / 7
        //clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = self.frame.width / 16
        clipsToBounds = true

}

}
