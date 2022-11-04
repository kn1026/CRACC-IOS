//
//  FirstLookVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/7/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import Alamofire
import AlamofireImage
import SwiftLoader
import Cache


//import GoogleSignIn

//import FirebaseFirestore


enum GenderControl {
    case Gender
    case NoGender
}



class FirstLookVC: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
 
    var ControlGender = GenderControl.Gender
    
    // tap to dismiss keyboard
    var tap: UITapGestureRecognizer!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var pwdTextField: UITextField!
    

    
    var name: String?
    var birthday: String?
    var email: String?
    var avatarUrl: String?
    var type: String?
    var gender: String?
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //error object
        var error : NSError?
        
        //setting the error
        //GGLContext.sharedInstance().configureWithError(&error)
        
        //if any error stop execution and print error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //adding the delegates
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
         HideKeyboardWhenTapGesture()
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        self.view.removeGestureRecognizer(tap)
        self.view.endEditing(true)
        
        
    }
    
    func HideKeyboardWhenTapGesture() {
        tap = UITapGestureRecognizer(target: self, action: #selector(FirstLookVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
 
    
    //when the Google signin complets
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //if any error stop and print the error
        if error != nil{
            self.showErrorAlert("Oops!!!", msg: "CRACC: Unable to authenticate with Firebase - \(String(describing: error))")
            return
        }
        
        self.swiftLoader()
        let profile = user.profile
        let tokenAccess = user.authentication.accessToken
        let tokenID = user.authentication.idToken
        
        let credential = GoogleAuthProvider.credential(withIDToken: tokenID!,
                                                       accessToken: tokenAccess!)
        
        

        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                // ...
                self.showErrorAlert("Oops!!!", msg: "CRACC: Unable to authenticate with Firebase - \(String(describing: error))")
                return

            } else {
                if let user = user {
                    
                    userUID = user.uid
                    DataService.instance.checkGoogleUserRef.child(userUID).observeSingleEvent(of: .value, with: { (snapShot) in
                        
                        if snapShot.value is NSNull {
                            let Url_Base = "https://www.googleapis.com/oauth2/v3/userinfo?access_token="
                            let _UrlProfile = "\(Url_Base)\(tokenAccess!)"
                            Alamofire.request(_UrlProfile).responseJSON { (response) in
                                
                                
                                switch response.result {
                                case .success:
                                    if let result = response.result.value as? [String: Any] {
                                       
                                        
                                       
                                        
                                        if let gender = result["gender"] {
                                        
                                            self.gender = gender as? String
                                            self.ControlGender = GenderControl.Gender
                                        
                                        } else {
                                            
                                            self.ControlGender = GenderControl.NoGender
                                        
                                        }
                                        
                                        
                                        
                                        if  let photoUrl = result["picture"] {
                                            let imageUrl = String(describing: photoUrl)
                                            self.name = profile?.name
                                            self.email = profile?.email
                                            self.type = "Google"
                                            
                                            
                                            
                                            
                                            Alamofire.request(imageUrl).responseImage { response in
                                                
                                                
                                                if let image = response.result.value {
                                                    
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
                                                            
                                                            
                                                            switch self.ControlGender {
                                                                
                                                            case .Gender:
                                                                self.performSegue(withIdentifier: "moveToGoogleSupportVC", sender: nil)
                                                            case .NoGender:
                                                                self.performSegue(withIdentifier: "moveToGoogleSupportVC2", sender: nil)
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                            
                                                            
                                                            SwiftLoader.hide()
                                                            
                                                            
                                                        })
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                                
                                                
                                            }
                                            
                                            
                                        }
                                        
                                                                           
                                    }
                                case .failure:
                                    
                                    self.showErrorAlert("Oops!", msg: "CRACC: Can't get information from Google")
                                    return
                                    
                                    
                                    // error handling
                                }
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                                
                            }
                            
                            
                        } else {
                            
                            DataService.instance.UsersGoogleRef.child(userUID).observeSingleEvent(of: .value, with: { (snapData) in
                                
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
                                        self.performSegue(withIdentifier: "MoveToMapVC", sender: nil)
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                            })
                            
                            
                            
                            
                        }
                    })
                    
                    
                }
                
        }
    }
        
       
        
        
       
        
        
    }
    
    
    
    @IBAction func loginWithEmailBtnPressed(_ sender: Any) {
        
        
        if let email = emailTextField.text, email != "", let pwd = pwdTextField.text, pwd != "" {
            
            
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error != nil {
                    if AuthErrorCode(rawValue: -8) != nil {
                        self.showErrorAlert("Invalid email address or password !!!", msg: "Please double check your information.")
                    }
                } else {
                    self.swiftLoader()
                    userUID = (user?.user.uid)!
                    DataService.instance.UsersEmailRef.child(userUID).observeSingleEvent(of: .value, with: { (snapData) in
                        
                        
                        
                        
                        
                        if let dict = snapData.value as? Dictionary<String, Any> {
                            
                            
                            print(dict)
                            
                            
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
                            
                            
                            if self.avatarUrl != nil {
                                
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
                                        try? InformationStorage?.setObject(fcmToken, forKey: "fcmToken")
                                        try? InformationStorage?.setObject(nickname, forKey: "nickname")
                                        if self.avatarUrl != nil {
                                            try? InformationStorage?.setObject(self.avatarUrl, forKey: "avatarUrl")
                                        }
                                        
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    SwiftLoader.hide()
                                    self.performSegue(withIdentifier: "MoveToMapVC", sender: nil)
                                    
                                }
                                
                            } else {
                                
                                try? InformationStorage?.removeAll()
                                
                                let wrapper = ImageWrapper(image: temporaryImage!)
                                try? InformationStorage?.setObject(wrapper, forKey: "avatarImg")
                                try? InformationStorage?.setObject(self.name, forKey: "name")
                                try? InformationStorage?.setObject(self.email, forKey: "email")
                                try? InformationStorage?.setObject(self.gender, forKey: "gender")
                                try? InformationStorage?.setObject(self.type, forKey: "type")
                                try? InformationStorage?.setObject(self.birthday, forKey: "birthday")
                                try? InformationStorage?.setObject(fcmToken, forKey: "fcmToken")
                                try? InformationStorage?.setObject(nickname, forKey: "nickname")

                                SwiftLoader.hide()
                                self.performSegue(withIdentifier: "MoveToMapVC", sender: nil)
                                
                                
                            }
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                    } )

                    
                    
                }
            })
            
            
        } else {
            
            self.showErrorAlert("Oops !!!", msg: "CRACC: You need to fill up email and password to get in.")
            
            
        }
        
        
        
        
    }
    
    @IBAction func FaceBookBtnPressed(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                
                self.showErrorAlert("Oops !!", msg: ("CRACC: Unable to authenticate with Facebook - \(String(describing: error))"))
                return
                
            } else if result?.isCancelled == true {
                self.showErrorAlert("Oops !!", msg: ("CRACC: User cancelled Facebook authentication - \(String(describing: error))"))
                return
            } else {
                print("CRACC: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
                
            }
        }
        
        
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                self.showErrorAlert("Oops!!!", msg: "CRACC: Unable to authenticate with Firebase - \(String(describing: error))")
                return
            } else {
                if let user = user {
                    self.swiftLoader()
                    self.type = credential.provider
                    userUID = user.uid
                    
                    
                    
                    DataService.instance.checkFacebookUserRef.child(userUID).observeSingleEvent(of: .value, with: { (snapShot) in
                        
                        if snapShot.value is NSNull {
                            
                            
                            self.getData()
                            
                        } else {
                            
                            
                            DataService.instance.UsersFacebookRef.child(userUID).observeSingleEvent(of: .value, with: { (snapData) in
                                
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
                                            try? InformationStorage?.setObject(fcmToken, forKey: "fcmToken")
                                            try? InformationStorage?.setObject(nickname, forKey: "nickname")
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                        SwiftLoader.hide()
                                        self.performSegue(withIdentifier: "MoveToMapVC", sender: nil)
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                            } )
                            
                            
                        }
                    })
                    
                    
                }
            }
        })
        
    }

    func getData() {
    
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email,age_range,gender, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                if let fbDetails = result as? Dictionary<String, Any> {
                    
                    print(fbDetails)
                    
                    if let names = fbDetails["name"] {
                        self.name = names as? String
                    }
                    
                    if let emails = fbDetails["email"] {
                        self.email = emails as? String
                    }

                    
                    if let picture = fbDetails["picture"] as? Dictionary<String, Any> {
                        
                        if let data = picture["data"] as? Dictionary<String, Any> {
                            
                            if let url = data["url"] {
                                let imageUrl = String(describing: url)
                                
                                Alamofire.request(imageUrl).responseImage { response in
                                    
                                    if let image = response.result.value {
                                        
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
                                                
                                                guard let fcmToken = Messaging.messaging().fcmToken else { return }
                                                
                                                let registeredTyped = "Facebook"
                                                
                                                let profile: Dictionary<String, AnyObject> = ["Type": registeredTyped as AnyObject, "Name": self.name as AnyObject, "Email": self.email as AnyObject, "avatarUrl": downloadedUrl as AnyObject, "Stars": 0 as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "fcmToken": fcmToken as AnyObject, "userUID": userUID as AnyObject]
                                                let matchInfo: Dictionary<String, AnyObject> = ["Type": registeredTyped as AnyObject, "Name": self.name as AnyObject, "avatarUrl": downloadedUrl as AnyObject, "LastTimePlayed": "nil" as AnyObject]
                                                
                                                
                                                
                                                FBProfile = profile
                                                FBmatchInfo = matchInfo
                                                
                                                
                                                SwiftLoader.hide()
                                                self.performSegue(withIdentifier: "GoToFBVC", sender: nil)
                                                
                                            })
                                            
                                            
                                        }

                                    }
                                }
                                
                                
                               
                                
                            }
                            
                        }
                        
                        
                        
                    
                    }
                    
                    
                    
                    
                    
                
                    
                    
                    
                    
                }
                
                
                //self.getFriendList()
            }else{
                print("Error getting user information \(String(describing: error?.localizedDescription))")

                return
            }
            
        })
    
    
    }
    
    
    
    
    
    
   
    
    
    func getFriendList() {
        let params = ["fields": "id, first_name, last_name, name, email, picture"]
        
        let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        connection.add(graphRequest, completionHandler: { (connection, result, error) in
            if error == nil {
                if let userData = result as? [String:Any] {
                    if userData.count <= 1 {
                        print("nil")
                    } else {
                        
                        print(userData)
                        
                        
                    }
                }
            } else {
                print("Error Getting Friends \(String(describing: error))");
                return
            }
            
        })
        
        connection.start()
    }
    
    
    
    
    
    @IBAction func GoogleBtnPressed(_ sender: Any) {
       
        
        
         GIDSignIn.sharedInstance().signIn()
        
    
    }
    
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moveToNewAccountBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "moveToSignUpVC", sender: nil)
        
        
    }
    
    @IBAction func moveToForgetPwdVC(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToForgetPwdVC", sender: nil)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToGoogleSupportVC"{
            if let destination = segue.destination as? GoogleSupportVC{
               destination.name = name
               destination.type = type
               destination.gender = gender
               destination.email = email
               destination.avatarUrl = avatarUrl
            }
        }
        
        if segue.identifier == "moveToGoogleSupportVC2"{
            if let destination = segue.destination as? GoogleSupportVC2{
                destination.name = name
                destination.type = type
                destination.email = email
                destination.avatarUrl = avatarUrl
            }
        }
        
        
        
    }
    
}


