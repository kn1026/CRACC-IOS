//
//  BlackListVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/5/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
// 91, 89

import UIKit
import Firebase
import SCLAlertView
import JDropDownAlert

enum BlackListMode {
    case Request
    case Block
}

class BlackListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var FrMode = BlackListMode.Request
    
    var requestArray = [RequestJoinedModel]()
    var BlockListArray = [blockModel]()
    
    var handleObserve1: UInt!
    var handleObserve2: UInt!
    
    
    
    @IBOutlet weak var requestTableView: UITableView!
    @IBOutlet weak var blockTableView: UITableView!
    @IBOutlet weak var requestToJoinBtn: UIButton!
    @IBOutlet weak var blockListBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //requestTableView.isHidden = false
        blockTableView.isHidden = true
        
        
        requestTableView.delegate = self
        requestTableView.dataSource = self
        
        blockTableView.delegate = self
        blockTableView.dataSource = self
        
        FrMode = BlackListMode.Request
        loadRequestGameView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        
        let RequestUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Game_Request")
        let BlockUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Block_list")
        if handleObserve1 != nil {
            
            RequestUrl.removeObserver(withHandle: handleObserve1)
        }
        if handleObserve2 != nil {
            BlockUrl.removeObserver(withHandle: handleObserve2)
        }
        
        
        BlockListArray.removeAll()
        requestArray.removeAll()
    }
    
    func loadBlockList() {
        
        
        let url = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Block_list")
        
        handleObserve2 = url.queryOrdered(byChild: "BlockTime").queryLimited(toLast: 30).observe( .childAdded, with: { (snapInfo) in
            
            
            if snapInfo.exists() {
                
                if let postDict = snapInfo.value as? Dictionary<String, Any> {
                    
                    
                    let key = snapInfo.key
                    
                    let requestData = blockModel(postKey: key, blockModel: postDict)
                    self.BlockListArray.insert(requestData, at: 0)
                    
                }
                
                self.blockTableView.reloadData()
                
            }
            
        })
        
        
        
    }
    
    
    func loadRequestGameView() {
        
       
        
        
        let time = (Date().timeIntervalSince1970) + (3600 * 3)
        let finalTime = Int64(time * 1000)
        let url = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Game_Request")
        
        handleObserve1 = url.queryOrdered(byChild: "timePlay").queryStarting(atValue: finalTime).observe(.childAdded, with: { (snapInfo) in
            
            
            if snapInfo.exists() {
                
                if let postDict = snapInfo.value as? Dictionary<String, Any> {
                    
                    
                    let key = snapInfo.key
                    
                    let requestData = RequestJoinedModel(postKey: key, RequestJoinedModel: postDict)
                    self.requestArray.insert(requestData, at: 0)
                    
                }
                
            
            
            self.requestTableView.reloadData()
                
                
            }
            
        })
        
        
        
        
        
        
        
    }

    
    
    @IBAction func blockListBtnPressed(_ sender: Any) {
        
        blockListBtn.setTitleColor(UIColor.red, for: .normal)
        requestToJoinBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        blockTableView.isHidden = false
        requestTableView.isHidden = true
        
        FrMode = BlackListMode.Block
        if BlockListArray.isEmpty != true {
            
            blockTableView.reloadData()
            
        } else {
            
            loadBlockList()
        }
       
        
    }
    
    
    @IBAction func requestToJoinBtnPressed(_ sender: Any) {
        
        requestToJoinBtn.setTitleColor(UIColor.red, for: .normal)
        blockListBtn.setTitleColor(UIColor.lightGray, for: .normal)
        
        blockTableView.isHidden = true
        requestTableView.isHidden = false
        FrMode = BlackListMode.Request
        if requestArray.isEmpty != true {
            
            requestTableView.reloadData()
            
        } else {
            
            loadRequestGameView()
            
        }
        
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch FrMode {
        case .Request:
            if requestArray.isEmpty != true {
                
                requestTableView.restore()
                return 1
            } else {
                
                requestTableView.setEmptyMessage("Don't have any request")
                return 1
                
            }
            
        case .Block:
            
            if BlockListArray.isEmpty != true {
                
                blockTableView.restore()
                return 1
                
            }
            
            blockTableView.setEmptyMessage("Currently don't have any blocked friends")
            return 1

    }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FrMode {
        case .Request:
            if requestArray.isEmpty != true {
                return requestArray.count
            } else {
                
                return 0
                
            }
            
        case .Block:
            
            if BlockListArray.isEmpty != true {
                
                
                return BlockListArray.count
                
            } else {
                
                return 0
                
            }
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch FrMode {
        case .Request:
            if tableView == requestTableView {
                
                let item = requestArray[indexPath.row]
                
                
                
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "RequestGameCell", for: indexPath) as? RequestGameCell {
                    
                    
                    if indexPath.row > 0 {
                        
                        let lineFrame = CGRect(x:30, y:0, width: viewWitdh - 62, height: 1)
                        let line = UIView(frame: lineFrame)
                        line.backgroundColor = UIColor.groupTableViewBackground
                        cell.addSubview(line)
                        
                    }
                    
                    
                    cell.acceptBtn.tag = indexPath.row
                    cell.blockBtn.tag = indexPath.row
                    cell.acceptBtn.addTarget(self, action: #selector(BlackListVC.handleAccept), for: .touchUpInside)
                    cell.blockBtn.addTarget(self, action: #selector(BlackListVC.handleBlock), for: .touchUpInside)
                    
                    cell.configureCell(item)
                    
                    
                    
                    
                    
                    
                    return cell
                    
                    
                } else {
                    
                    
                    
                    return UITableViewCell()
                }

                
            } else {
                
                return UITableViewCell()
                
            }
            
        case .Block:
            
            if tableView == blockTableView {
                
                let item = BlockListArray[indexPath.row]
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "BlockCell", for: indexPath) as? BlockCell {
                    
                    
                    if indexPath.row > 0 {
                        
                        let lineFrame = CGRect(x:30, y:0, width: viewWitdh - 62, height: 1)
                        let line = UIView(frame: lineFrame)
                        line.backgroundColor = UIColor.groupTableViewBackground
                        cell.addSubview(line)
                        
                    }
                    
                    
                    cell.UnblockBtn.tag = indexPath.row
                    cell.UnblockBtn.addTarget(self, action: #selector(BlackListVC.handleUnblock), for: .touchUpInside)
                    
                    cell.configureCell(item)
                    
                    
                    
                    
                    
                    
                    return cell
                    
                    
                } else {
                    
                    return UITableViewCell()
                    
                }
                
            } else {
                
                return UITableViewCell()
                
            }
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch FrMode {
        case .Request:
            
            return 91.0
            
        case .Block:
            
            
            return 89.0
        }
    }
    
    
    
    
    @objc func handleBlock(sender: UIButton) {
        
        let item = requestArray[sender.tag]
        
        
        let BlockInformation: Dictionary<String, AnyObject>  = ["BlockName": item.Requestedname as AnyObject, "BlockUID": item.RequesteduserUID as AnyObject, "BlockType": item.Requestedtype as AnyObject , "BlockTime": ServerValue.timestamp() as AnyObject]
        
        
        let url = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Block_list")
        
        
        url.child(item.RequesteduserUID).setValue(BlockInformation)
        DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Game_Request").child(item.RequestedKey).removeValue()
        DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Request").child(item.RequesteduserUID).removeValue()
        
        
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        requestArray.remove(at: (indexPath as NSIndexPath).row)
        requestTableView.deleteRows(at: [indexPath], with: .left)
        
    }
    
     @objc func handleUnblock(sender: UIButton) {
        
        
        let items = BlockListArray[sender.tag]
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        let url = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Block_list")
        
        
        url.child(items.BlockUID).removeValue()
        BlockListArray.remove(at: (indexPath as NSIndexPath).row)
        blockTableView.deleteRows(at: [indexPath], with: .left)
        
    }
    
    
    @objc func handleAccept(sender: UIButton) {
        
        let items = requestArray[sender.tag]
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if let cell = requestTableView.cellForRow(at: indexPath) as? RequestGameCell {
            
                let avatarUrl = cell.avatarUrls
            DataService.instance.GamePostRef.child(items.Requestedcountry).child(items.RequestedGametype).child(items.RequestedGameID).observeSingleEvent(of: .value, with: { (snapInfo) in
                
                
                if snapInfo.exists() {
                    
                    if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                        for item in snap {
                            if let postDict = item.value as? Dictionary<String, Any> {
                                
                                if let numberPeople = postDict["numberOfPeople"] as? String {
                                    
                                    if let countPeople = Int(numberPeople) {
                                        
                                        DataService.instance.GamePostRef.child(items.Requestedcountry).child(items.RequestedGametype).child(items.RequestedGameID).child("Joined_User").observeSingleEvent(of: .value, with: { (snap) in
                                            
                                            if snapInfo.exists() {
                                                
                                                let counter = Int(snap.childrenCount)
                                                
                                                
                                                
                                                if counter < countPeople {
                                                    
                                                    
                                                    
                                                    let CommunityRef = DataService.instance.mainDataBaseRef.child("Community").child(items.RequesteduserUID).childByAutoId()
                                                    let CommunityKey = CommunityRef.key
                                                    
                                                    let info: Dictionary<String, AnyObject> = ["chatKey": items.RequestedchatKey as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "avatarUrl": cell.avatarUrls as AnyObject]
                                                    
                                                    
                                                    let JoinedInformation: Dictionary<String, AnyObject>  = ["Joinedname": items.Requestedname as AnyObject, "JoineduserUID": items.RequesteduserUID as AnyObject, "JoinedTimestamp": ServerValue.timestamp() as AnyObject, "Joinedtype": items.Requestedtype as AnyObject, "JoinedAvatarUrl": avatarUrl as AnyObject]
                                                    
                                                    let chatInformation: Dictionary<String, AnyObject> = ["name":  items.RequestedGameName as AnyObject, "time": items.timePlay as AnyObject, "chatKey": items.RequestedchatKey as AnyObject, "HosterUID": userUID as AnyObject, "isGroup": 1 as AnyObject, "GameID": items.RequestedGameID as AnyObject,"type": items.RequestedGametype as AnyObject, "Country": items.Requestedcountry as AnyObject]
                                                    
                                                    let GameInformation: Dictionary<String, AnyObject> = ["name": items.RequestedGameName as AnyObject, "timePlay": items.timePlay as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": items.RequestedGameID as AnyObject, "type": items.RequestedGametype as AnyObject, "country": items.Requestedcountry as AnyObject, "hosterUID": userUID as AnyObject, "CommunityKey": CommunityKey as AnyObject, "Canceled": 0 as AnyObject, "locationName": items.RequestedlocationName as AnyObject]
                                                    
                                                    let communityInformation: Dictionary<String, AnyObject> = ["name": items.RequestedGameName as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": items.RequestedGameID as AnyObject, "type": items.RequestedGametype as AnyObject, "country": items.Requestedcountry as AnyObject, "TypePost": "Joined" as AnyObject, "CommunityName": items.Requestedname as AnyObject , "CommunityKey": CommunityKey as AnyObject, "CommunityUID": userUID as AnyObject, "CommunityAvatarUrl": avatarUrl as AnyObject]
                                                    
                                                    
                                                    
                                                    let url = DataService.instance.GamePostRef.child(items.Requestedcountry).child(items.RequestedGametype).child(items.RequestedGameID).child("Information").child("Joined_User").child(items.RequesteduserUID)
                                                    
                                                    DataService.instance.mainDataBaseRef.child("User").child(items.Requestedtype).child(items.RequesteduserUID).child("Cached_Game").child(items.RequestedGameID).setValue(GameInformation)
                                                    
                                                    
                                                    let userUrl = DataService.instance.mainDataBaseRef.child("User").child(items.Requestedtype).child(items.RequesteduserUID)
                                                    
                                                    userUrl.child("Chat_List").child(items.RequestedchatKey).setValue(chatInformation)
                                                    
                                                    userUrl.child("Game_Joined").child(items.RequestedGameID).setValue(GameInformation)
                                                    
                                                    
                                                    url.setValue(JoinedInformation)
                                                    
                                                    DataService.instance.GameChatRef.child(items.RequestedchatKey).child("user").child(items.RequesteduserUID).setValue(info)
                                                    
                                                    
                                                    
                                                    let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                                                    let alert = JDropDownAlert()
                                                    CommunityRef.setValue(communityInformation)
                                                    
                                                    alert.alertWith("Successfully Added",
                                                                    topLabelColor: UIColor.white,
                                                                    messageLabelColor: UIColor.white,
                                                                    backgroundColor: color)
                                                    
                                                    DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Game_Request").child(items.RequestedKey).removeValue()
                                                    DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Request").child(items.RequesteduserUID).removeValue()
                                                    
                                                    self.requestArray.remove(at: (indexPath as NSIndexPath).row)
                                                    self.requestTableView.deleteRows(at: [indexPath], with: .left)
                                                    
                                                    
                                                    
                                                } else {
                                                    
                                                    let alert = SCLAlertView()
                                                    
                                                    
                                                    _ = alert.showError("Oops!!!", subTitle: "CRACC: You have enough number of people for this game already")
                                                    
                                                }
                                                
                                                
                                                
                                                
                                                
                                                
                                            } else {
                                               
                                                    let CommunityRef = DataService.instance.mainDataBaseRef.child("Community").child(items.RequesteduserUID).childByAutoId()
                                                    let CommunityKey = CommunityRef.key
                                                    
                                                    
                                                    
                                                    
                                                    let JoinedInformation: Dictionary<String, AnyObject>  = ["Joinedname": items.Requestedname as AnyObject, "JoineduserUID": items.RequesteduserUID as AnyObject, "JoinedTimestamp": ServerValue.timestamp() as AnyObject, "Joinedtype": items.Requestedtype as AnyObject, "JoinedAvatarUrl": avatarUrl as AnyObject]
                                                    
                                                    let chatInformation: Dictionary<String, AnyObject> = ["name":  items.RequestedGameName as AnyObject, "time": items.timePlay as AnyObject, "chatKey": items.RequestedchatKey as AnyObject, "HosterUID": userUID as AnyObject, "isGroup": 1 as AnyObject, "GameID": items.RequestedGameID as AnyObject,"type": items.RequestedGametype as AnyObject, "Country": items.Requestedcountry as AnyObject]
                                                    
                                                    let GameInformation: Dictionary<String, AnyObject> = ["name": items.RequestedGameName as AnyObject, "timePlay": items.timePlay as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": items.RequestedGameID as AnyObject, "type": items.RequestedGametype as AnyObject, "country": items.Requestedcountry as AnyObject, "hosterUID": userUID as AnyObject, "CommunityKey": CommunityKey as AnyObject, "Canceled": 0 as AnyObject, "locationName": items.RequestedlocationName as AnyObject]
                                                    
                                                    let communityInformation: Dictionary<String, AnyObject> = ["name": items.RequestedGameName as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": items.RequestedGameID as AnyObject, "type": items.RequestedGametype as AnyObject, "country": items.Requestedcountry as AnyObject, "TypePost": "Joined" as AnyObject, "CommunityName": items.Requestedname as AnyObject , "CommunityKey": CommunityKey as AnyObject, "CommunityUID": userUID as AnyObject, "CommunityAvatarUrl": avatarUrl as AnyObject]
                                                    
                                                    
                                                    
                                                    let url = DataService.instance.GamePostRef.child(items.Requestedcountry).child(items.RequestedGametype).child(items.RequestedGameID).child("Information").child("Joined_User").child(items.RequesteduserUID)
                                                    
                                                    DataService.instance.mainDataBaseRef.child("User").child(items.Requestedtype).child(items.RequesteduserUID).child("Cached_Game").child(items.RequestedGameID).setValue(GameInformation)
                                                    
                                                    
                                                    let userUrl = DataService.instance.mainDataBaseRef.child("User").child(items.Requestedtype).child(items.RequesteduserUID)
                                                    
                                                    userUrl.child("Chat_List").child(items.RequestedchatKey).setValue(chatInformation)
                                                    
                                                    userUrl.child("Game_Joined").child(items.RequestedGameID).setValue(GameInformation)
                                                    
                                                    
                                                    url.setValue(JoinedInformation)
                                                    
                                                    DataService.instance.GameChatRef.child(items.RequestedchatKey).child("user").child(userUID).setValue(chatInformation)
                                                    
                                                    
                                                    
                                                    let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                                                    let alert = JDropDownAlert()
                                                    CommunityRef.setValue(communityInformation)
                                                    
                                                    alert.alertWith("Successfully Joined",
                                                                    topLabelColor: UIColor.white,
                                                                    messageLabelColor: UIColor.white,
                                                                    backgroundColor: color)
                                                
                                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Game_Request").child(items.RequestedKey).removeValue()
                                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Request").child(items.RequesteduserUID).removeValue()
                                                
                                                
                                                self.requestArray.remove(at: (indexPath as NSIndexPath).row)
                                                self.requestTableView.deleteRows(at: [indexPath], with: .left)
                                                
                                            }
                                            
                                            
                                        })
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        self.requestTableView.reloadData()
                        
                    }
                    
                    
                    
                    
                } else {
                    
                    
                    
                    
                    
                    let alert = SCLAlertView()
                    
                    
                    _ = alert.showError("Oops!!!", subTitle: "CRACC: This game is canceled or expired")
                    
                    
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    
                    
                    self.requestArray.remove(at: (indexPath as NSIndexPath).row)
                    self.requestTableView.deleteRows(at: [indexPath], with: .left)
                    
                }
                
                
            })
            
        }
        
            
            
            
        
        
        
        
    }
    
}
