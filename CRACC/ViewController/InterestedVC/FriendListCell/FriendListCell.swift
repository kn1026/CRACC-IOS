//
//  FriendListCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/11/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire
import MGSwipeTableCell


class FriendListCell: MGSwipeTableCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var MessStatusLbl: UILabel!
    @IBOutlet weak var avatarUrl: RoundedImgAndBorder!
    
    
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
        
        var typed = ""
        nameLbl.text = info.Frname

        DataService.instance.mainDataBaseRef.child("User").child(info.FrType).child(info.FruserUID).child("CurrentActivity").observeSingleEvent(of: .value, with: { (RequestRecent) in
            
            if RequestRecent.exists() {
                
                if let postDict = RequestRecent.value as? Dictionary<String, Any> {
                    
                    print(postDict)
                    
                    if let gameType = postDict["gameType"] as? String {
                        
                        if let type = postDict["Type"] as? String {
                            
                            if type == "Joined" {
                                
                                typed = "joined"
                                
                            } else {
                                
                                typed = "created"
                                
                            }
                            
                            
                            
                            if let times = postDict["Timestamp"] {
                                
                                let time = times as? TimeInterval
                                let date = Date(timeIntervalSince1970: time!/1000)
                                
                                let result = timeAgoSinceDate(date, numericDates: true)
                                
                                
                                
                                self.MessStatusLbl.text = "\(self.info.Frname!) just \(typed) a \(gameType.lowercased()) game \(result)"
                                
                                
                            }
                            
                        }
                        
                        
                    } else {
                        
                        if let times = postDict["Timestamp"] {
                            
                            let time = times as? TimeInterval
                            let date = Date(timeIntervalSince1970: time!/1000)
                            
                            let result = timeAgoSinceDate(date, numericDates: true)
                            
                            
                            self.MessStatusLbl.text = "\(self.info.Frname!) just joined CRACC \(result)"
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
            } else {
                
                self.MessStatusLbl.text = ""
                
                
            }
            
            
        })
        
        if info.FrAvatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.FrAvatarUrl).image {
                
                
                
                avatarUrl.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(info.FrAvatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: self.info.FrAvatarUrl)
                        self.avatarUrl.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        }
        
        
    }
    
    

}
