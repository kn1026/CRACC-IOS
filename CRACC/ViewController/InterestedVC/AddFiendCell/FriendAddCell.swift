//
//  FriendAddCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/24/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire


class FriendAddCell: UITableViewCell {

    @IBOutlet weak var NameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var avatarImgView: addBorderAndRoundedCornerImgView!
    @IBOutlet weak var addBtn: FrRequestBtn!
    
    
    var info: FriendAddModel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ Information: FriendAddModel) {
        
        
        
       self.info = Information
        
        addBtn.isHidden = false
        
        let FriendListtUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Request")
        
        FriendListtUrl.child(info.FruserUID).observeSingleEvent(of: .value, with: { (snap) in
            
            if snap.exists() {
                
                self.addBtn.setTitle("Accept", for: .normal)
                
            } else {
                
                self.addBtn.setTitle("+Add", for: .normal)
                
            }
            
        })
        
        NameLbl.text = info.Frname
        
        let time = info.FrTimestamp as? TimeInterval
        
        let date = Date(timeIntervalSince1970: time!/1000)
        
        timeLbl.text = "Joined since \(timeAgoSinceDate(date, numericDates: true))"
        
        if info.FrAvatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.FrAvatarUrl).image {
                
                
                
                avatarImgView.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(info.FrAvatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: self.info.FrAvatarUrl)
                        self.avatarImgView.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        }
        
        
    }


}
