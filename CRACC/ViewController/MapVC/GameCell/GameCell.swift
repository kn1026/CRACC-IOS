//
//  GameCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/27/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {
    
    
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var gameName: UILabel!
    
    
    
    
    
    func configureCell(image: UIImage, gameText: String) {
    
    
        imageView.image = image
        gameName.text = gameText
    
    
    
    }
    
    
    
    
    
    
    
    
}
