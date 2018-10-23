//
//  CommunityCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/31/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire

class CommunityCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var StatusLbl: UILabel!
    @IBOutlet weak var SportType: UIImageView!
    @IBOutlet weak var LikeBtn: UIButton!
    @IBOutlet weak var timeStamp: UILabel!
    
    @IBOutlet weak var LikeCount: UILabel!
    
    var info: CommunityModel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ Information: CommunityModel) {
        
        self.info = Information
        
        
        
        DataService.instance.mainDataBaseRef.child("LikesCount").child(info.CommunityKey).observeSingleEvent(of: .value, with: { (snap) in
            
            if snap.exists() {
                
                self.LikeCount.isHidden = false
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = UIImage(named: "liked")
                imageAttachment.bounds = CGRect(x: 3, y: -3, width: 13, height: 13)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                let myString = NSMutableAttributedString(string: "")
                myString.append(NSMutableAttributedString(string: String(snap.childrenCount)))
                myString.append(attachmentString)
                self.LikeCount.attributedText = myString
                
            } else {
                
                self.LikeCount.isHidden = true
                
            }
            
            
            
        })
        

        
        LikeBtn.setImage(info.hasLiked == true ? #imageLiteral(resourceName: "liked").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        
        
        let gameIcon = info.type.lowercased()
        
        SportType.image = UIImage(named: "\(gameIcon)")
        
        
       
        let time = info.timestamp as? TimeInterval
        
        let date = Date(timeIntervalSince1970: time!/1000)
        
        timeStamp.text = timeAgoSinceDate(date, numericDates: true)
        
        
        
        if info.CommunityAvatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: info.CommunityAvatarUrl).image {
                
                
                
                avatarImg.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(info.CommunityAvatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: self.info.CommunityAvatarUrl)
                        self.avatarImg.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
        } else {
            
            avatarImg.image = UIImage(named: "CRACC")
        }
        if let name = info.CommunityName, let gameName = info.name {
            
            let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]
            let atts = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)]
            let boldName = NSMutableAttributedString(string:name, attributes:att)
            let boldGameName = NSMutableAttributedString(string:gameName, attributes:att)
            
            let create = NSMutableAttributedString(string: " has created a game - ", attributes: atts)
            let Joined = NSMutableAttributedString(string: " has joined a ", attributes: atts)
            let gameAt = NSMutableAttributedString(string: " game at ", attributes: atts)
            let isThe = NSMutableAttributedString(string: " is the ", attributes: atts)
            let of = NSMutableAttributedString(string: " of ", attributes: atts)

            if info.TypePost == "Created" {
                
                let myString = NSMutableAttributedString(string: "")
                myString.append(boldName)
                myString.append(create)
                myString.append(boldGameName)
                
                StatusLbl.attributedText = myString
                
            } else if info.TypePost == "Joined"{
                let myString = NSMutableAttributedString(string: "")
                myString.append(boldName)
                myString.append(Joined)
                myString.append(gameAt)
                myString.append(boldGameName)
                
                StatusLbl.attributedText = myString
                
                StatusLbl.attributedText = myString
            } else {
                let myString = NSMutableAttributedString(string: "")
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = UIImage(named: "mvp")
                //Set bound to reposition
                imageAttachment.bounds = CGRect(x: 3, y: -3, width: 23, height: 23)
                //Create string with attachment
                let attachmentString = NSAttributedString(attachment: imageAttachment)
 
        
                myString.append(boldName)
                myString.append(isThe)
                myString.append(attachmentString)
                myString.append(of)
                myString.append(boldGameName)
                
                StatusLbl.attributedText = myString
                
            }
            
        }
        
        
        
        
    }
    
    
   
    
    
}

