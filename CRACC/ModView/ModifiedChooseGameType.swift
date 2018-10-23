//
//  ModifiedChooseGameType.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/30/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ModifiedChooseGameType: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //layer.cornerRadius = self.frame.height / 26
        //clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 9
        clipsToBounds = true
        
    }
    

}
