
//
//  signUpVC3.swift
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

class signUpVC3: UIViewController {

    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var nickNameTxtField: UITextField!
    
    @IBOutlet weak var pwdTextField: UITextField!
    
    @IBOutlet weak var confirmedPwdTextField: UITextField!
    
    var gender: String?
    var birthday: String?
    var name: String?
    var avatarUrl: String?
    var type = "Email"
    var testEmail: String?
    var profile: Dictionary<String, AnyObject>?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        
        nickNameTxtField.becomeFirstResponder()
        
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        
        
    }

    
    @IBAction func signUpBtnPressed(_ sender: Any) {
        
        
        if let email = emailTxtField.text, email != "", let pwd = pwdTextField.text, pwd != "", let confirmedPwd = confirmedPwdTextField.text, confirmedPwd != "", let nickname = nickNameTxtField.text, nickname != "" {
            
            if email.contains("@") == false || email.contains(".") == false  {
                
                self.showErrorAlert("Oops !!!", msg: "CRACC: Incorrect email address.")
                
                return
            } else {
            
                if pwd != confirmedPwd {
                
                    self.showErrorAlert("Oops !!!", msg: "CRACC: Password not match.")
                    
                    return
                
                }
                
                if pwd.count < 6 {
                
                    self.showErrorAlert("Oops !!!", msg: "CRACC: Unsafe password, please choose the secure one.")
                    
                    return
                
                
                }
                
                if nickname.contains(" "){
                    
                    showErrorAlert("Oops !!!", msg: "CRACC: invalid nickname")
                    return
                    
                }
                
                
                
                var  dotCount = [Int]()
                var count = 0
                
                
            
                    var testEmailArr = Array(email)
                    for _ in 0..<(testEmailArr.count) {
                        if testEmailArr[count] == "." {
                            
                            dotCount.append(count)
                            
                            }
                        count += 1
                    }
                
                
                
                    for indexCount in dotCount {
                        testEmailArr[indexCount] = ","
                        let testEmail = String(testEmailArr)
                        self.testEmail = testEmail
                        
                    }
                
                
                
                DataService.instance.checkEmailUserRef.child(testEmail!).observeSingleEvent(of: .value, with: { (snapShot) in
                    
                    if snapShot.value is NSNull {
                        
                        
                        DataService.instance.checkNickNameUserRef.child(nickname).observeSingleEvent(of: .value, with: { (snapShot) in
                            
                            if snapShot.value is NSNull {
                                
                                Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user, error) in
                                    
                                    
                                    
                                   
                                    
                                    
                                    if error != nil {
                                        
                                        self.showErrorAlert("Oopss !!!", msg: "CRACC: error occured \(error.debugDescription).")
                                        
                                        
                                        return
                                        
                                    }
                                    self.swiftLoader()
                                    
                                    userUID = (user?.user.uid)! as String
                                    
                                    
                                    if let image = temporaryImage {
                                        
                                        temporaryImage = image
                                        let metaData = StorageMetadata()
                                        let imageUID = UUID().uuidString
                                        metaData.contentType = "image/jpeg"
                                        var imgData = Data()
                                        imgData = image.jpegData(compressionQuality: 1.0)!
                                        
                                        
                                        
                                        
                                        DataService.instance.AvatarStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
                                            
                                            if err != nil {
                                                print(err?.localizedDescription as Any)
                                                return
                                            }
                                            
                                            
                                            DataService.instance.AvatarStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                                                
                                                guard let Url = url?.absoluteString else { return }
                                                
                                                let downUrl = Url as String
                                                let downloadUrl = downUrl as NSString
                                                let downloadedUrl = downloadUrl as String
                                                
                                                self.avatarUrl = downloadedUrl
                                                
                                                
                                                guard let fcmToken = Messaging.messaging().fcmToken else { return }
                                                
                                                
                                                if self.avatarUrl != "" {
                                                    
                                                    self.profile = ["Type": "Email" as AnyObject,"Birthday": self.birthday as AnyObject, "Name": self.name as AnyObject, "Email": email as AnyObject, "Gender": self.gender! as AnyObject, "avatarUrl": self.avatarUrl as AnyObject, "Stars": 0 as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "fcmToken": fcmToken as AnyObject, "nickname": nickname as AnyObject, "userUID": userUID as AnyObject]
                                                    let matchInfo: Dictionary<String, AnyObject> = ["Type": self.type as AnyObject,"Birthday": self.birthday as AnyObject, "Name": self.name as AnyObject, "avatarUrl": self.avatarUrl as AnyObject, "LastTimePlayed": "nil" as AnyObject, "nickname": nickname as AnyObject]
                                                    
                                                    let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "SignUp" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject]
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                                                    DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("Match_History").child("Information").setValue(matchInfo)
                                                    
                                                } else {
                                                    
                                                    self.profile = ["Type": "Email" as AnyObject,"Birthday": self.birthday as AnyObject, "Name": self.name as AnyObject, "Email": email as AnyObject, "Gender": self.gender! as AnyObject, "avatarUrl": "nil" as AnyObject, "Stars": 0 as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "fcmToken": fcmToken as AnyObject, "nickname": nickname as AnyObject, "userUID": userUID as AnyObject]
                                                    let matchInfo: Dictionary<String, AnyObject> = ["Type": self.type as AnyObject,"Birthday": self.birthday as AnyObject, "Name": self.name as AnyObject, "avatarUrl": "nil" as AnyObject, "LastTimePlayed": "nil" as AnyObject, "nickname": nickname as AnyObject]
                                                    let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "SignUp" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject]
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                                                    
                                                    DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("Match_History").child("Information").setValue(matchInfo)
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                                
                                                DataService.instance.fcmTokenUserRef.child(userUID).setValue(self.profile)
                                                DataService.instance.nickNameDataRef.child(nickname).setValue(self.profile)
                                                DataService.instance.UsersRef.child("Email").child(userUID).setValue(self.profile)
                                                DataService.instance.checkNickNameUserRef.child(nickname).setValue(["Timestamp": ServerValue.timestamp()])
                                                DataService.instance.checkEmailUserRef.child(self.testEmail!).setValue(["Timestamp": ServerValue.timestamp()])
                                                
                                                DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("Game_Joined").setValue(["defalut": "defaults"])
                                                DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("Chat_List").setValue(["defalut": "defaults"])
                                                DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("Interested_List").setValue(["defalut": "defaults"])
                                                DataService.instance.mainDataBaseRef.child("User").child("Email").child(userUID).child("Community_List").setValue(["defalut": "defaults"])
                                                
                                                
                                                try? InformationStorage?.removeAll()
                                                if temporaryImage != nil {
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    
                                                    let wrapper = ImageWrapper(image: temporaryImage!)
                                                    try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                                                    try? InformationStorage?.setObject(self.name, forKey: "name")
                                                    try? InformationStorage?.setObject(email, forKey: "email")
                                                    try? InformationStorage?.setObject(self.gender, forKey: "gender")
                                                    try? InformationStorage?.setObject(self.type, forKey: "type")
                                                    try? InformationStorage?.setObject(self.birthday, forKey: "birthday")
                                                    try? InformationStorage?.setObject(self.avatarUrl, forKey: "avatarUrl")
                                                    try? InformationStorage?.setObject(fcmToken, forKey: "fcmToken")
                                                    try? InformationStorage?.setObject(nickname, forKey: "nickname")
                                                    
                                                    
                                                } else {
                                                    
                                                    
                                                    
                                                    
                                                    try? InformationStorage?.setObject(self.name, forKey: "name")
                                                    try? InformationStorage?.setObject(email, forKey: "email")
                                                    try? InformationStorage?.setObject(self.gender, forKey: "gender")
                                                    try? InformationStorage?.setObject(self.type, forKey: "type")
                                                    try? InformationStorage?.setObject(self.birthday, forKey: "birthday")
                                                    try? InformationStorage?.setObject(fcmToken, forKey: "fcmToken")
                                                    try? InformationStorage?.setObject(nickname, forKey: "nickname")
                                                    
                                                    
                                                    
                                                    
                                                    
                                                }
                                                
                                                SwiftLoader.hide()
                                                self.performSegue(withIdentifier: "moveToMapVC2", sender: nil)
                                            })
                                            
                                            
                                            
                                            
                                        }
                                        
                                    }

                                    
                                    
                                    
                                })
                                
                            } else {
                                
                                self.showErrorAlert("Oops !!!", msg: "CRACC: This nickname has been used before")
                                
                            }
                            
                            
                        })
                        

                        
                    } else {
                    
                        self.showErrorAlert("Oops !!!", msg: "CRACC: This email address has been used before")
                    
                    
                    }
                
                
                
                
                
                })
                
                
                
                
            
            
            
            
            }
        
        
        
        
        
        } else {
        
            self.showErrorAlert("Oops !!!", msg: "CRACC: Please fill up all the fields to sign up.")
        
        }
        
        
        
        
        
        
        
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.view.endEditing(true)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
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
    
    
    
    
    
    
}


