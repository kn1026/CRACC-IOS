//
//  GameListCell.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/22/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class GameListCell: UITableViewCell {
    
    
    var info: requestModel!
    
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var gameDate: UILabel!
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var typeGameImgView: UIImageView!
    
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func configureCell(_ Information: requestModel) {
        
        self.info = Information
        
        gameName.text = info.gameName
        
        let icon = info.type.lowercased()
        
        typeGameImgView.image = UIImage(named: icon)
        
        
        // process timestamp
        
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        timeFormatter.timeStyle = DateFormatter.Style.short
        let time = (info.timePlay as? TimeInterval)! / 1000
        let date = Date(timeIntervalSince1970: time)
        let Dateresult = dateFormatter.string(from: date)
        let Timeresult = timeFormatter.string(from: date)
        gameDate.text = Dateresult
        gameTime.text = Timeresult
        
        
        
        
        
    }
    
    
    

}
