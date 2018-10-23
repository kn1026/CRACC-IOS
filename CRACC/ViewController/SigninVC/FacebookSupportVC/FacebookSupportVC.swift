//
//  FacebookSupportVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/23/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase
import Cache
import SwiftLoader



class FacebookSupportVC: UIViewController {

    @IBOutlet weak var nickNameTxtField: UITextField!
    @IBOutlet weak var birthdayTxtField: UITextField!
    @IBOutlet weak var maleBtn: RoundedBtn!
    @IBOutlet weak var femaleBtn: RoundedBtn!
    
   
    var gender: String?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        nickNameTxtField.becomeFirstResponder()
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.maximumDate = Date()
        
        
        birthdayTxtField.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(FacebookSupportVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }

    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        if let nickName = nickNameTxtField.text, nickName != "", let birthday = birthdayTxtField.text, birthday != "", let gender = self.gender, gender != ""{
            
            if nickName.contains(" ") {
                showErrorAlert("Oops !!!", msg: "CRACC: Invalid nickname ")
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
                    
                    DataService.instance.checkNickNameUserRef.child(nickName).observeSingleEvent(of: .value, with: { (snapShot) in
                        
                        if snapShot.value is NSNull {
                            
                            
                            FBProfile.updateValue(nickName as AnyObject, forKey: "nickname")
                            FBProfile.updateValue(gender as AnyObject, forKey: "Gender")
                            FBProfile.updateValue(birthday as AnyObject, forKey: "Birthday")
                            FBmatchInfo.updateValue(nickName as AnyObject, forKey: "nickname")
                            FBmatchInfo.updateValue(birthday as AnyObject, forKey: "Birthday")
                            
                            let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "SignUp" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject]
                            
                            
                            DataService.instance.mainDataBaseRef.child("User").child("Facebook").child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                            
                            
                            DataService .instance.fcmTokenUserRef.child(userUID).setValue(FBProfile)
                            DataService .instance.nickNameDataRef.child(nickName).setValue(FBProfile)
                            DataService.instance.UsersRef.child("Facebook").child(userUID).setValue(FBProfile)
                            DataService.instance.checkFacebookUserRef.child(userUID).setValue(["Timestamp": ServerValue.timestamp()])
                            DataService.instance.checkNickNameUserRef.child(nickName).setValue(["Timestamp": ServerValue.timestamp()])
                            
                            
                            DataService.instance.mainDataBaseRef.child("User").child("Facebook").child(userUID).child("Match_History").child("Information").setValue(FBmatchInfo)
                            DataService.instance.mainDataBaseRef.child("User").child("Facebook").child(userUID).child("Game_Created").setValue(["defalut": "defaults"])
                            DataService.instance.mainDataBaseRef.child("User").child("Facebook").child(userUID).child("Game_Joined").setValue(["defalut": "defaults"])
                            DataService.instance.mainDataBaseRef.child("User").child("Facebook").child(userUID).child("Chat_List").setValue(["defalut": "defaults"])
                            DataService.instance.mainDataBaseRef.child("User").child("Facebook").child(userUID).child("Interested_List").setValue(["defalut": "defaults"])
                            DataService.instance.mainDataBaseRef.child("User").child("Facebook").child(userUID).child("Community_List").setValue(["defalut": "defaults"])
                            
                            
                            
                            if temporaryImage != nil {
                                
                                
                                
                                if try! InformationStorage?.existsObject(ofType: ImageWrapper.self, forKey: "avatarImg") != false {
                                    
                                    try? InformationStorage?.removeAll()
                                    
                                }
                                if let avatarUrl = FBProfile["avatarUrl"] as? String, let name = FBProfile["Name"] as? String, let email = FBProfile["Email"] as? String, let gender = FBProfile["Gender"] as? String, let type = FBProfile["Type"] as? String, let birthday = FBProfile["Birthday"] as? String, let fcmtoken = FBProfile["fcmToken"] as? String  {
                                    
                                    
                                    let wrapper = ImageWrapper(image: temporaryImage!)
                                    try? InformationStorage?.setObject(avatarUrl, forKey: "avatarUrl")
                                    try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                                    try? InformationStorage?.setObject(name, forKey: "name")
                                    try? InformationStorage?.setObject(email, forKey: "email")
                                    try? InformationStorage?.setObject(gender, forKey: "gender")
                                    try? InformationStorage?.setObject(type, forKey: "type")
                                    try? InformationStorage?.setObject(birthday, forKey: "birthday")
                                    try? InformationStorage?.setObject(fcmtoken, forKey: "fcmToken")
                                    try? InformationStorage?.setObject(nickName, forKey: "nickname")
                                    
                                    
                                }
                                
                                
                            }
                            
                            SwiftLoader.hide()
                            self.performSegue(withIdentifier: "GoToMainVC5", sender: nil)
                            
                            
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
            
            showErrorAlert("Oops !!!", msg: "CRACC: Please fill all informations to continue")
            
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
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthdayTxtField.text = dateFormatter.string(from: sender.date)
        
        
        
        
        
        
    }
    
    @IBAction func GoBackToMainVCBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func maleBtnPressed(_ sender: Any) {
        
        maleBtn.setTitleColor(UIColor.white, for: [.normal])
        maleBtn.backgroundColor = ChosenColor
        
        
        femaleBtn.setTitleColor(ChosenColor, for: [.normal])
        femaleBtn.backgroundColor = UIColor.white
        
        self.gender = "male"
        
    }
    @IBAction func femaleBtnPressed(_ sender: Any) {
        
        femaleBtn.setTitleColor(UIColor.white, for: [.normal])
        femaleBtn.backgroundColor = ChosenColor
        
        
        maleBtn.setTitleColor(ChosenColor, for: [.normal])
        maleBtn.backgroundColor = UIColor.white
        
        self.gender = "female"
        
    }
}
