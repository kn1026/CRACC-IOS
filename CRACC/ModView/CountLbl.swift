//
//  CountLbl.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/5/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class CountLbl: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        layer.cornerRadius = self.frame.width / 2
        layer.masksToBounds = true
        
        
    }

}
