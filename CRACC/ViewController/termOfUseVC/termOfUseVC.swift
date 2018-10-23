//
//  termOfUseVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/18/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class termOfUseVC: UIViewController {

    @IBOutlet weak var TermTxtView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.TermTxtView.setContentOffset(CGPoint.zero, animated: false)
    }

    @IBAction func backBtn1Pressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backBtn2Pressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
