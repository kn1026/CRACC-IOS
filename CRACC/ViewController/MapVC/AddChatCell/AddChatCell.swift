//
//  AddChatCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 2/9/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Alamofire
import Cache

class AddChatCell: UITableViewCell {

    @IBOutlet weak var avatarImg: RoundedImgAndBorder!
    @IBOutlet weak var friendName: UILabel!
    @IBOutlet weak var addChatBtn: UIButton!
    
    var info: FriendModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: FriendModel) {
        
        
        
        self.info = Information
        
        
        friendName.text = info.Frname
        
            
  
        if info.FrAvatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.FrAvatarUrl).image {
                
                
                
                avatarImg.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(info.FrAvatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: self.info.FrAvatarUrl)
                        self.avatarImg.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        }
        
        
        
        
    }

    
    
    
}
