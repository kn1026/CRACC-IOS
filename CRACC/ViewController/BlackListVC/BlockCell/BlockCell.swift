//
//  BlockCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/5/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase
import Cache
import Alamofire

class BlockCell: UITableViewCell {

    @IBOutlet weak var UnblockBtn: UIButton!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var avatarImg: RoundedImgAndBorder!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    
    var info: blockModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func configureCell(_ Information: blockModel) {
        
        let defaulImg = UIImage(named: "CRACC")
        self.info = Information
        
        
        nameLbl.text = info.BlockName
        let time = info.BlockTime as? TimeInterval
        
        let date = Date(timeIntervalSince1970: time!/1000)
        
        timeLbl.text = "Blocked \(timeAgoSinceDate(date, numericDates: true))"
        
        
        DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).observeSingleEvent(of: .value, with: { (snapInfo) in
            
            
            if snapInfo.exists() {
                
                if let snap = snapInfo.value as? Dictionary<String, Any> {
                    
                    if let avatarUrl = snap["avatarUrl"] as? String {
                        
                        
                        
                        
                        if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: avatarUrl).image {
                            
                            
                            
                            self.avatarImg.image = ownerImageCached
                            
                            
                        } else {
                            
                            
                            Alamofire.request(avatarUrl).responseImage { response in
                                
                                if let image = response.result.value {
                                    
                                    let wrapper = ImageWrapper(image: image)
                                    try? InformationStorage?.setObject(wrapper, forKey: avatarUrl)
                                    self.avatarImg.image = image
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
                        }
                        
                    } else {
                        
                        self.avatarImg.image = defaulImg
                        
                    }
                    
                }
                
            } else {
                
                self.avatarImg.image = defaulImg
                
                
            }
            
            
            
            
        })
        
        
    }
    
    
    

}
