//
//  ModifyCornerForAddChatView.swift
//  CRACC
//
//  Created by Khoi Nguyen on 2/8/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class ModifyCornerForAddChatView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        //layer.cornerRadius = self.frame.height / 26
        //clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.height / 20
        clipsToBounds = true
        
    }

}
