//
//  SettingVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/22/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//


import UIKit
import Cache
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase
import FirebaseAuth
import SwiftLoader
import Alamofire



class SettingVC: UIViewController, UINavigationControllerDelegate  {

    @IBOutlet weak var emailLbl: UITextField!
    @IBOutlet weak var lastNameLbl: UITextField!
    @IBOutlet weak var firstNameLbl: UITextField!
    @IBOutlet weak var profileImgView: ImageRound!
    @IBOutlet weak var pwdLbl: UITextField!
    @IBOutlet weak var cfPwdLbl: UITextField!
    
    
    var name: String?
    var birthday: String?
    var email: String?
    var avatarUrl: String?
    var type: String?
    var gender: String?
    
    
    var changedImg: UIImage!
    var isImageChange = false
    var isChangeName = false
    var imageProfile: UIImage?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        isImageChange = false
        isChangeName = false
        
        
        
        
        if let CacheavatarImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: "avatarImg").image {
            
            self.profileImgView.image = CacheavatarImg
            
        }
        
        if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "name"){
            
            let fullName = CachedName
            let fullNameArr : [String] = fullName!.components(separatedBy: " ")
            
            // And then to access the individual words:
            
            let firstName = fullNameArr[0]
            let temporarylastName = fullNameArr[1...fullNameArr.count - 1]
            
            let lastName = temporarylastName.joined(separator: " ")
            firstNameLbl.placeholder = firstName
            lastNameLbl.placeholder = lastName
            
        }
        
        if let CachedEmail = try? InformationStorage?.object(ofType: String.self, forKey: "email"){
            
            
            emailLbl.placeholder = CachedEmail
            
            
        }
        
        
        
        
        
        
    }
    
    @IBAction func SetProfileImgBtnPressed(_ sender: Any) {
        
        self.getMediaFrom(kUTTypeImage as String)
        
    }
    
    func getImage(image: UIImage) {
        profileImgView.image = image
        imageProfile = image
        changedImg = image
    }
    
    
    // get media
    
    func getMediaFrom(_ type: String) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func backBtnPressed1(_ sender: Any) {

        
        goback()
        
        
        
    }
    
    @IBAction func backBtnPressed2(_ sender: Any) {
        
        goback()
    }
    
    
    func goback() {
        
        if self.isImageChange == true {
            self.swiftLoader()
            
            DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).observeSingleEvent(of: .value, with: { (snapData) in
                
                if let dict = snapData.value as? Dictionary<String, Any> {
                    
                    
                    var nickname = ""
                    
                    if let name = dict["Name"] as? String {
                        
                        self.name = name
                        
                    }
                    
                    if let email = dict["Email"] as? String {
                        
                        self.email = email
                        
                    }
                    
                    if let gender = dict["Gender"] as? String {
                        
                        self.gender = gender
                        
                    }
                    
                    if let type = dict["Type"] as? String {
                        
                        self.type = type
                        
                    }
                    if let birthday = dict["Birthday"] as? String {
                        
                        self.birthday = birthday
                        
                    }
                    
                    if let avtarUrls = dict["avatarUrl"] as? String {
                        
                        self.avatarUrl = avtarUrls
                        
                        
                    }
                    if let nicknames = dict["nickname"] as? String {
                        
                        nickname = nicknames
                        
                        
                    }
                    
                    guard let fcmToken = Messaging.messaging().fcmToken else { return }
                    let values = ["fcmToken": fcmToken]
                    
                    DataService.instance.mainDataBaseRef.child("fcmToken").child(userUID).updateChildValues(values)
                    
                    Alamofire.request(self.avatarUrl!).responseImage { response in
                        
                        if let image = response.result.value {
                            temporaryImage = image
                            
                            try? InformationStorage?.removeAll()
                            
                            let wrapper = ImageWrapper(image: temporaryImage!)
                            try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                            try? InformationStorage?.setObject(self.name, forKey: "name")
                            try? InformationStorage?.setObject(self.email, forKey: "email")
                            try? InformationStorage?.setObject(self.gender, forKey: "gender")
                            try? InformationStorage?.setObject(self.type, forKey: "type")
                            try? InformationStorage?.setObject(self.birthday, forKey: "birthday")
                            try? InformationStorage?.setObject(self.avatarUrl, forKey: "avatarUrl")
                            try? InformationStorage?.setObject(nickname, forKey: "nickname")
                            try? InformationStorage?.setObject(fcmToken, forKey: "fcmToken")
                            
                        }
                        
                        SwiftLoader.hide()
                        self.performSegue(withIdentifier: "showMapVC9", sender: nil)
                        
                    }
                    
                    
                }
                
                
                
            })
            
        } else {
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        if changedImg != nil || emailLbl.text != "" || firstNameLbl.text != "" || lastNameLbl.text != "" || pwdLbl.text != "" {
            
            if changedImg != nil {
                self.swiftLoader()
                let metaData = StorageMetadata()
                let imageUID = UUID().uuidString
                metaData.contentType = "image/jpeg"
                var imgData = Data()
                imgData = changedImg.jpegData(compressionQuality: 1.0)!
                let time = (Int64(Date().timeIntervalSince1970 * 1000))

                DataService.instance.AvatarStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
                    
                    if err != nil {
                        print(err?.localizedDescription as Any)
                        
                    } else {
                        
                        
                        DataService.instance.AvatarStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                            
                            guard let Url = url?.absoluteString else { return }
                            
                            let downUrl = Url as String
                            let downloadsUrl = downUrl as NSString
                            let downloadUrl = downloadsUrl as String
                            
                            
                            self.isImageChange = true
                            
                            SwiftLoader.hide()
                            self.changedImg = nil
                            
                            DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).child("avatarUrl").setValue(downloadUrl)
                            DataService.instance.mainDataBaseRef.child("User_Info").child("fcmToken").child(userUID).child("avatarUrl").setValue(downloadUrl)
                            
                            if let CachedNickName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
                                
                                
                                DataService.instance.nickNameDataRef.child(CachedNickName!).child("avatarUrl").setValue(downloadUrl)
                                
                                
                                
                            }
                            
                            
                            let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
                            
                            userUrl.child("Match_History").child("Information").child("avatarUrl").setValue(downloadUrl)
                            
                            userUrl.child("Chat_List").queryOrdered(byChild: "time").queryStarting(atValue: time).observeSingleEvent(of: .value, with: { (snapInfo) in
                                
                                if snapInfo.exists() {
                                    
                                    if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                                        
                                        for item in snap {
                                            if let postDict = item.value as? Dictionary<String, Any> {
                                                
                                                if let key = postDict["GameID"] as? String , let country = postDict["Country"] as? String, let hosterUID = postDict["HosterUID"] as? String, let type = postDict["type"] as? String, let chatKey = postDict["chatKey"] as? String {
                                                    
                                                    
                                                    if hosterUID != userUID {
                                                        
                                                        let gameUrl = DataService.instance.GamePostRef.child(country).child(type).child(key).child("Information").child("Joined_User").child(userUID)
                                                        
                                                        
                                                        gameUrl.child("JoinedAvatarUrl").setValue(downloadUrl)
                                                        
                                                        
                                                        
                                                        
                                                    } else {
                                                        
                                                        let gameUrl = DataService.instance.GamePostRef.child(country).child(type).child(key).child("Information")
                                                        
                                                        gameUrl.child("avatarUrl").setValue(downloadUrl)
                                                        
                                                        
                                                    }
                                                    
                                                    let groupChatUrl = DataService.instance.GameChatRef.child(chatKey).child("user")
                                                    groupChatUrl.child(userUID).child("avatarUrl").setValue(downloadUrl)
                                                    
                                                    
                                                }
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                            })
                            
                            
                            
                            userUrl.child("Friend_List").observeSingleEvent(of: .value, with: { (snapfr) in
                                
                                
                                if snapfr.exists() {
                                    
                                    if let snap = snapfr.children.allObjects as? [DataSnapshot] {
                                        
                                        for item in snap {
                                            
                                            if let postDict = item.value as? Dictionary<String, Any> {
                                                
                                                if let FriendType = postDict["FriendType"] as? String {
                                                    
                                                    
                                                    let frUrl = DataService.instance.mainDataBaseRef.child("User").child(FriendType).child(item.key)
                                                    
                                                    frUrl.child("Friend_List").child(userUID).child("FriendAvatarUrl").setValue(downloadUrl)
                                                    
                                                    frUrl.child("Add_Chat").child(userUID).observeSingleEvent(of: .value, with: { (chatCheck) in
                                                        
                                                        if chatCheck.exists() {
                                                            
                                                            frUrl.child("Add_Chat").child(userUID).child("frAvatarUrl").setValue(downloadUrl)
                                                            
                                                        }
                                                        
                                                        
                                                    })
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("User").child(FriendType).child(item.key).child("Friend_Chat").queryOrdered(byChild: "FriendUID").queryEqual(toValue: userUID).observeSingleEvent(of: .value, with: { (snapCheck) in
                                                        if snapCheck.value is NSNull {
                                                            
                                                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Chat").queryOrdered(byChild: "FriendUID").queryEqual(toValue: item.key).observeSingleEvent(of: .value, with: { (snapCheckAgain) in
                                                                
                                                                if snapCheckAgain.exists() {
                                                                    
                                                                    let snapShot = snapCheckAgain.children.allObjects as! [DataSnapshot]
                                                                    for snap in snapShot {
                                                                        let postDict = snap.value as? Dictionary<String, Any>
                                                                        let groupIDGot = postDict!["GroupID"]
                                                                        if let id = groupIDGot as? String {
                                                                            
                                                                            let url = DataService.instance.NormalChatRef.child(id).child("user").child(userUID).child("avatarUrl")
                                                                            url.setValue(downloadUrl)
                                                                            
                                                                        }
                                                                        
                                                                    }
                                                                    
                                                                }
                                                            })
                                                        } else {
                                                            
                                                            let snapShot = snapCheck.children.allObjects as! [DataSnapshot]
                                                            for snap in snapShot {
                                                                let postDict = snap.value as? Dictionary<String, Any>
                                                                let groupIDGot = postDict!["GroupID"]
                                                                if let id = groupIDGot as? String {
                                                                    
                                                                    let url = DataService.instance.NormalChatRef.child(id).child("user").child(userUID).child("avatarUrl")
                                                                    url.setValue(downloadUrl)
                                                                }
                                                                
                                                            }
                                                        }
                                                        
                                                    })
                                                    
                                                    
                                                }
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                            })
                            
                            
                            DataService.instance.mainDataBaseRef.child("Community").child(userUID).queryLimited(toLast: 100).observeSingleEvent(of: .value, with: { (snapfr) in
                                
                                
                                if snapfr.exists() {
                                    
                                    if let snap = snapfr.children.allObjects as? [DataSnapshot] {
                                        
                                        for item in snap {
                                            
                                            let url = DataService.instance.mainDataBaseRef.child("Community").child(userUID).child(item.key).child("CommunityAvatarUrl")
                                            
                                            url.setValue(downloadUrl)
                                            
                                            
                                            
                                        }
                                        
                                        
                                    }
                                }
                            })
                            
                        })

                        
                        
                        
                        
                    }
                    

                }
                
            }
            
            if emailLbl.text != "" {
                
                let user = Auth.auth().currentUser;
                
                user?.updateEmail(to: emailLbl.text!, completion: { (err) in
                    if err != nil {
                        self.showErrorAlert("Oopps !!!", msg: "CRACC: \(err.debugDescription)")
                    } else {
                        DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).child("Email").setValue(self.emailLbl.text!)
                        self.emailLbl.placeholder = self.emailLbl.text
                        
                        try? InformationStorage?.removeObject(forKey: "email")
                        try? InformationStorage?.setObject(self.emailLbl.text!, forKey: "email")
                    }
                    
                    self.emailLbl.text = ""
                })
                
            }
            
            if firstNameLbl.text != "", lastNameLbl.text != "" {
                
                let name = firstNameLbl.text! + " " + lastNameLbl.text!
                
                
                DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).child("Name").setValue(name)
                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Match_History").child("Information").child("Name").setValue(name)
                
                firstNameLbl.placeholder = firstNameLbl.text
                lastNameLbl.placeholder = lastNameLbl.text
                
                try? InformationStorage?.removeObject(forKey: "name")
                try? InformationStorage?.setObject(name, forKey: "name")
                
                firstNameLbl.text = ""
                 lastNameLbl.text = ""
                
                isChangeName = true
                
                
            } else if firstNameLbl.text != "", lastNameLbl.text == "" {
                
                let name = firstNameLbl.text! + " " + lastNameLbl.placeholder!
                DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).child("Name").setValue(name)
                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Match_History").child("Information").child("Name").setValue(name)
                
                
                firstNameLbl.placeholder = firstNameLbl.text
                try? InformationStorage?.removeObject(forKey: "name")
                try? InformationStorage?.setObject(name, forKey: "name")
                
                firstNameLbl.text = ""
                isChangeName = true

            } else if firstNameLbl.text == "", lastNameLbl.text != "" {
                
                let name = firstNameLbl.placeholder! + " " + lastNameLbl.text!
                DataService.instance.mainDataBaseRef.child("User_Info").child(userType).child(userUID).child("Name").setValue(name)
                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Match_History").child("Information").child("Name").setValue(name)
                
                
                
                lastNameLbl.placeholder = lastNameLbl.text
                try? InformationStorage?.removeObject(forKey: "name")
                try? InformationStorage?.setObject(name, forKey: "name")
                lastNameLbl.text = ""
                
                isChangeName = true
                
            }
            
            
            
            
            if pwdLbl.text != "" {
                
                if cfPwdLbl.text != "" {
                    
                    if pwdLbl.text == cfPwdLbl.text {
                        
                        let user = Auth.auth().currentUser;
                        
                        
                        user?.updatePassword(to: pwdLbl.text!, completion: { (err) in
                            if err != nil {
                                self.showErrorAlert("Oopps !!!", msg: "CRACC: \(err.debugDescription)")
                            }
                            self.pwdLbl.text = ""
                            self.cfPwdLbl.text = ""
                        })
                        
                        
                    } else {
                        
                        self.showErrorAlert("Oopps !!!", msg: "Password is not match, please try again")
                        
                    }
                    
                    
                    
                } else {
                    
                    self.showErrorAlert("Oopps !!!", msg: "Please enter a new confirmed password")
                    
                }
                
                
            }
        
        
            
            
            
            
            
            
            
            self.view.endEditing(true)
            
            
            
        } else {
            
            
            self.showErrorAlert("Oopps !!!", msg: "CRACC: Please fill up the field you want to change")
            
        }
        
        
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

extension SettingVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            getImage(image: editedImage)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            getImage(image: originalImage)
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
