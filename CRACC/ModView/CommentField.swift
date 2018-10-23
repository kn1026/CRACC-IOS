//
//  CommentField.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/12/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class CommentField: UITextView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.width / 17
        
        
        
    }


}
