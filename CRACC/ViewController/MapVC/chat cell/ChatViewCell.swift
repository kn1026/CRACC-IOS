//
//  ChatViewCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/3/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire
import MGSwipeTableCell

class ChatViewCell: MGSwipeTableCell {
    
    
    var info: chatModel!

    @IBOutlet weak var TypeGameImg: RoundedImgAndBorder!
    @IBOutlet weak var dateGamePlayLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var numberOfPeopleLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(_ Information: chatModel) {
        
        self.info = Information
        
        if info.isGroup == 0 {
            
            numberOfPeopleLbl.text = ""
            
            nameLbl.text = info.Frname
            
            let time = info.FrTimestamp as? TimeInterval
            
            let date = Date(timeIntervalSince1970: time!/1000)
            
            dateGamePlayLbl.text = timeAgoSinceDate(date, numericDates: true)

            
           
            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("NewPsMess").child(info.FruserUID).observeSingleEvent(of: .value, with: { (snap) in
                
                if let value = snap.value as? Int, value == 1 {
                    
                    self.nameLbl.textColor = UIColor.black
                    self.dateGamePlayLbl.textColor = UIColor.black
                    
                } else {
                    
                    self.nameLbl.textColor = UIColor.darkGray
                    self.dateGamePlayLbl.textColor = UIColor.lightGray
                    
                }
                
                
                
                
                
            })
            
            
            if info.FrAvatarUrl != "nil" {
                
                if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.FrAvatarUrl).image {
                    
                    
                    
                    TypeGameImg.image = ownerImageCached
                    
                    
                } else {
                    
                    
                    Alamofire.request(info.FrAvatarUrl!).responseImage { response in
                        
                        if let image = response.result.value {
                            
                            let wrapper = ImageWrapper(image: image)
                            try? InformationStorage?.setObject(wrapper, forKey: self.info.FrAvatarUrl)
                            self.TypeGameImg.image = image
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                }
                
            }
            
        } else {
            
            
            DataService.instance.mainDataBaseRef.child("User").child(userUID).child("NewGrMess").child(info.key).observeSingleEvent(of: .value, with: { (snap) in
                
                if let value = snap.value as? Int, value == 1 {
                    
                    
                    self.nameLbl.textColor = UIColor.black
                    self.dateGamePlayLbl.textColor = UIColor.black
                    
                } else {
                    
                    self.nameLbl.textColor = UIColor.darkGray
                    self.dateGamePlayLbl.textColor = UIColor.lightGray
                    
                }
                
                
            })
            
            
 
           
            DataService.instance.GamePostRef.child(info.Country).child(info.type).child(info.GameID).child("Information").child("Joined_User").observeSingleEvent(of: .value, with: { (snaps) in
                
                if snaps.exists() {
                    
                    let count = String(snaps.childrenCount + 1)
                    self.numberOfPeopleLbl.text = count
                    
                } else {
                    
                    self.numberOfPeopleLbl.text = "1"
                    
                }
                
                
                
                
                
            })
            
            nameLbl.text = info.name
            
            let icon = info.type.lowercased()
            
            let iconImg = UIImage(named: icon)
           
            
            TypeGameImg.contentMode = .scaleAspectFill
            numberOfPeopleLbl.text = ""
            TypeGameImg.image = iconImg
            
            
            // process timestamp
            
            
            let dateFormatter = DateFormatter()
            let timeFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            timeFormatter.timeStyle = DateFormatter.Style.short
            print(info.timePlay)
            let time = (info.timePlay as? TimeInterval)! / 1000
            let date = Date(timeIntervalSince1970: time)
            let Dateresult = dateFormatter.string(from: date)
            let Timeresult = timeFormatter.string(from: date)
            dateGamePlayLbl.text = Dateresult + " " + Timeresult
            
        }
        
        
        
        
        
        
        
        
    }
    

}
