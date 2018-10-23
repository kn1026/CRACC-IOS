
//
//  GoogleSupportVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/22/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Cache
import SwiftLoader

class GoogleSupportVC: UIViewController {

    
    
    
    
    var name: String?
    var gender: String?
    var type: String?
    var email: String?
    var avatarUrl: String?
    
   
    @IBOutlet weak var nickNameTxrField: UITextField!
    @IBOutlet weak var birthdayTxtField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nickNameTxrField.becomeFirstResponder()
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        //datePickerView.minimumDate = Date()
        //.addingTimeInterval(60 * 60 * 24 * 5)
        
        
        
        birthdayTxtField.inputView = datePickerView
        
        //datePickerView.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(GoogleSupportVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayTxtField.text = dateFormatter.string(from: sender.date)
        
        
        
        
        
        
    }
    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        
        
        
        if let birthday = birthdayTxtField.text, birthday != "", let nickname = nickNameTxrField.text, nickname != "" {
            
            
            if nickname.contains(" ") {
                
                showErrorAlert("Oops !!!", msg: "CRACC: invalid nickname")
                return
            }
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            var isBirthday = false
            var FinalBirthday = [String]()
            let testBirthdaylArr = Array(birthday)
            
            
            for i in testBirthdaylArr  {
                
                if isBirthday == false {
                    
                    if i == "," {
                        
                        isBirthday = true
                        
                    }
                    
                } else {
                    
                    let num = String(i)
                    
                    
                    FinalBirthday.append(num)
                    
                }
                
            }
            
            
            let result = FinalBirthday.dropFirst()
            if let bornYear = Int(result.joined()) {
                
                
                
                let currentAge = year - bornYear
                if currentAge > 13 {
                    
                    
                    
                    view.endEditing(true)
                    self.swiftLoader()
                    
                    DataService.instance.checkNickNameUserRef.child(nickname).observeSingleEvent(of: .value, with: { (snapShot) in
                        
                        if snapShot.value is NSNull {
                            
                            if let name = self.name, name != "", let email = self.email, email != "", let avatarUrl = self.avatarUrl, avatarUrl != "", let gender = self.gender, gender != "" {
                                
                                guard let fcmToken = Messaging.messaging().fcmToken else { return }
                                
                                let profile: Dictionary<String, AnyObject> = ["Type": self.type as AnyObject,"Birthday": birthday as AnyObject, "Name": self.name as AnyObject, "Email": self.email as AnyObject, "Gender": self.gender! as AnyObject, "avatarUrl": avatarUrl as AnyObject, "Stars": 0 as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "fcmToken": fcmToken as AnyObject, "nickname": nickname as AnyObject, "userUID": userUID as AnyObject]
                                let matchInfo: Dictionary<String, AnyObject> = ["Type": self.type as AnyObject,"Birthday": birthday as AnyObject, "Name": self.name as AnyObject, "avatarUrl": avatarUrl as AnyObject, "LastTimePlayed": "nil" as AnyObject, "nickname": nickname as AnyObject]
                                let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "SignUp" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject]
                                
                                
                               DataService.instance.mainDataBaseRef.child("User").child("Google").child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                                
                                DataService.instance.fcmTokenUserRef.child(userUID).setValue(profile)
                                DataService.instance.nickNameDataRef.child(nickname).setValue(profile)
                                DataService.instance.UsersRef.child("Google").child(userUID).setValue(profile)
                                DataService.instance.checkNickNameUserRef.child(nickname).setValue(["Timestamp": ServerValue.timestamp()])
                                DataService.instance.checkGoogleUserRef.child(userUID).setValue(["Timestamp": ServerValue.timestamp()])
                                
                                DataService.instance.mainDataBaseRef.child("User").child("Google").child(userUID).child("Match_History").child("Information").setValue(matchInfo)
                                DataService.instance.mainDataBaseRef.child("User").child("Google").child(userUID).child("Game_Created").setValue(["defalut": "defaults"])
                                DataService.instance.mainDataBaseRef.child("User").child("Google").child(userUID).child("Game_Joined").setValue(["defalut": "defaults"])
                                DataService.instance.mainDataBaseRef.child("User").child("Google").child(userUID).child("Chat_List").setValue(["defalut": "defaults"])
                                DataService.instance.mainDataBaseRef.child("User").child("Google").child(userUID).child("Interested_List").setValue(["defalut": "defaults"])
                                DataService.instance.mainDataBaseRef.child("User").child("Google").child(userUID).child("Community_List").setValue(["defalut": "defaults"])
                                
                                
                                if temporaryImage != nil {
                                    
                                    
                                    
                                    
                                    if try! InformationStorage?.existsObject(ofType: ImageWrapper.self, forKey: "avatarImg") != false {
                                        
                                        try? InformationStorage?.removeAll()
                                        
                                    }
                                    
                                    let wrapper = ImageWrapper(image: temporaryImage!)
                                    try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                                    try? InformationStorage?.setObject(self.name, forKey: "name")
                                    try? InformationStorage?.setObject(self.email, forKey: "email")
                                    try? InformationStorage?.setObject(self.gender, forKey: "gender")
                                    try? InformationStorage?.setObject(self.type, forKey: "type")
                                    try? InformationStorage?.setObject(birthday, forKey: "birthday")
                                    try? InformationStorage?.setObject(avatarUrl, forKey: "avatarUrl")
                                    try? InformationStorage?.setObject(fcmToken, forKey: "fcmToken")
                                    try? InformationStorage?.setObject(nickname, forKey: "nickname")
                                    
                                    
                                    
                                }
                                
                                SwiftLoader.hide()
                                
                                self.view.endEditing(true)
                                self.performSegue(withIdentifier: "moveToMapVC3", sender: nil)
                                
                            } else {
                                
                                
                                
                                SwiftLoader.hide()
                                self.showErrorAlert("Oops !!!", msg: "CRACC: error occured")
                                
                                
                            }
                            
                        } else {
                            
                            SwiftLoader.hide()
                            self.showErrorAlert("Oops !!!", msg: "CRACC: This nickname has been used before")
                            
                            
                        }
                        
                        
                        
                    })
                    
                    
                    
                    
                } else {
                    
                    showErrorAlert("Oops !!!", msg: "CRACC: You need to be above 13 years old to sign up for CRACC")
                    
                    
                }
                
            }
            
           
            
            
            
            
            
            
        } else {
        
        
            showErrorAlert("Oops !!!", msg: "CRACC: Please choose your birthday")
            
        
        
        }
        
        
        
        
        
        
        
        
    }
    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
        
        
        
        
        
    }
    

    
    @IBAction func goBackBtnPressed(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }

}
