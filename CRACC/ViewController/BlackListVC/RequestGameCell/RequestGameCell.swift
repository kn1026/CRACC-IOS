//
//  RequestGameCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/5/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire

class RequestGameCell: UITableViewCell {

    @IBOutlet weak var avatarImg: addBorderAndRoundedCornerImgView!
    @IBOutlet weak var requestLbl: UILabel!
    @IBOutlet weak var blockBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    
    
    var info: RequestJoinedModel!
    
    var avatarUrls = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ Information: RequestJoinedModel) {

        let defaulImg = UIImage(named: "CRACC")
        self.info = Information
        
        
        let att = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]
        let atts = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]
        
        let boldName = NSMutableAttributedString(string: info.Requestedname, attributes:att)
        let boldGameName = NSMutableAttributedString(string:info.RequestedGameName, attributes:att)
        
        let Join = NSMutableAttributedString(string: " wants to join your ", attributes: atts)
        let game = NSMutableAttributedString(string: " game ", attributes: atts)
        
        
        let myString = NSMutableAttributedString(string: "")
        myString.append(boldName)
        myString.append(Join)
        myString.append(boldGameName)
        myString.append(game)
        
        
        
        requestLbl.attributedText = myString
        
        
        
       

        DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).observeSingleEvent(of: .value, with: { (snapInfo) in
            
            
            if snapInfo.exists() {
                
                if let snap = snapInfo.value as? Dictionary<String, Any> {
                    
                    if let avatarUrl = snap["avatarUrl"] as? String {
                        
                        self.avatarUrls = avatarUrl
                        
                        
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
