//
//  ChooseFriendView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/13/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class ChooseFriendView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 7
        
        clipsToBounds = true
        
    }

}
