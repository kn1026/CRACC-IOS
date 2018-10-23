//
//  TakePhotoCameraVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/10/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import CameraManager
import Cache
import Alamofire
import Firebase
import AVKit

class TakePhotoCameraVC: UIViewController,UIGestureRecognizerDelegate {

    @IBOutlet weak var takenImgView: UIImageView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var selectedImgView: UIView!
    
    @IBOutlet weak var changeSCreenBtn: UIButton!
    @IBOutlet weak var backBtn: FancyBtn!
    @IBOutlet weak var photoBtn: UIButton!
    
    var renderedImg: UIImage!
    
    // load first orientation
    
    var focusView: UIView?
    var orientation = "back"
    var focusRecognizer: UITapGestureRecognizer!
    let cameraManager = CameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        takenImgView.contentMode = .scaleAspectFill
        // Do any additional setup after loading the view.
        orientation = "back"
        
        // ask for permission camera user
        cameraManager.showAccessPermissionPopupAutomatically = true
        // set default output
        cameraManager.cameraOutputMode = .stillImage
        
        
        // check camera condition and use
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        
        if currentCameraState == .notDetermined {
            
            askForPermission()
            
        } else {
            addCameraToView()
        }
        
        cameraManager.flashMode = .off
        
        
        focusRecognizer = UITapGestureRecognizer(target: self, action:#selector(TakePhotoCameraVC.focused(_:)))
        focusRecognizer.delegate = self
        self.focusView =  UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
        self.cameraView.addGestureRecognizer(self.focusRecognizer)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // stop camera session
        cameraManager.stopCaptureSession()
    }
    
    
    fileprivate func addCameraToView()
        
        
    {
        
        cameraManager.cameraDevice = .back
        
        
        // camera camera view
        _ = cameraManager.addPreviewLayerToView(cameraView)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // ask for permission for the first time
    
    fileprivate func askForPermission() {
        cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                self.addCameraToView()
            }
        })
    }
    
    @objc func focused(_ recognizer: UITapGestureRecognizer) {
        
        let point = recognizer.location(in: cameraView)
        let viewsize = self.cameraView.bounds.size
        let newPoint = CGPoint(x: point.y/viewsize.height, y: 1.0-point.x/viewsize.width)
        
        
        
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do {
            
            try device?.lockForConfiguration()
            
        } catch _ {
            
            return
        }
        
        if device?.isFocusModeSupported(AVCaptureDevice.FocusMode.autoFocus) == true {
            
            device?.focusMode = AVCaptureDevice.FocusMode.autoFocus
            device?.focusPointOfInterest = newPoint
        }
        
        if device?.isExposureModeSupported(AVCaptureDevice.ExposureMode.continuousAutoExposure) == true {
            
            device?.exposureMode = AVCaptureDevice.ExposureMode.continuousAutoExposure
            device?.exposurePointOfInterest = newPoint
        }
        
        device?.unlockForConfiguration()
        
        self.focusView?.alpha = 0.0
        self.focusView?.center = point
        self.focusView?.backgroundColor = UIColor.clear
        self.focusView?.layer.borderColor = UIColor.white.cgColor
        self.focusView?.layer.borderWidth = 1.0
        self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        self.cameraView.addSubview(self.focusView!)
        
        
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 3.0, options: UIView.AnimationOptions.curveEaseIn, // UIViewAnimationOptions.BeginFromCurrentState
            animations: {
                self.focusView!.alpha = 1.0
                self.focusView!.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {(finished) in
            self.focusView!.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.focusView!.removeFromSuperview()
        })
    }
    
    @IBAction func dismiss1BtnPressed(_ sender: Any) {
        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "dismiss")), object: nil)
    }
    
    @IBAction func dismiss2BtnPressed(_ sender: Any) {
        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "dismiss")), object: nil)
    }
    
   
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        
        self.cameraManager.resumeCaptureSession()
        // remove gesture recognizer
        self.cameraView.addGestureRecognizer(self.focusRecognizer)
        // turn on imageView
        
        
        //self.imageView.image = capturedImg
        self.cameraView.isHidden = false
        self.selectedImgView.isHidden = true
        
        // hidden things
        self.changeSCreenBtn.isHidden = false
        self.backBtn.isHidden = false
        self.photoBtn.isHidden = false
        
         NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "enableScroll")), object: nil)
        
        
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.cameraManager.resumeCaptureSession()
        // remove gesture recognizer
        self.cameraView.addGestureRecognizer(self.focusRecognizer)
        // turn on imageView
        
        
        //self.imageView.image = capturedImg
        self.cameraView.isHidden = false
        self.selectedImgView.isHidden = true
        
        // hidden things
        self.changeSCreenBtn.isHidden = false
        self.backBtn.isHidden = false
        self.photoBtn.isHidden = false
        
         NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "enableScroll")), object: nil)
        
        
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        if renderedImg != nil {
            
            if let image = renderedImg {
                
                if keysend != "" {
                    
                    
                    let data = image.jpegData(compressionQuality: 1.0)
                    let imageUID = UUID().uuidString
                    let metaData = StorageMetadata()
                    metaData.contentType = "image/jpeg"
                    
                    NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "dismiss")), object: nil)
                    
                    
                    DataService.instance.ChatImageStorageRef.child(imageUID).putData(data!, metadata: metaData) { (metaData, err) in
                        
                        
                        if err != nil {
                            print(err?.localizedDescription as Any)
                            return
                        }
                        
                        DataService.instance.ChatImageStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                            
                            guard let Url = url?.absoluteString else { return }
                            
                            let downUrl = Url as String
                            let downloadUrl = downUrl as NSString
                            let downloadedUrl = downloadUrl as String
                            
                            
                            
                            let fileUrl = downloadedUrl
                            
                            
                            if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
                                if isGroupSend == true {
                                    if keysend != "" {
                                        
                                        let messageRef = DataService.instance.GameChatRef.child(keysend).child("message")
                                        let newMessage = messageRef.childByAutoId()
                                        let messageData = ["fileUrl": fileUrl as Any, "senderId": userUID, "senderName": CachedName as Any,"MediaType": "PHOTO", "timestamp": ServerValue.timestamp()] as [String : Any]
                                        newMessage.setValue(messageData)
                                        
                                        
                                        DataService.instance.GameChatRef.child(keysend).child("online").observeSingleEvent(of: .value, with: { (snap) in
                                            
                                            
                                            if let value = snap.value as? Dictionary<String, Int> {
                                                
                                                value.forEach({ (arg) in
                                                    
                                                    
                                                    let (uid, value) = arg
                                                    if value == 0 {
                                                        
                                                        DataService.instance.mainDataBaseRef.child("GroupChatNoti").child(uid).child(keysend).removeValue()
                                                        let values: Dictionary<String, AnyObject>  = [keysend: 1 as AnyObject]
                                                        DataService.instance.mainDataBaseRef.child("GroupChatNoti").child(uid).setValue(values)
                                                        DataService.instance.mainDataBaseRef.child("User").child(uid).child("NewGrMess").child(keysend).setValue(1)
                                                        
                                                    }
                                                })
                                                
                                            }
                                            
                                            
                                        })
                                        
                                    } else {
                                        
                                        self.showErrorAlert("Oopps !!!", msg: "Cannot send the image, the reason may caused by internet connection, please try again")
                                    }
                                    
                                    
                                    
                                    
                                } else {
                                    
                                    
                                    if keysend != "" {
                                        
                                        let messageRef = DataService.instance.NormalChatRef.child(keysend).child("message")
                                        let newMessage = messageRef.childByAutoId()
                                        let messageData = ["fileUrl": fileUrl, "senderId": userUID, "senderName": CachedName as Any,"MediaType": "PHOTO", "timestamp": ServerValue.timestamp()] as [String : Any]
                                        newMessage.setValue(messageData)
                                        
                                        
                                        if frNotiUID != "" {
                                            
                                            
                                            DataService.instance.NormalChatRef.child(keysend).child("online").child(frNotiUID).observeSingleEvent(of: .value, with: { (snap) in
                                                
                                                if let value = snap.value as? Int, value == 1 {
                                                    print("friend is online")
                                                } else {
                                                    DataService.instance.mainDataBaseRef.child("NormalChatNoti").child(frNotiUID).child(userUID).removeValue()
                                                    let values: Dictionary<String, AnyObject>  = [userUID: 1 as AnyObject]
                                                    DataService.instance.mainDataBaseRef.child("NormalChatNoti").child(frNotiUID).setValue(values)
                                                    DataService.instance.mainDataBaseRef.child("User").child(frNotiType).child(frNotiUID).child("NewPsMess").child(userUID).setValue(1)
                                                }
                                                
                                            })
                                            
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                            
                        })
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                } else {
                    
                    self.showErrorAlert("Oopps !!!", msg: "CRACC: Cannot send the image, the reason may caused by your internet connection, please check and try again later")
                    
                }
                
                
                
                
                
                
                
            }
            
            
        }
    }
    
    
    @IBAction func changeScreenBtnPressed(_ sender: Any) {
        
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
        switch (cameraManager.cameraDevice) {
        case .front:
            print("front")
            orientation = "front"
        case .back:
            print("back")
            orientation = "back"
        }
        
    }
    
    
    @IBAction func takePhotoBtnPressed(_ sender: Any) {
        
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.cameraOutputQuality = .high
        
        
        cameraManager.capturePictureWithCompletion({ (image, error) in
            
            
            
            if error != nil {
                self.cameraManager.showErrorBlock("Error Occured", (error?.localizedDescription)!)
            } else {
                if let capturedImg = image {
                    // stop camera
                    self.cameraManager.stopCaptureSession()
                    // remove gesture recognizer
                    self.cameraView.removeGestureRecognizer(self.focusRecognizer)
                    // turn on imageView
                    
                    if self.orientation == "back" {
                        self.takenImgView.image = capturedImg
                    } else {
                        self.renderedImg = capturedImg.flippedHorizontally
                        self.takenImgView.image = self.renderedImg
                        
                    }
                    
                    //self.imageView.image = capturedImg
                    self.cameraView.isHidden = true
                    self.selectedImgView.isHidden = false
                    
                    // hidden things
                    self.changeSCreenBtn.isHidden = true
                    self.backBtn.isHidden = true
                    self.photoBtn.isHidden = true
                    // take screenShot
                    self.renderedImg = self.captureScreen()
                    // set image back to screened image
                    self.takenImgView.image = self.renderedImg
                    
                    NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "disableScroll")), object: nil)
                    
                }
            }
            
            
            
            
            
            
        })
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    // take screenshot
    
    func captureScreen() -> UIImage  {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //renderedImg = image
        return image!
        
    }
    
}

// flip img
public extension UIImage {
    var flippedHorizontally: UIImage {
        return UIImage(cgImage: self.cgImage!, scale: self.scale, orientation: .leftMirrored)
    }
}
