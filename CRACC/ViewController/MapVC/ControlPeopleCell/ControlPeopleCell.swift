//
//  ControlPeopleCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 2/19/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire
import MGSwipeTableCell

class ControlPeopleCell: MGSwipeTableCell {

    @IBOutlet weak var avatarImg: RoundedImgAndBorder!
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var timeLbl: UILabel!
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
        
        
        let time = info.JoinedTimestamp as? TimeInterval
        let date = Date(timeIntervalSince1970: time!/1000)
        
        timeLbl.text = "Joined " + timeAgoSinceDate(date, numericDates: true)
        
        
        nameLbl.text = info.Joinedname

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
