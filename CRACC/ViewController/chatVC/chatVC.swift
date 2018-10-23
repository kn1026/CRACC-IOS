//
//  chatVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/16/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
// showSelectedImgVC

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import AVFoundation
import FirebaseDatabase
import Firebase
import Cache
import Alamofire

class chatVC: JSQMessagesViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    
    var nameSelected: String?
    var dateSelected: Date!
    
    var image: UIImage!
    var handleObserve: UInt!
    var isGroup: Bool?
    var GroupKey: String?
    var GroupName: String?
    var hosterUID: String?
    var avatarDictionary: [String:UIImage] = [:]
    var userKey = [String]()
    //iconchat
    
    var messages = [JSQMessage]()
    var chatImage = UIImage(named: "send")
    var cameraImg = UIImage(named: "camera icon-chat")
    
    // friendChat
    
    
    var FriendUID: String?
    var FriendName: String?
    var FriendType: String?
    var FriendAvatarUrl: String?
    var isFirstLoad = false
    // groupid
    var groupID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        self.inputToolbar.contentView.rightBarButtonItem.setImage(chatImage, for: .normal)
        self.inputToolbar.contentView.leftBarButtonItem.setImage(cameraImg, for: .normal)
        
        
        // Register nibs
        self.incomingCellIdentifier = MessageViewIncoming.cellReuseIdentifier();
        self.collectionView.register(MessageViewIncoming.nib(), forCellWithReuseIdentifier: self.incomingCellIdentifier)
        self.outgoingCellIdentifier = MessageViewOutgoing.cellReuseIdentifier();
        self.collectionView.register(MessageViewOutgoing.nib(), forCellWithReuseIdentifier: self.outgoingCellIdentifier)
        
        self.incomingMediaCellIdentifier = MessageViewIncoming.mediaCellReuseIdentifier();
        self.collectionView.register(MessageViewIncoming.nib(), forCellWithReuseIdentifier: self.incomingMediaCellIdentifier)
        self.outgoingMediaCellIdentifier = MessageViewOutgoing.mediaCellReuseIdentifier();
        self.collectionView.register(MessageViewOutgoing.nib(), forCellWithReuseIdentifier: self.outgoingMediaCellIdentifier)
        
        
        
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chatVC.dismissKeyboard))
        tapGestureRecognizer.delegate = self 
        self.collectionView?.addGestureRecognizer(tapGestureRecognizer)
        
        self.senderId = userUID
        
        if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
            
            self.senderDisplayName = CachedName
            
        }
        
        automaticallyScrollsToMostRecentMessage = true
        // setup basic thing
        self.inputToolbar.contentView.leftBarButtonItemWidth = CGFloat(35.0)
        self.inputToolbar.contentView.textView.placeHolder = "Let's chat"
        self.inputToolbar.contentView.textView.layer.cornerRadius = self.inputToolbar.contentView.textView.frame.width / 16
        
        self.inputToolbar.contentView.rightBarButtonItem.setTitleColor(UIColor(red: 0.58, green: 0.87, blue: 0.85, alpha: 1.0), for: .normal)
        self.collectionView.backgroundColor = UIColor(red: 242/255, green: 241/255, blue: 241/255, alpha: 1.0)
        // auto scroll
        
        if isGroup == true {
            navigationItem.title = GroupName
        } else {
            navigationItem.title = FriendName
        }
        
        
        // get group id
        
        if isGroup == true {
            observeMessages(FinalKey: GroupKey)
            isGroupSend = true
            keysend = GroupKey!
            downloadUserUID(groupIDChecked: GroupKey) {
                
                self.downloadAvatarImg()
                
            }
        } else {
            
            var MyNickName = ""
            var MyType = ""
            
            if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
                
                
                MyNickName = CachedName!
                
            }
            
            if let CachedType = try? InformationStorage?.object(ofType: String.self, forKey: "type"){
                
                MyType = CachedType!
                
            }
            
            frNotiUID = FriendUID!
            frNotiType = FriendType!
            
            GetGroupIDChecks(userUID, FriendUID: FriendUID!, MyNickName: MyNickName, FriendNickName: FriendName, MyType: MyType, FriendType: FriendType!, FriendAvatarUrl: FriendAvatarUrl)
            
            
            
        }

        
    }
    
    
  
    
    
    
    
    
    func downloadUserUID(groupIDChecked: String?, completed: @escaping DownloadComplete) {
    
        
        if isGroup == true {
            
            DataService.instance.GameChatRef.child(groupIDChecked!).child("user").observeSingleEvent(of: .value, with: { (snapInfo) in
                
                if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        
                        self.userKey.append(item.key)
                    }
                    
                }
                
                completed()
                
            })
            
        } else {
            
            DataService.instance.NormalChatRef.child(groupIDChecked!).child("user").observeSingleEvent(of: .value, with: { (snapInfo) in
                
                if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        
                        self.userKey.append(item.key)
                    }
                    
                }
                
                completed()
                
            })
            
        }
    
        
        
    }
    
    
    func downloadAvatarImg() {
        
        var ModeChatDetected = ""
        var key = ""
        
        if isGroup == true {
            
            ModeChatDetected = "Game_Chat"
            key = GroupKey!
            
            
        } else {
            
            ModeChatDetected = "Personal_Chat"
            key = groupID
            
            
        }
        for userKey in userKey {
            
            if userKey != self.senderId {
                
                print(ModeChatDetected)
                print(key)
                
                DataService.instance.mainDataBaseRef.child(ModeChatDetected).child(key).child("user").child(userKey).observeSingleEvent(of: .value, with: { (snapInfo) in
                    
                    if snapInfo.exists() {
                        
                        if let dict = snapInfo.value as? [String: Any] {
                            let avatarUrl = dict["avatarUrl"] as! String
                            if avatarUrl != "" {
                                let url = avatarUrl
                                
                                if let CacheavatarImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: url).image {
                                    
                                    self.avatarDictionary[userKey] = CacheavatarImg
                                    self.collectionView.reloadData()
                                    
                                } else {
                                    
                                    Alamofire.request(avatarUrl).responseImage { response in
                                        
                                        if let image = response.result.value {
                                            
                                            self.avatarDictionary[userKey] = image
                                            let wrapper = ImageWrapper(image: image)
                                            try? InformationStorage?.setObject(wrapper, forKey: avatarUrl)
                                            self.collectionView.reloadData()
                                            
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                            } else {
                                
                                let avatar = UIImage(named: "CRACC")
                                
                                self.avatarDictionary[userKey] = avatar
                                self.collectionView.reloadData()
                                
                            }
                            
                        }
                        
                    } else {
                        
                        let avatar = UIImage(named: "CRACC")
                        
                        self.avatarDictionary[userKey] = avatar
                        self.collectionView.reloadData()
                        
                        
                    }
                    
                    
                })
                
            }
            
            
            
            
        }
        
    }
    
    func blankAvatar(message: JSQMessage) -> JSQMessageAvatarImageDataSource {
        
        let avatar = UIImage(named: "CRACC")
        
        let AvatarJobs = JSQMessagesAvatarImageFactory.avatarImage(with: avatar, diameter: 30)
        
        return AvatarJobs!
    }
    
    
    @IBAction func goBackFromChatVC(_ sender: Any) {
        
        
        if isGroup == true {
            
            if let key = GroupKey {
                
                
                DataService.instance.GameChatRef.child(key).child("online").child(userUID).setValue(0)
                let messageRef = DataService.instance.GameChatRef.child(key).child("message")
                messageRef.removeObserver(withHandle: handleObserve)
            }
            
        } else {
            
            if let key = groupID {
                DataService.instance.NormalChatRef.child(key).child("online").child(userUID).setValue(0)
                let messageRef = DataService.instance.GameChatRef.child(key).child("message")
                messageRef.removeObserver(withHandle: handleObserve)
                
            }
            
            
        }
        frNotiUID = ""
        frNotiType = ""
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrollToBottom(animated: true)
        
    }
    
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        self.performSegue(withIdentifier: "moveToImgVC", sender: nil)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        if isGroup == true {
            if let key = GroupKey {
                if key != "" {
                    isGroupSend = true
                    keysend = key
                    
                    let messageRef = DataService.instance.GameChatRef.child(key).child("message")
                    
                    let newMessage = messageRef.childByAutoId()
                    let messageData = ["Text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "Text", "timestamp": ServerValue.timestamp()] as [String : Any]
                    
                    self.finishSendingMessage()
                    
                    newMessage.setValue(messageData)
                     DataService.instance.GameChatRef.child(key).child("online").observeSingleEvent(of: .value, with: { (snap) in
                        
                        
                        if let value = snap.value as? Dictionary<String, Int> {
                            
                            value.forEach({ (arg) in
                                
                                
                                let (uid, value) = arg
                                if value == 0 {
                                    
                                    DataService.instance.mainDataBaseRef.child("GroupChatNoti").child(uid).child(key).removeValue()
                                    let values: Dictionary<String, AnyObject>  = [key: 1 as AnyObject]
                                    DataService.instance.mainDataBaseRef.child("GroupChatNoti").child(uid).setValue(values)
                                    
                                    
                                    DataService.instance.mainDataBaseRef.child("User").child(uid).child("NewGrMess").child(keysend).setValue(1)
                                    
                                }
                            })
                            
                        }
                        
                        
                    })
                    
                    
                }
            
            }
   
        } else {
            
            
            if let key = groupID {
                if key != "" {
                    isGroupSend = false
                    keysend = key
                    
                    let messageRef = DataService.instance.NormalChatRef.child(key).child("message")
                   
                    let newMessage = messageRef.childByAutoId()
                    let messageData = ["Text": text, "senderId": senderId, "senderName": senderDisplayName, "MediaType": "Text", "timestamp": ServerValue.timestamp()] as [String : Any]
                    let addChatUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Add_Chat")
                    
                    newMessage.setValue(messageData)
                    addChatUrl.child(FriendUID!).child("time").setValue( ServerValue.timestamp())
                    self.finishSendingMessage()
                    
                    
                    DataService.instance.mainDataBaseRef.child("User").child(self.FriendType!).child(FriendUID!).child("Add_Chat").child(userUID).observeSingleEvent(of: .value, with: { (snapse) in
                        
                        if snapse.exists() {
                            let addChatUrls = DataService.instance.mainDataBaseRef.child("User").child(self.FriendType!).child(self.FriendUID!).child("Add_Chat")
                            addChatUrls.child(userUID).child("time").setValue( ServerValue.timestamp())
                            
                        } else {
                            
                            var MyNickName = ""
                            var MyType = ""
                            var avatarUrl = ""
                            
                            if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
                                
                                
                                MyNickName = CachedName!
                                
                            }
                            
                            if let CachedType = try? InformationStorage?.object(ofType: String.self, forKey: "type"){
                                
                                MyType = CachedType!
                                
                            }
                            
                            if let CachedavatarUrl = try? InformationStorage?.object(ofType: String.self, forKey: "avatarUrl"){
                                
                                
                                
                                avatarUrl = CachedavatarUrl!
                                
                                
                            }
                            
                            let information: Dictionary<String, AnyObject> = ["FrName": MyNickName as AnyObject, "frAvatarUrl": avatarUrl as AnyObject, "FriendType": MyType as AnyObject, "FriendUID": userUID as AnyObject, "isGroup": 0 as AnyObject, "time": ServerValue.timestamp() as AnyObject]
                            
                            
                            DataService.instance.mainDataBaseRef.child("User").child(self.FriendType!).child(self.FriendUID!).child("Add_Chat").child(userUID).setValue(information)
                            
                            
                        }
                        
                        
                    })
                    
                    
                    
                    DataService.instance.NormalChatRef.child(key).child("online").child(FriendUID!).observeSingleEvent(of: .value, with: { (snap) in
                        
                        if let value = snap.value as? Int, value == 1 {
                            print("friend is online")
                        } else {
                            DataService.instance.mainDataBaseRef.child("NormalChatNoti").child(self.FriendUID!).child(userUID).removeValue()
                                let values: Dictionary<String, AnyObject>  = [userUID: 1 as AnyObject]
                            DataService.instance.mainDataBaseRef.child("NormalChatNoti").child(self.FriendUID!).setValue(values)
                            DataService.instance.mainDataBaseRef.child("User").child(self.FriendType!).child(self.FriendUID!).child("NewPsMess").child(userUID).setValue(1)
                        }
                        
                    })
                    
                    
                    
                    
                    
                }
                
            }
            
            
            
        }
        
        
        
    }
   
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor(red: 181/255, green: 224/255, blue: 235/255, alpha: 1.0))
            
        } else {
            
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor(red: 215/255, green: 215/255, blue: 215/255, alpha: 0.9))
            
        }
        
        
        
        
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        let message = messages[indexPath.item]
        
        
        // Sent by me, skip
        if message.senderId == senderId {
            return nil
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
            
        }
        
        if isGroup == true {
            
            if let hoster = hosterUID {
                
                if message.senderId == hoster {
                    let imageAttachment =  NSTextAttachment()
                    imageAttachment.image = UIImage(named: "crown")
                    //Set bound to reposition
                    imageAttachment.bounds = CGRect(x: 0, y: -3, width: 17, height: 17)
                    //Create string with attachment
                    let attachmentString = NSAttributedString(attachment: imageAttachment)
                    let myString = NSMutableAttributedString(string: "")
                    myString.append(NSMutableAttributedString(string:message.senderDisplayName))
                    myString.append(attachmentString)
                    
                    return myString
                    
                    
                    
                    
                }
                
            }
            
            return NSAttributedString(string:message.senderDisplayName)
            
        }
        
      
        return nil
        
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        
        let message = messages[indexPath.item]
        if message.isMediaMessage {
            if let ImgMessage = message.media as? JSQPhotoMediaItem {
                
                self.image = ImgMessage.image
                let time = message.date
                nameSelected = message.senderDisplayName
                dateSelected = time
                
                self.performSegue(withIdentifier: "showSelectedImgVC", sender: nil)
                
                
            }
        }
        
    }
    
    // prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if (segue.identifier == "showSelectedImgVC") {
            let ImageController = segue.destination as? SelectedImgVC
            ImageController?.image = image
            ImageController?.name = nameSelected
            ImageController?.selectedDate = dateSelected
            
        }
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        //return 17.0
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == senderId || isGroup == false {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item]
        let date = message.date
        
        if indexPath.item <= 0 {

            if dayDifference(from: date!) == "Today" {
                
                return NSAttributedString(string: "Today")
                
            } else if dayDifference(from: date!) == "Yesterday" {
                
                return NSAttributedString(string: "Yesterday")
                
            } else {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                let Dateresult = dateFormatter.string(from: date!)
                
                
                return NSAttributedString(string: Dateresult)
                
                
            }
            
            
            
            
        }
        if indexPath.item > 0 {

            
            let previousMessage = messages[indexPath.item - 1]
            
            let date2 = previousMessage.date
            let calendar = Calendar.current
            let components1 =  calendar.dateComponents([.year, .day, .month], from: date!)
            let components2 =  calendar.dateComponents([.year, .day, .month], from: date2!)
            
            if components1.year == components2.year && components1.month == components2.month && components1.day == components2.day {
                
                
                return nil
            } else {
   
                if dayDifference(from: date!) == "Today" {
                    
                    return NSAttributedString(string: "Today")
                    
                } else if dayDifference(from: date!) == "Yesterday" {
                    
                    return NSAttributedString(string: "Yesterday")
                    
                } else {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    let Dateresult = dateFormatter.string(from: date!)
                    
                    
                    return NSAttributedString(string: Dateresult)
                    
                    
                }
            }
            
        } else {
            
            return nil
            
        }
        
        
        
        
        
        
        
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
        
        
        
        let message = messages[indexPath.item]
        let date = message.date
        
        
        
        if indexPath.item == 0 {
    
            
            return 21.0
            
        }
        
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1]
            
            let date2 = previousMessage.date
            let calendar = Calendar.current
            let components1 =  calendar.dateComponents([.year, .day, .month], from: date!)
            let components2 =  calendar.dateComponents([.year, .day, .month], from: date2!)
            
            if components1.year == components2.year && components1.month == components2.month && components1.day == components2.day {
                return CGFloat(0.0);
            } else {
                return 21.0
            }
            
        }
        
      return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let message = messages[indexPath.item]
        let date = message.date
        
        
        
        if message.senderId == self.senderId {
            
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MessageViewOutgoing
            
            
            
            
            if message.isMediaMessage == false {
                cell.textView.textColor = UIColor.black
                cell.isUserInteractionEnabled = true
                cell.messageBubbleImageView.isUserInteractionEnabled = true
                
                
            } else {
                if (message.media as? JSQPhotoMediaItem) != nil {
                    
                    cell.avatarImageView.contentMode = .scaleAspectFill
                }
            }
            
            if indexPath.item == 0 {
                
                
                cell.cellTopLabel.textColor = UIColor.white
                cell.cellTopLabel?.layer.cornerRadius = 13
                //cell.cellTopLabel?.bounds = CGRect(x: (cell.cellTopLabel?.frame.origin.x)!, y: (cell.cellTopLabel?.frame.origin.y)!, width: 100, height: 20)
                cell.cellTopLabel?.backgroundColor = UIColor(red: 153/255, green: 165/255, blue: 165/255, alpha: 1.0)
                
                
            }
            
            
            if indexPath.item > 0 {
                
                cell.cellTopLabel.textColor = UIColor.white
                let previousMessage = messages[indexPath.item - 1]
                
                let date2 = previousMessage.date
                let calendar = Calendar.current
                let components1 =  calendar.dateComponents([.year, .day, .month], from: date!)
                let components2 =  calendar.dateComponents([.year, .day, .month], from: date2!)
                
                if components1.year == components2.year && components1.month == components2.month && components1.day == components2.day {
                    
                    
                    
                } else {
                    cell.cellTopLabel.textColor = UIColor.white
                    cell.cellTopLabel?.layer.cornerRadius = 13
                    cell.cellTopLabel?.backgroundColor = UIColor(red: 153/255, green: 165/255, blue: 165/255, alpha: 1.0)
                    
                }
                
            } else {
                
                
                
            }
            
            
            
            
            
            
            
            
            return cell
            
        } else {
            
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! MessageViewIncoming

            if message.isMediaMessage == false {
                cell.textView.textColor = UIColor.black
                cell.isUserInteractionEnabled = true
                cell.messageBubbleImageView.isUserInteractionEnabled = true
                
                cell.isUserInteractionEnabled = true
                
                
                
                cell.cellTopLabel.textColor = UIColor.white
                
               
            } else {
                if (message.media as? JSQPhotoMediaItem) != nil {
                    
                    cell.avatarImageView.contentMode = .scaleAspectFill
                }
            }
            
            if indexPath.item == 0 {
                
                
                cell.cellTopLabel.textColor = UIColor.white
                cell.cellTopLabel?.layer.cornerRadius = 13
                //cell.cellTopLabel?.bounds = CGRect(x: (cell.cellTopLabel?.frame.origin.x)!, y: (cell.cellTopLabel?.frame.origin.y)!, width: 100, height: 20)
                cell.cellTopLabel?.backgroundColor = UIColor(red: 153/255, green: 165/255, blue: 165/255, alpha: 1.0)
                
                
            }
            
            if indexPath.item > 0 {
                
                cell.cellTopLabel.textColor = UIColor.white
                let previousMessage = messages[indexPath.item - 1]
                
                let date2 = previousMessage.date
                let calendar = Calendar.current
                let components1 =  calendar.dateComponents([.year, .day, .month], from: date!)
                let components2 =  calendar.dateComponents([.year, .day, .month], from: date2!)
                
                if components1.year == components2.year && components1.month == components2.month && components1.day == components2.day {
                    
                    
                    
                } else {
                   
                    cell.cellTopLabel?.layer.cornerRadius = 13
                    //cell.cellTopLabel?.bounds = CGRect(x: (cell.cellTopLabel?.frame.origin.x)!, y: (cell.cellTopLabel?.frame.origin.y)!, width: 100, height: 20)
                    cell.cellTopLabel?.backgroundColor = UIColor(red: 153/255, green: 165/255, blue: 165/255, alpha: 1.0)
                    
                }
                
            } else {
                
                
                
            }
           
            cell.isUserInteractionEnabled = true
            
            
            
            
            
            
            return cell
        }
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId == senderId {
            return nil
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId == message.senderId {
                return nil;
            }
            
        }
        return avatarDictionary[message.senderId] == nil ? blankAvatar(message: message) : JSQMessagesAvatarImageFactory.avatarImage(with: avatarDictionary[message.senderId], diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
        
        
        
        
    }
    
    
    
    
    
    
    
    func observeMessages(FinalKey: String?) {
        
        
        
        var ChatMode = ""
        
        if isGroup == true {
            
            ChatMode = "Game_Chat"
            
            
            DataService.instance.mainDataBaseRef.child(ChatMode).child(FinalKey!).child("online").child(userUID).setValue(1)
            
            DataService.instance.mainDataBaseRef.child("User").child(userUID).child("NewGrMess").child(FinalKey!).setValue(0)
            
        } else {
            ChatMode = "Personal_Chat"

            DataService.instance.mainDataBaseRef.child(ChatMode).child(FinalKey!).child("online").child(userUID).setValue(1)
            
            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("NewPsMess").child(FriendUID!).setValue(0)
            
        }
        if let key = FinalKey {
            let messageRef = DataService.instance.mainDataBaseRef.child(ChatMode).child(key).child("message")
            
            handleObserve = messageRef.queryLimited(toLast: 50).observe(.childAdded, with: { (snapshot) in
                
                if let dict = snapshot.value as? [String: Any] {
                    let mediaType = dict["MediaType"] as! String
                    let senderId = dict["senderId"] as! String
                    let senderName = dict["senderName"] as! String
                    let date =  dict["timestamp"]
                    let time = (date as? TimeInterval)! / 1000
                    let result = Date(timeIntervalSince1970: time)
                    
                    
                    
                    switch mediaType {
                        
                    case "Text":
                        
                        let text = dict["Text"] as! String
                        
                        self.messages.append(JSQMessage(senderId: senderId, senderDisplayName: senderName, date: result, text: text))
                        self.scrollToBottom(animated: true)
                        self.collectionView.reloadData()
                        
                    case "PHOTO":
                        let photo = JSQPhotoMediaItem(image: nil)
                        let fileUrl = dict["fileUrl"] as! String
                        
                        
                        if let CacheavatarImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: fileUrl).image {
                            
                            photo?.image = CacheavatarImg
                            self.scrollToBottom(animated: true)
                            self.collectionView.reloadData()
                            
                        } else {
                            
                            Alamofire.request(fileUrl).responseImage { response in
                                
                               
                                
                                if let image = response.result.value {
                                    
                                    photo?.image = image
                                    let wrapper = ImageWrapper(image: image)
                                    try? InformationStorage?.setObject(wrapper, forKey: fileUrl)
                                    self.scrollToBottom(animated: true)
                                    self.collectionView.reloadData()
                                    
                                    
                                }
                                
                            }
                            
                        }

                        
                        
                        self.messages.append(JSQMessage(senderId: senderId, senderDisplayName: senderName, date: result, media: photo))
                        
                        if self.senderId  == senderId {
                            photo?.appliesMediaViewMaskAsOutgoing = true
                        } else {
                            photo?.appliesMediaViewMaskAsOutgoing = false
                        }
                        
                        
                        
                    case "VIDEO":
                        
                        print("video")
                        
                        
                    default:
                        print("No data Type")
                    }
                    
                    
                    self.scrollToBottom(animated: true)
                    self.collectionView.reloadData()
                }
                
                
            })
            
            
            
            
        }

}
    
    
    // get groupID
    
    func GetGroupIDChecks(_ OwnerUID: String, FriendUID: String, MyNickName: String!, FriendNickName: String!, MyType: String!, FriendType: String!, FriendAvatarUrl: String?) {
        
        if isFirstLoad == false {
            DataService.instance.mainDataBaseRef.child("User").child(FriendType).child(FriendUID).child("Friend_Chat").queryOrdered(byChild: "FriendUID").queryEqual(toValue: OwnerUID).observeSingleEvent(of: .value, with: { (snapCheck) in
                if snapCheck.value is NSNull {
                    
                    DataService.instance.mainDataBaseRef.child("User").child(MyType).child(OwnerUID).child("Friend_Chat").queryOrdered(byChild: "FriendUID").queryEqual(toValue: FriendUID).observeSingleEvent(of: .value, with: { (snapCheckAgain) in
                        
                        if snapCheckAgain.exists() {
                            let snapShot = snapCheckAgain.children.allObjects as! [DataSnapshot]
                            for snap in snapShot {
                                let postDict = snap.value as? Dictionary<String, Any>
                                let groupIDGot = postDict!["GroupID"]
                                self.groupID = groupIDGot as! String?
                                isGroupSend = false
                                keysend = self.groupID
                                self.observeMessages(FinalKey: self.groupID)
                                self.downloadUserUID(groupIDChecked: self.groupID) {
                                    
                                    self.downloadAvatarImg()
                                    
                                }
                                self.isFirstLoad = true
                                
                            }
                            
                            
                        } else {
                            
                            
                            var MyAvatarUrl = ""

                            if let CachedavatarUrl = try? InformationStorage?.object(ofType: String.self, forKey: "avatarUrl"){
                                
                                MyAvatarUrl = CachedavatarUrl!
                                
                            } else {
                                
                                MyAvatarUrl = "nil"
                            }
                            
                            
                            let ref = DataService.instance.mainDataBaseRef.child("Personal_Chat")
                            let childRef = ref.childByAutoId()
                            let UpdateGroupdID =  DataService.instance.mainDataBaseRef.child("User").child(MyType).child(OwnerUID).child("Friend_Chat").child(FriendUID)
                            let GroupIDCheck = childRef.key
                            let MyInfo: Dictionary<String, AnyObject> = ["chatKey": GroupIDCheck as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "avatarUrl": MyAvatarUrl as AnyObject]
                            let FrInfo: Dictionary<String, AnyObject> = ["chatKey": GroupIDCheck as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": FriendUID as AnyObject, "avatarUrl": FriendAvatarUrl as AnyObject]
                            childRef.child("user").child(userUID).setValue(MyInfo)
                            childRef.child("user").child(FriendUID).setValue(FrInfo)
                            
                            
                            self.groupID = GroupIDCheck
                            isGroupSend = false
                            keysend = self.groupID
                            let groupID = ["FriendUID": FriendUID, "GroupID": GroupIDCheck]
                            UpdateGroupdID.updateChildValues(groupID)
                            self.observeMessages(FinalKey: self.groupID)
                            self.downloadUserUID(groupIDChecked: self.groupID) {
                                
                                self.downloadAvatarImg()
                                
                            }
                            self.isFirstLoad = true
                        }
                    })
                } else {
                    
                    let snapShot = snapCheck.children.allObjects as! [DataSnapshot]
                    for snap in snapShot {
                        let postDict = snap.value as? Dictionary<String, Any>
                        let groupIDGot = postDict!["GroupID"]
                        self.groupID = groupIDGot as? String
                        isGroupSend = false
                        keysend = self.groupID
                        self.observeMessages(FinalKey: self.groupID)
                        self.downloadUserUID(groupIDChecked: self.groupID) {
                            
                            self.downloadAvatarImg()
                            
                        }
                        self.isFirstLoad = true
                    }
                    
                }
                
                
            })
            
        }

    }
    
    
    func gestureRecognizer(_: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.collectionView.layoutIfNeeded()
        
        self.view.endEditing(true)
    }
    
    
    func dayDifference(from date : Date) -> String
    {
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
    
    

}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}
