//
//  GameManagementVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/14/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
// TableSectionHeader

import UIKit
import FirebaseAuth
import Firebase

enum tableViewControls  {
    
    case GameManagement
    case RecentlyPlayed
    
    
}


class GameManagementVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var controlTable = tableViewControls.GameManagement
    
    
    
    var gameJoinedArray = [gameJoinedModel]()
    var MyGameArray = [gameJoinedModel]()
    var expGameKeyArr = [ExpGameModel]()
    var finalGameManagementArray = [[gameJoinedModel]]()
    var recentlyPlayer = [RecentlyPlayedModel]()
    
    
    
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recentlyPlayedView: UIView!
    @IBOutlet weak var recentlyPlayedTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard Auth.auth().currentUser != nil else {
            return
        }
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameManagementVC.LoadGameManageMent), name: (NSNotification.Name(rawValue: "openGameManageMent")), object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(GameManagementVC.ResetRecentlyPlay), name: (NSNotification.Name(rawValue: "ResetRecentlyPlay")), object: nil)

        
        tableView.delegate = self
        tableView.dataSource = self
        
        recentlyPlayedTableView.delegate = self
        recentlyPlayedTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.tableView.register(UINib(nibName: "XIBSectionHeader", bundle:nil),
                                forCellReuseIdentifier: "xibheader")
        self.tableView.register(UINib(nibName: "XIBSectionHeader2", bundle:nil),
                                forCellReuseIdentifier: "xibheader2")
    }
    
    
    
    
    @objc func ResetRecentlyPlay() {
        
        getAlreadyPlayedGameID() {
            
            self.getUserInfo()
            
        }
        
        
    }
    
    @objc func LoadGameManageMent() {
    
        controlTable = tableViewControls.GameManagement
        recentlyPlayedView.isHidden = true
        gameJoinedArray.removeAll()
        MyGameArray.removeAll()
        finalGameManagementArray.removeAll()
        expGameKeyArr.removeAll()
        finalGameManagementArray.removeAll()
        recentlyPlayer.removeAll()
        self.tableView.reloadData()
        getGameManageMent() {
        
            self.getMyGame() {
                
                
                
                if self.MyGameArray.isEmpty != true, self.gameJoinedArray.isEmpty != true {
                
                    self.finalGameManagementArray.append(self.gameJoinedArray)
                    self.finalGameManagementArray.insert(self.MyGameArray, at: 0)
                
                } else if self.MyGameArray.isEmpty == true, self.gameJoinedArray.isEmpty != true {
                
                    self.finalGameManagementArray.append(self.gameJoinedArray)
                    
                    
                
                } else if self.MyGameArray.isEmpty != true, self.gameJoinedArray.isEmpty == true {
                
                    self.finalGameManagementArray.append(self.MyGameArray)
                    
                }
                
                
                
                self.tableView.reloadData()
            }
        
        }
        
    
    }
    
    func getGameManageMent(completed: @escaping DownloadComplete) {
    
    
    
        let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
        
        userUrl.child("Game_Joined").queryOrdered(byChild: "timePlay").queryLimited(toLast: 30).observeSingleEvent(of: .value, with: { (snapInfo) in
            
            
            if snapInfo.exists() {
            
                if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            let key = snapInfo.key
                            
                            let requestData = gameJoinedModel(postKey: key, gameJoinedModel: postDict)
                            self.gameJoinedArray.insert(requestData, at: 0)
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                }
                
                completed()
            
            } else {
            
                completed()
            
            }
            
            
            
        })
        
        
        
        
    
    
    
    }
    
    
    func GetRecentlyPlayer() {
        
        recentlyPlayer.removeAll()
        recentlyPlayedTableView.reloadData()
        let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
        
        
        
        
        userUrl.child("Recently_play").queryOrdered(byChild: "JoinedTimestamp").queryLimited(toLast: 30).observeSingleEvent(of: .value, with: { (snapInfos) in
            
            
            
            
            if snapInfos.exists() {
                
                if let snap = snapInfos.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            let key = snapInfos.key
                            
                            let requestData = RecentlyPlayedModel(postKey: key, recentlyPlayedModel: postDict)
                            self.recentlyPlayer.insert(requestData, at: 0)
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    self.recentlyPlayedTableView.reloadData()
                }
                
            } else {
                
                
                
                
            }
            
            
            
        })
        
        
        
    }
    
    
    func getMyGame(completed: @escaping DownloadComplete) {
    
    
        let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)

        userUrl.child("My_Game").queryOrdered(byChild: "timePlay").queryLimited(toLast: 30).observeSingleEvent(of: .value, with: { (snapInfos) in
            
            
            
            
            if snapInfos.exists() {
                
                if let snap = snapInfos.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            let key = snapInfos.key
                            
                            let requestData = gameJoinedModel(postKey: key, gameJoinedModel: postDict)
                            self.MyGameArray.insert(requestData, at: 0)
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    completed()
                }
                
            } else {
            
            
                completed()
            
            
            }
            
            
            
        })
    
    
    
    }
    
    
    @IBAction func closeRecentlyViewBtnPressed(_ sender: Any) {
        
        recentlyPlayedView.isHidden = true
        controlTable = tableViewControls.GameManagement
        tableView.reloadData()
        
    }
    
    @IBAction func closeRecentlyBtnPressed2(_ sender: Any) {
        recentlyPlayedView.isHidden = true
        controlTable = tableViewControls.GameManagement
        tableView.reloadData()
    }
    
    @IBAction func openRecentLyViewBtnPressed(_ sender: Any) {
        
        recentlyPlayedView.isHidden = false
        controlTable = tableViewControls.RecentlyPlayed
        GetRecentlyPlayer()
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    @objc func getAlreadyPlayedGameID(completed: @escaping DownloadComplete) {
        
        
        let time = (Int64(Date().timeIntervalSince1970 * 1000))
        
        
        
        let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
        
        
        userUrl.child("Cached_Game").queryOrdered(byChild: "timePlay").queryEnding(atValue: time).observeSingleEvent(of: .value, with: { (snapInfos) in
            
            
            
            if snapInfos.exists() {
                
                if let snap = snapInfos.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            let key = snapInfos.key
                            
                            
                            let ExpData = ExpGameModel(postKey: key, gameJoinedModel: postDict)
                            self.expGameKeyArr.append(ExpData)
                            userUrl.child("Match_History").child("Game_Played").child("GameCount").childByAutoId().setValue(postDict)
                            userUrl.child("Match_History").child("Game_Played").child(postDict["type"] as! String).childByAutoId().setValue(postDict)
                            userUrl.child("Cached_Game").child(item.key).removeValue()
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                    completed()
                }
                
            } else {
                
                
                
                completed()
                
                
            }
            
            
            
        })
        
        
        
        
    }
    
    func getUserInfo() {
        
        
        
        
        if expGameKeyArr.isEmpty != true {
            
            
            
            for item in expGameKeyArr {
                
                let values: Dictionary<String, AnyObject> = ["LastTimePlayed": item.timeStamp as AnyObject]
                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Match_History").child("Information").updateChildValues(values)
                
                
                let GameUrl = DataService.instance.mainDataBaseRef.child("Game_Post").child(item.country).child(item.type).child(item.gameID)
                
                GameUrl.observeSingleEvent(of: .value, with: { (snapInfos) in

                    if snapInfos.exists() {
                        
                        if let snap = snapInfos.children.allObjects as? [DataSnapshot] {
                            
                            for item in snap {
                                if let postDict = item.value as? Dictionary<String, Any> {
                                    
                                    
                                    if let FriendPlayed = postDict["Joined_User"] as? Dictionary<String, Any> {
                                        
                                        
                                        
                                        for user in FriendPlayed {
                                            
                                            let userDict = user.value as? Dictionary<String, Any>
                                            let key = user.key
                                            
                                            
                                            if key != userUID {
                                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Recently_play").child(key).setValue(userDict)
                                                
                                            }
                                            
                                           
                                            
                                            
                                            
                                            
                                            

                                        }
                                        
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                            }
                            

                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                })
                
                
            }
            
            
            
            
        } else {
            
            
        }
        
        
        
    }
    
    
    
    @objc func handleAddFriend(sender: UIButton) {
        
        
        let item = recentlyPlayer[sender.tag]
        
        
        var MyNickName = ""
        var MyAvatarUrl = ""
        var MyType = ""
        
        
        //let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
        let FrUrl = DataService.instance.mainDataBaseRef.child("User").child(item.JoineduserType).child(item.JoineduserUID)
        
        if (item.JoineduserUID) != nil {
            
            
            if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
                
                
                MyNickName = CachedName!

            }
            
            if let CachedType = try? InformationStorage?.object(ofType: String.self, forKey: "type"){
                
                MyType = CachedType!

            }
            
            if let CachedavatarUrl = try? InformationStorage?.object(ofType: String.self, forKey: "avatarUrl"){

                MyAvatarUrl = CachedavatarUrl!

            } else {
                
                MyAvatarUrl = "nil"
            }
            
            
            
 
            let MyInformation: Dictionary<String, AnyObject>  = ["FriendName": MyNickName as AnyObject, "FriendUID": userUID as AnyObject, "FriendAvatarUrl": MyAvatarUrl as AnyObject , "RecentlyTime": ServerValue.timestamp() as AnyObject, "FriendType": MyType as AnyObject]
            
            let values: Dictionary<String, AnyObject>  = [userUID: 1 as AnyObject]
            
            
            DataService.instance.mainDataBaseRef.child("AddFrNoti").child(item.JoineduserUID).setValue(values)
            
            
            FrUrl.child("Friend_Request").child(userUID).setValue(MyInformation)
            
            sender.isHidden = true
            

            
        } else {
            
            
            showErrorAlert("Opps !!!", msg: "Unable to add \(item.Joinedname) as friend. Please try again.")
            
            
        }
        
        
        
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch controlTable {
            
        case .GameManagement:
            
            if tableView == self.tableView {
                
                
                if finalGameManagementArray.isEmpty != true {
                    
                    
                    tableView.restore()
                    return finalGameManagementArray.count
                    
                } else {
                    
                    tableView.setEmptyMessage("No recently game")
                    return 0
                }
                
                
            }
            return 0
        case .RecentlyPlayed:
            if tableView == self.recentlyPlayedTableView {
                
                if recentlyPlayer.isEmpty != true {
                    
                    tableView.restore()
                    return 1
                } else {
                    
                    tableView.setEmptyMessage("No recently player")
                    return 0
                    
                }
                
                
            }
            return 0

        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch controlTable {
        
        
        case .GameManagement:
            
            if tableView == self.tableView {
                

                
                return finalGameManagementArray[section].count
            }
            return 0
        case .RecentlyPlayed:
            if tableView == self.recentlyPlayedTableView {
                
                return recentlyPlayer.count
            }
            return 0
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        switch controlTable {
            
            
        case .GameManagement:
            
            if tableView == self.tableView {
                
                let item = finalGameManagementArray[indexPath.section][indexPath.row]
                
                if let cell = tableView.dequeueReusableCell(withIdentifier:  "ManageCell", for: indexPath) as? ManageCell {
                    
                    
                    cell.configureCell(item)
                    
                    
                    
                    return cell
                    
                    
                } else {
                    
                    
                    
                    return UITableViewCell()
                }
            }
            
            return UITableViewCell()
            
        case .RecentlyPlayed:
            if tableView == self.recentlyPlayedTableView {
                
                let item = recentlyPlayer[indexPath.row]
                
                if let cell = tableView.dequeueReusableCell(withIdentifier:  "RecentlyPlayedCell", for: indexPath) as? RecentlyPlayedCell {
                    
                    
                    
                    cell.addBtn.tag = indexPath.row
                    cell.addBtn.addTarget(self, action: #selector(GameManagementVC.handleAddFriend), for: .touchUpInside)
                    
                    cell.configureCell(item)
                    
                    
                    
                    
                    
                    
                    return cell
                    
                    
                } else {
                    
                    
                    
                    return UITableViewCell()
                }
            }
            return UITableViewCell()
        }
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        switch controlTable {
            
            
        case .GameManagement:
            
            if tableView == self.tableView {
                
                
                let item = finalGameManagementArray[indexPath.section][indexPath.row]
                
                let currenttime = (Double(Date().timeIntervalSince1970 * 1000))
                
                let getTime = item.timePlay as? Int
                if getTime == 0 {
                    
                    print("Error Occured")
                    
                }
                else if currenttime >= (item.timePlay as? TimeInterval)! {
                    
                    
                    
                    
                    DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Rated_Game").queryOrdered(byChild: "RatedGameKey").queryEqual(toValue: item.gameID).observeSingleEvent(of: .value, with: { (snapCheck) in
                        if snapCheck.value is NSNull {
                            
                            ManagedGameKey = item.gameID
                            ManagedGameType = item.type
                            ManagedGameCountry = item.country
                            ManagehosterUID = item.hosterUID
                            
                            
                            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "DidTapExpGame")), object: nil)
                            
                            
                        } else {
                            
                            ManagedGameKey = item.gameID
                            ManagedGameType = item.type
                            ManagedGameCountry = item.country
                            ManagehosterUID = item.hosterUID
                            
                            
                            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "DidTapManageGame")), object: nil)
                            
                            
                            
                            
                            
                        }
                        
                    })
                
                    
                
                    
                } else {
                    
                    
                    
                    if item.Canceled == 0 {
                        
                        
                        ManagedGameKey = item.gameID
                        ManagedGameType = item.type
                        ManagedGameCountry = item.country
                        ManagehosterUID = item.hosterUID
                        
                        
                        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "DidTapManageGame")), object: nil)
                        
                        
                        
                    }
                    
                    
                   
                    
                    
                    
                }
                

                if let container = self.so_containerViewController {
                    container.isSideViewControllerPresented = false
                }
            }
            
        case .RecentlyPlayed:
            
            
            let item = recentlyPlayer[indexPath.row]
            
            
            InfoUID = item.JoineduserUID
            InfoType = item.JoineduserType
            
            
            
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
            // open player dashboard
            
            if let container = self.so_containerViewController {
                container.isSideViewControllerPresented = false
            }
            
            
            
            
        }

        
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        
        switch controlTable {
            
            
        case .GameManagement:
            
            
            if MyGameArray.isEmpty != true, gameJoinedArray.isEmpty != true {
            
                if section == 0 {
                    
                    return self.tableView.dequeueReusableCell(withIdentifier: "xibheader")
                    
                } else {
                    
                    return self.tableView.dequeueReusableCell(withIdentifier: "xibheader2")
                }
                
                
            } else if self.MyGameArray.isEmpty == true, self.gameJoinedArray.isEmpty != true {
                
                    return self.tableView.dequeueReusableCell(withIdentifier: "xibheader2")
                
                
                
            } else if self.MyGameArray.isEmpty != true, self.gameJoinedArray.isEmpty == true {
                
                return self.tableView.dequeueReusableCell(withIdentifier: "xibheader")
                
            } else {
                
                 return nil
                
            }

            
        case .RecentlyPlayed:
            return UITableViewCell()
            
            
            
            
        }
        

    }


  
 

}
