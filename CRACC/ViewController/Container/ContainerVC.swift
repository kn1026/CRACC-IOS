//
//  ContainerVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/1/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//
import SidebarOverlay
import UIKit
import Firebase
import FirebaseAuth
import Cache
import FBSDKCoreKit
import FBSDKLoginKit


class ContainerVC: SOContainerViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuSide = .left
        self.topViewController = self.storyboard?.instantiateViewController(withIdentifier: "2")
        self.sideViewController = self.storyboard?.instantiateViewController(withIdentifier: "1")
        
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        guard Auth.auth().currentUser != nil else {
            
            DataService.instance.mainDataBaseRef.removeAllObservers()
            self.performSegue(withIdentifier: "GoBackToSignInVC2", sender: nil)
            return
        }
        
        userUID = (Auth.auth().currentUser!.uid)

        if let CachedType = try? InformationStorage?.object(ofType: String.self, forKey: "type"){
            
            
            if CachedType == "Google" {
                
                userType = "Google"
                
                
                
            } else if CachedType == "Facebook" {
                
                
                userType = "Facebook"
                
            } else {
                
                userType = "Email"
            
            }
            
            
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "ResetRecentlyPlay")), object: nil)
            
        } else {

            try! Auth.auth().signOut()
           // GIDSignIn.sharedInstance().signOut()
            FBSDKLoginManager().logOut()
            DataService.instance.mainDataBaseRef.removeAllObservers()
            self.performSegue(withIdentifier: "GoBackToSignInVC2", sender: nil)
            return

            
        }
        
        
        
        
        
    }
    

}
