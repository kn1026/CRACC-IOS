//
//  ReportVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/2/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase
import Cache
import SCLAlertView

class ReportVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var reportTxtView: CommentField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportTxtView.delegate = self
        // Do any additional setup after loading the view.
        
        
        
    }
    
    
    

    @IBAction func dismisBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func dismisBtn2Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        if reportTxtView.text == "Message" || reportTxtView.text == "" {
            
            
            self.showErrorAlert("Oopps !!!", msg: "CRACC: Please type a message")
            
            
        } else {
            
            if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
                
                
               
                self.view.endEditing(true)
                
                let url = DataService.instance.mainDataBaseRef.child("Report").child(userUID)
                
                
                let MyReport: Dictionary<String, AnyObject>  = ["ReportName": CachedName as AnyObject, "ReportUID": userUID as AnyObject, "ReportTime": ServerValue.timestamp() as AnyObject, "ReportType": userType as AnyObject, "ReportText": reportTxtView.text as AnyObject]
                
                
                
                url.childByAutoId().setValue(MyReport)
                
                reportTxtView.text = "Message"
                
                
                
                let alert = SCLAlertView()
                
                _ = alert.showSuccess("Successfully!!!", subTitle: "CRACC: We will review your message in 24 hours and response via chat message. Thank you for supporting and helping our community")
                
                
                
            } else {
                
                self.showErrorAlert("Oopps !!!", msg: "CRACC: Error occured, please try again")
                
            }
            
            
            
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            
            textView.text = ""
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        
        self.view.endEditing(true)
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
}
