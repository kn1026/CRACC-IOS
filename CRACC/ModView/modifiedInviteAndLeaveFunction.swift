//
//  modifiedInviteAndLeaveFunction.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/19/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class modifiedInviteAndLeaveFunction: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        //layer.cornerRadius = self.frame.width / 7
        //clipsToBounds = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        layer.cornerRadius = self.frame.width / 14
        clipsToBounds = true
    }

}
