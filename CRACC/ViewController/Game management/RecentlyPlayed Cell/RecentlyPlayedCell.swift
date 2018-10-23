//
//  RecentlyPlayedCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/24/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire


class RecentlyPlayedCell: UITableViewCell {

    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timePlayedLbl: UILabel!
    @IBOutlet weak var avatarLbl: RoundedImgAndBorder!
    
    
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
        
        
        nameLbl.text = info.Joinedname
        
        let time = info.JoinedTimestamp as? TimeInterval
        let date = Date(timeIntervalSince1970: time!/1000)
        
        timePlayedLbl.text = "Played " + timeAgoSinceDate(date, numericDates: true)
        
        if info.JoinedAvatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.JoinedAvatarUrl).image {
                
                
                
               avatarLbl.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(info.JoinedAvatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: self.info.JoinedAvatarUrl)
                        self.avatarLbl.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        } else {
            
            
            
            self.avatarLbl.image = UIImage(named: "CRACC")
        }
        
        let FriendUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List").child(info.JoineduserUID)
        let RequestUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Request").child(info.JoineduserUID)
        
        FriendUrl.observeSingleEvent(of: .value, with: { (snapRecent) in
            
            if snapRecent.exists() {
                
                self.addBtn.isHidden = true
                
                
                
                
            } else {
                
                RequestUrl.observeSingleEvent(of: .value, with: { (RequestRecent) in
                    
                    if RequestRecent.exists() {
                        
                        self.addBtn.isHidden = true
                        
                        
                        
                        
                    } else {
                        
                        self.addBtn.isHidden = false
                        
                        
                    }
                    
                    
                })
                
                
            }
            
            
        })
        
        
    }
    

}
