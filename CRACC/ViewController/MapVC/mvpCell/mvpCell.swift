//
//  mvpCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/13/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire

class mvpCell: UITableViewCell {
    
    
    @IBOutlet weak var avatarImg: RoundedImgAndBorder!
    
    @IBOutlet weak var name: UILabel!
    
    var info: RecentlyPlayedModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: RecentlyPlayedModel) {
        
        self.info = Information
        
        name.text = info.Joinedname
        
        
        if info.JoinedAvatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.JoinedAvatarUrl).image {
                
                
                
                avatarImg.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(info.JoinedAvatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: self.info.JoinedAvatarUrl)
                        self.avatarImg.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        } else {
            
            
            
            self.avatarImg.image = UIImage(named: "CRACC")
        }
        
       
        
        
        
        
    }

}
