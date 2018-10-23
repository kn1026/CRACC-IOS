//
//  commentCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/16/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire

class commentCell: UITableViewCell {

    @IBOutlet weak var avatarImgView: ImageRound!
    @IBOutlet weak var cmtLbl: UILabel!
    
    var info: CommentModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: CommentModel) {
        
        self.info = Information
        
        
        cmtLbl.text = info.CmtText

        
        if info.CmtAvatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.CmtAvatarUrl).image {
                
                
                
                avatarImgView.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(info.CmtAvatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: self.info.CmtAvatarUrl)
                        self.avatarImgView.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        } else {
            
            
            
            self.avatarImgView.image = UIImage(named: "CRACC")
        }
        
        
        
        
        
        
    }

}
