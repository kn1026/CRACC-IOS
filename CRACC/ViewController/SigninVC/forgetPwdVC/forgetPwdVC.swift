//
//  forgetPwdVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/15/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class forgetPwdVC: UIViewController {

    @IBOutlet weak var ResetEmailPwdLbl: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func dismissBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func sendCodeBtnPressed(_ sender: Any) {
        
        if let email = ResetEmailPwdLbl.text, email != "" {
            
            
            
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (err) in
                if err != nil {
                    self.showErrorAlert("Error Occured", msg: "Please try again !!!")
                } else {
                    let alert = SCLAlertView()
                    
                    _ = alert.showSuccess("Reset email has been sent", subTitle: "CRACC: Please check it in both inbox and spam to reset your password")
                    self.view.endEditing(true)
                    
                }
            })
                
           
            
            
            
        } else {
            
            showErrorAlert("Oops !!!", msg: "CRACC: Fill your email and we will help you to reset your account.")
            
            
        }
        
        
        
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
}
