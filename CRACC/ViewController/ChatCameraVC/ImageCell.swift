//
//  ImageCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/10/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Photos

class ImageCell: UICollectionViewCell {
    
    
    let imgManager = PHImageManager.default()
    
    var reqOptions: PHImageRequestOptions? {
        didSet {
            if let _reqOptions = reqOptions {
                _reqOptions.isSynchronous = true
            }
        }
    }
    
    @IBOutlet weak var image: UIImageView!
    var selectedImg: UIImage!
    
    
    
    func populateDataWith(asset:PHAsset) {
      
        let width = 300 //self.frame.size.width
        let height = 300 //self.frame.size.height
        
        let thumbnailSize: CGSize = CGSize(width: width, height: height)
        imgManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: reqOptions, resultHandler: { (image, info) in
            self.image.image = image
            self.selectedImg = image
        })
        
        
        
        
        
        
        
    }
    
    
    
    
}
