//
//  SelectedImgVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/11/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class SelectedImgVC: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    var image: UIImage!
    var name: String!
    var selectedDate: Date!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let image = image {
            
            imageView.image = image
            nameLbl.text = name
            timeLbl.text = timeAgoSinceDate(selectedDate, numericDates: true)
        }
        
    }

    
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
