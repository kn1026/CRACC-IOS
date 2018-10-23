//
//  ManageCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/3/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class ManageCell: UITableViewCell {

    
    var info: gameJoinedModel!
    
    @IBOutlet weak var imageGameType: UIImageView!
    
    @IBOutlet weak var locationName: UILabel!
    
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(_ Information: gameJoinedModel) {
        
        self.info = Information
        
        
        locationName.text = info.locationName
        
        let icon = info.type.lowercased()
        imageGameType.image = UIImage(named: icon)
        
        
        // process timestamp
        
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        timeFormatter.timeStyle = DateFormatter.Style.short
        var time: TimeInterval
        let getTime = info.timePlay as? Int
        if getTime != 0 {
        
            
            time = (info.timePlay as? TimeInterval)! / 1000
            
            let date = Date(timeIntervalSince1970: time)
            let Dateresult = dateFormatter.string(from: date)
            let Timeresult = timeFormatter.string(from: date)
            dateLbl.text = Dateresult + " " + Timeresult
            
            
            let currenttime = (Double(Date().timeIntervalSince1970 * 1000))
            
            
            if info.Canceled == 0 {
                
                
                if currenttime >= (info.timePlay as? TimeInterval)! {
                    
                    statusLbl.text = "Expired"
                    statusLbl.textColor = UIColor.red
                    
                    
                } else {
                    
                    
                    statusLbl.text = "Upcomming"
                    statusLbl.textColor = UIColor.green
                    
                }
                
            } else {
                
                statusLbl.text = "Canceled"
                statusLbl.textColor = UIColor.red
                
            }
            
            
            
        } else {
        
            time = 0
            
            dateLbl.text = "Not found "
            
            statusLbl.text = "Expired"
            statusLbl.textColor = UIColor.red
        }
        
        
        
        
        
        
        
        
        
        
        
    }

}
