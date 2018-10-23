//
//  CameraContainerVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/10/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit

class CameraContainerVC: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(CameraContainerVC.enableScroll), name: (NSNotification.Name(rawValue: "enableScroll")), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CameraContainerVC.disableScroll), name: (NSNotification.Name(rawValue: "disableScroll")), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CameraContainerVC.dismissVC), name: (NSNotification.Name(rawValue: "dismiss")), object: nil)
        
        scrollView.isScrollEnabled = true
        
        // Do any additional setup after loading the view.
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "v1") as UIViewController?
        self.addChild(v1!)
        self.scrollView.addSubview((v1?.view)!)
        v1?.didMove(toParent: self)
        v1?.view.frame = scrollView.bounds
        
        
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "v2") as UIViewController?
        self.addChild(v2!)
        self.scrollView.addSubview((v2?.view)!)
        v2?.didMove(toParent: self)
        v2?.view.frame = scrollView.bounds
        
        var v2Frame: CGRect = (v2?.view.frame)!
        v2Frame.origin.x = self.view.frame.width
        v2?.view.frame = v2Frame
       
        
      
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height)
        self.scrollView.contentOffset = CGPoint(x: self.view.frame.width * 1, y: self.view.frame.height)
    }

    @objc func enableScroll() {
        scrollView.isScrollEnabled = true
    }
    @objc func disableScroll() {
        scrollView.isScrollEnabled = false
    }
    @objc func dismissVC() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
