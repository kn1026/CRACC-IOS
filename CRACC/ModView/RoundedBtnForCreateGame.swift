//
//  RoundedBtnForCreateGame.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/13/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class RoundedBtnForCreateGame: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true

    }
    
    

}
