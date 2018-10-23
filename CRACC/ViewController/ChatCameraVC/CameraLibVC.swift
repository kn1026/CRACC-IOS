//
//  CameraLibVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/10/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import UIKit
import Photos
import FirebaseStorage
import Firebase
import Cache
import Firebase

class CameraLibVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var selectedImg: UIImageView!
    @IBOutlet weak var selectedImgView: UIView!
    var photos:[PHAsset]!
    var assets = [PHAsset]()
    private let imageLoader = FAImageLoader()
    
    var picture: UIImage?
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
        checkForPhotosPermission()
        
        
    }
    
    
    private func loadPhotos(){
        
        imageLoader.loadPhotos { (assets) in
            self.configureImageCropper(assets: assets)
        }
    }
    
    private func configureImageCropper(assets:[PHAsset]){
        
        if assets.count != 0{
            photos = assets
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.reloadData()
            
        }
    }

    
    private func checkForPhotosPermission(){
        
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            //loadPhotos()
            fetchPhotos()
        }
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                
                if (newStatus == PHAuthorizationStatus.authorized) {
                    
                    DispatchQueue.main.async {
                        self.fetchPhotos()
                    }
                }
                else {
                    // Access has been denied.
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
   
    
    fileprivate func fetchPhotos() {
        let requestOptions = PHImageRequestOptions()
        
        // May slow down loading of images
        // Other options: .fastFormat | .opportunistic
        requestOptions.deliveryMode = .highQualityFormat
        
        let fetchOptions = PHFetchOptions()
        
        // This is for if you want the most recent image taken to be at the top of the UICollectionView
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        
        // Returns all PHAssets (images, videos) from the options you specified
        let fetchAllResults: PHFetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        if fetchAllResults.count > 0 {
            
            for i in 0..<fetchAllResults.count {
                
                assets.append(fetchAllResults.object(at: i) )
                
                
            }
            
        }
        
        collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 3) - 1
        return CGSize(width: width, height: width)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell {
            
            cell.populateDataWith(asset: assets[indexPath.item])
            
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = IndexPath(row: indexPath.row, section: 0)
        
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell {
            
            
            self.collectionView.isHidden = true
            self.collectionView.isUserInteractionEnabled = false
            let img = cell.selectedImg
            picture = img
            selectedImg.image = img
            selectedImg.contentMode = .scaleAspectFit
            selectedImgView.isHidden = false
            
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "disableScroll")), object: nil)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        
        if picture != nil {
            
            if let image = picture {
                
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
                            
                        
                       
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: downloadedUrl)
                        
                        if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
                            if isGroupSend == true {
                                if keysend != "" {
                                    
                                    let messageRef = DataService.instance.GameChatRef.child(keysend).child("message")
                                    let newMessage = messageRef.childByAutoId()
                                    let messageData = ["fileUrl": downloadedUrl, "senderId": userUID, "senderName": CachedName as Any,"MediaType": "PHOTO", "timestamp": ServerValue.timestamp()] as [String : Any]
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
                                    let messageData = ["fileUrl": downloadedUrl, "senderId": userUID, "senderName": CachedName as Any,"MediaType": "PHOTO", "timestamp": ServerValue.timestamp()] as [String : Any]
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
                        
                        /*
                        let Url = metaData?.downloadURL()?.absoluteString
                        let downUrl = Url! as String
 
 */
                        
                        
                        
                        
                        
                    }

                    
                } else {
                    
                    self.showErrorAlert("Oopps !!!", msg: "CRACC: Cannot send the image, the reason may caused by your internet connection, please check and try again later")
                    
                }
                
                
                
            
            
            
            
        }
        
        
        }
    }
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func backBtnPressed1(_ sender: Any) {
        
        self.collectionView.isHidden = false
        self.collectionView.isUserInteractionEnabled = true
        selectedImgView.isHidden = true
        
        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "enableScroll")), object: nil)
    }
    @IBAction func backBtnPressed2(_ sender: Any) {
        
        self.collectionView.isHidden = false
        self.collectionView.isUserInteractionEnabled = true
        selectedImgView.isHidden = true
        
        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "enableScroll")), object: nil)
    }
        
        
        
}
