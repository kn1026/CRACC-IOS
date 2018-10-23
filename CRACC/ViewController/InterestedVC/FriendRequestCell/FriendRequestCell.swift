//
//  FriendRequestCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/11/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire


class FriendRequestCell: UITableViewCell {

    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var ignoreBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var avatarImg: RoundedImgAndBorder!
    
    
    
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
        
        acceptBtn.isHidden = false
        ignoreBtn.isHidden = false
        
        nameLbl.text = info.Frname
        
        let time = info.FrTimestamp as? TimeInterval
        
        let date = Date(timeIntervalSince1970: time!/1000)
        
        timeLbl.text = timeAgoSinceDate(date, numericDates: true)
        
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
    
    func hideButton() {
        
        acceptBtn.isHidden = true
        ignoreBtn.isHidden = true
      
        
    }
    
    
    
    
    
    
    
    

}
