//
//  ChooseGameTypeCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/30/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
// ChooseGameTypeCell

import UIKit

class ChooseGameTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var labelGameType: UILabel!
    @IBOutlet weak var imageGameType: UIImageView!
    
    
    
    
    
    func configureCell(image: UIImage, gameText: String) {
        
        
        imageGameType.image = image
        labelGameType.text = gameText
        
        
        
    }
    
    
    
}
