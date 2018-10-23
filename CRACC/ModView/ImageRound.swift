//
//  ImageRound.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/2/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ImageRound: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        // add border
        
        
        
        //print(self.frame.height)
        layer.cornerRadius = self.frame.height / 2
        clipsToBounds = true
    }

}
