//
//  XIBSectionHeader4.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/23/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit

class XIBSectionHeader4: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func requestFriendModeBtnPressed(_ sender: Any) {
        
        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "openChooseFriendView")), object: nil)
        
    }
    
    
}
