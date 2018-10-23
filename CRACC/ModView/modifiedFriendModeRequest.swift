//
//  modifiedFriendModeRequest.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/23/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class modifiedFriendModeRequest: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //layer.cornerRadius = self.frame.height / 11
        // clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 10
        clipsToBounds = true
        
    }

}
