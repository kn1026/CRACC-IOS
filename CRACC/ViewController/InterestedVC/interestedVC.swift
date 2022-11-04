//
//  interestedVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/16/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase
import MGSwipeTableCell



enum FriendMode {
    case FriendList
    case FriendRequest
    case FriendAdd
}

class interestedVC: UIViewController, UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, MGSwipeTableCellDelegate{
    
    
    var handleObserve: UInt!
    var FrMode = FriendMode.FriendList
    var requestFrArray = [FriendModel]()
    var FriendListArray = [FriendModel]()
    var FriendAddedArray = [FriendAddModel]()
    var filterList = [FriendModel]()
    var uidArr = [String]()
    
    
    var frUID: String?
    var frName: String?
    var frType: String?
    var frAvatarUrl: String?
    var isGroup = false
    var insearchMode = false
    
    
    
    var isFriendList = true
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var chooseGameModeView: UIView!
    
    @IBOutlet weak var friendRequestImg: UIImageView!
    @IBOutlet weak var friendListImg: UIImageView!
    @IBOutlet weak var friendRequestBtn: UIButton!
    @IBOutlet weak var friendListBtn: UIButton!
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var addFriendTableView: UITableView!
    
    var tapGesture: UITapGestureRecognizer!
    var GameRequestGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var searchBar: ModiferFriendSearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var RequestTablevIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "XIBSectionHeader3", bundle:nil),
                                forCellReuseIdentifier: "xibheader3")
        self.RequestTablevIew.register(UINib(nibName: "XIBSectionHeader4", bundle:nil),
                                forCellReuseIdentifier: "xibheader4")
        
        NotificationCenter.default.addObserver(self, selector: #selector(interestedVC.openChooseFriendView), name: (NSNotification.Name(rawValue: "openChooseFriendView")), object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action:#selector(interestedVC.closeKeyboard))
        GameRequestGesture = UITapGestureRecognizer(target: self, action:#selector(interestedVC.closeGameChooseView))
        
        searchBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        RequestTablevIew.delegate = self
        RequestTablevIew.dataSource = self
        
        addFriendTableView.delegate = self
        addFriendTableView.dataSource = self
        
        
        FrMode = FriendMode.FriendList
        SetContentAllignmenttoBtn()
        
        getFrList()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
        let FriendListtUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")
        
        FriendListtUrl.removeObserver(withHandle: handleObserve)
    }
    
    @objc func openChooseFriendView() {
        
        
        self.view.addGestureRecognizer(GameRequestGesture)
        chooseGameModeView.isHidden = false
        SetContentAllignmenttoBtn()
        blurrVC()
        
    }
    
    func SetContentAllignmenttoBtn() {
        
        friendListBtn.contentHorizontalAlignment = .left
        friendRequestBtn.contentHorizontalAlignment = .left
        
    }
    
    func blurrVC() {
       
        blurView.isHidden = false
        blurView.backgroundColor = UIColor.darkGray
        blurView.alpha = 0.5
    
        
        
        view.endEditing(true)
    }
    @objc func closeGameChooseView() {
        
        chooseGameModeView.isHidden = true
        undoVC()
        self.view.removeGestureRecognizer(GameRequestGesture)
        
    }
    func undoVC() {
        
        blurView.backgroundColor = UIColor.clear
        blurView.alpha = 1.0
        blurView.isHidden = true
        
    }
    
    
    
    @objc func closeKeyboard() {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        self.view.endEditing(true)
        self.searchBar.text = ""
        self.searchBar.frame.size.width = 78
        

        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        switch FrMode {
        case .FriendList:
            if FriendListArray.isEmpty != true {
                
                tableView.restore()
                return 1
            } else {
                
                tableView.setEmptyMessage("Don't have any friends")
                return 1
                
            }
            
        case .FriendRequest:
            
            if requestFrArray.isEmpty != true {
                
                RequestTablevIew.restore()
                return 1
                
            }
            
            RequestTablevIew.setEmptyMessage("Currently don't have any friend request")
            return 1
        
        case .FriendAdd:
            
            if FriendAddedArray.isEmpty != true {
                
                addFriendTableView.restore()
                return 1
                
            }
            
            addFriendTableView.setEmptyMessage("Not Found")
            return 1
   
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FrMode {
        case .FriendList:
           
            
            
            if insearchMode {
                return filterList.count
            } else {
                return FriendListArray.count
                
            }
            
        case .FriendRequest:
            if insearchMode {
                return filterList.count
            } else {
                return requestFrArray.count
            }
        case .FriendAdd:
            if FriendAddedArray.isEmpty != true {
                
                return 1
                
            } else {
                
                return 0
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch FrMode {
        case .FriendList:
            if tableView == self.tableView{
                
                
                if FriendListArray.isEmpty != true {
                    

                    
                    let item: FriendModel
                    
                    if insearchMode {
                        item = filterList[indexPath.row]
                    } else {
                        item = FriendListArray[indexPath.row]
                    }
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier:  "FriendListCell", for: indexPath) as? FriendListCell {
                        
                        cell.delegate = self
                        
                        cell.configureCell(item)
                        
                        return cell
                        
                        
                    } else {
                        
                        
                        
                        return UITableViewCell()
                    }
                    
                } else {
                    
                    return UITableViewCell()
                    
                }
                
                
            }
        case .FriendRequest:
            if tableView == self.RequestTablevIew{
                
                let item: FriendModel
                
                if insearchMode {
                    item = filterList[indexPath.row]
                } else {
                    item = requestFrArray[indexPath.row]
                }
                
                if let cell = tableView.dequeueReusableCell(withIdentifier:  "FriendRequestCell", for: indexPath) as? FriendRequestCell {
                    
                   
                    
                    cell.acceptBtn.tag = indexPath.row
                    cell.ignoreBtn.tag = indexPath.row
                    cell.acceptBtn.addTarget(self, action: #selector(interestedVC.handleAcceptFriend), for: .touchUpInside)
                    cell.ignoreBtn.addTarget(self, action: #selector(interestedVC.handleIgnoreFriend), for: .touchUpInside)
                    
                    
                    cell.configureCell(item)
                    
                    
                    
                    return cell
                    
                    
                } else {
                    
                    
                    
                    return UITableViewCell()
                }
            }
            
        case .FriendAdd:
            if tableView == self.addFriendTableView{
                
                let item: FriendAddModel
                item = FriendAddedArray[indexPath.row]
                
                if let cell = tableView.dequeueReusableCell(withIdentifier:  "FriendAddCell", for: indexPath) as? FriendAddCell {
                    
                    
                    
                    cell.addBtn.tag = indexPath.row
                    cell.addBtn.addTarget(self, action: #selector(interestedVC.handleAddFriend), for: .touchUpInside)
                    
                    
                    
                    cell.configureCell(item)
                    
                    
                    
                    return cell
                    
                    
                } else {
                    
                    
                    
                    return UITableViewCell()
                }
            }
            
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch FrMode {
        case .FriendList:
            
            let item = FriendListArray[indexPath.row]
            
            InfoUID = item.FruserUID
            InfoType = item.FrType

            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
            
            self.dismiss(animated: true, completion: nil)
            
            
        case .FriendRequest:
            let item = requestFrArray[indexPath.row]
            
            InfoUID = item.FruserUID
            InfoType = item.FrType
            
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
            
            self.dismiss(animated: true, completion: nil)
            
        case .FriendAdd:
            
            let item = FriendAddedArray[indexPath.row]
            
            InfoUID = item.FruserUID
            InfoType = item.FrType
            
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
            
            self.dismiss(animated: true, completion: nil)
            
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        
        switch FrMode {
        case .FriendList:
            return self.tableView.dequeueReusableCell(withIdentifier: "xibheader3")
        case .FriendRequest:
            return self.RequestTablevIew.dequeueReusableCell(withIdentifier: "xibheader4")
        case .FriendAdd:
            return nil
            
        }
           
    }
    
    // swipe table view
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        swipeSettings.transition = MGSwipeTransition.border;
        expansionSettings.buttonIndex = 0
        let Deletedcolor = UIColor.init(red:1.0, green:59/255.0, blue:50/255.0, alpha:1.0)
        let padding = 15
        if direction == MGSwipeDirection.leftToRight {
            
            return nil
            
            
        } else {
            expansionSettings.fillOnTrigger = true;
            expansionSettings.threshold = 1.1
            
            
            let delete = MGSwipeButton(title: "Unfriend", backgroundColor: Deletedcolor, padding: padding,  callback: { (cell) -> Bool in
                
                
                self.deleteAtIndexPath(self.tableView.indexPath(for: cell)!)
                
                return false; //don't autohide to improve delete animation
            });
            
            
            
            
            return [delete]
        }
        
        
        
        
    }
    
    
    func deleteAtIndexPath(_ path: IndexPath) {
        
        var item: FriendModel!
        
        if insearchMode {
            item = filterList[path.row]
        } else {
            item = FriendListArray[path.row]
        }
        
        
        
        if item.Frname != "" {
            
            let mytUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")
            let frtUrl = DataService.instance.mainDataBaseRef.child("User").child(item.FrType).child(item.FruserUID).child("Friend_List")
            
            
            mytUrl.child(item.FruserUID).removeValue()
            frtUrl.child(userUID).removeValue()
            
            
        }
        
        
        if insearchMode {
            filterList.remove(at: (path as NSIndexPath).row)
            tableView.deleteRows(at: [path], with: .left)
        } else {
            FriendListArray.remove(at: (path as NSIndexPath).row)
            tableView.deleteRows(at: [path], with: .left)
        }
        
        
        
    }
    
    // prepare for segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "goToChatVC2") {
            
            let navigationView = segue.destination as! UINavigationController
            let ChatController = navigationView.topViewController as? chatVC
            
            ChatController?.isGroup = isGroup
            ChatController?.FriendUID = frUID
            ChatController?.FriendName = frName
            ChatController?.FriendType = frType
            ChatController?.FriendAvatarUrl = frAvatarUrl
       
            
            
            
        }
    }
    
    @objc func handleAddFriend(sender: UIButton) {
        
        let item = FriendAddedArray[sender.tag]
        
        
        
        
        if let Frname = item.Frname, let FrUID = item.FruserUID, let avatarUrl = item.FrAvatarUrl, let FrType = item.FrType {
            
            var MyNickName = ""
            var MyAvatarUrl = ""
            var MyType = ""
            
            let FrUrl = DataService.instance.mainDataBaseRef.child("User").child(FrType).child(FrUID).child("Friend_List")
            let MyUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")
            
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
            
            let FriendInformation: Dictionary<String, AnyObject>  = ["FriendName": Frname as AnyObject, "FriendUID": FrUID as AnyObject, "FriendAvatarUrl": avatarUrl as AnyObject, "FriendType": FrType as AnyObject , "RecentlyTime": ServerValue.timestamp() as AnyObject]
            let MyInformation: Dictionary<String, AnyObject>  = ["FriendName": MyNickName as AnyObject, "FriendUID": userUID as AnyObject, "FriendAvatarUrl": MyAvatarUrl as AnyObject, "FriendType": MyType as AnyObject , "RecentlyTime": ServerValue.timestamp() as AnyObject]
            
            
            
           
            
            
            
            
            if sender.titleLabel?.text == "+Add" {
                
            DataService.instance.mainDataBaseRef.child("User").child(FrType).child(FrUID).child("Friend_Request").child(userUID).setValue(MyInformation)
                
                let values: Dictionary<String, AnyObject>  = [userUID: 1 as AnyObject]
                
                
                DataService.instance.mainDataBaseRef.child("AddFrNoti").child(FrUID).setValue(values)
                
                sender.isHidden = true
                
            } else if sender.titleLabel?.text == "Accept"  {
                
                
                MyUrl.child(item.FruserUID).setValue(FriendInformation)
                FrUrl.child(userUID).setValue(MyInformation)
                
                let values: Dictionary<String, AnyObject>  = [userUID: 1 as AnyObject]
                DataService.instance.mainDataBaseRef.child("ConfirmedFrNoti").child(FrUID).setValue(values)
                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Request").child(item.FruserUID).removeValue()
                DataService.instance.mainDataBaseRef.child("User").child(FrType).child(FrUID).child("Friend_Request").child(item.FruserUID).removeValue()
                sender.isHidden = true
                
                
            } else {
                
                showErrorAlert("Oopps !!!", msg: "CRACC: Error occured, please try again")
                
            }
            
           
            
            
            
        }
        
        
    }
    
    
    @objc func handleAcceptFriend(sender: UIButton) {
        
        
        
        let MyUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")

        
        let item = requestFrArray[sender.tag]
        
        
        
        if let Frname = item.Frname, let FrUID = item.FruserUID, let avatarUrl = item.FrAvatarUrl, let FrType = item.FrType {

            let indexPath = IndexPath(row: sender.tag, section: 0)
            
            let FrUrl = DataService.instance.mainDataBaseRef.child("User").child(FrType).child(FrUID).child("Friend_List")
            
            if let cell = RequestTablevIew.cellForRow(at: indexPath) as? FriendRequestCell {
                
                
                var MyNickName = ""
                var MyAvatarUrl = ""
                var MyType = ""
                
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
                
                
                let FriendInformation: Dictionary<String, AnyObject>  = ["FriendName": Frname as AnyObject, "FriendUID": FrUID as AnyObject, "FriendAvatarUrl": avatarUrl as AnyObject, "FriendType": FrType as AnyObject , "RecentlyTime": ServerValue.timestamp() as AnyObject]
                let MyInformation: Dictionary<String, AnyObject>  = ["FriendName": MyNickName as AnyObject, "FriendUID": userUID as AnyObject, "FriendAvatarUrl": MyAvatarUrl as AnyObject, "FriendType": MyType as AnyObject , "RecentlyTime": ServerValue.timestamp() as AnyObject]
                
                let values: Dictionary<String, AnyObject>  = [userUID: 1 as AnyObject]
                DataService.instance.mainDataBaseRef.child("ConfirmedFrNoti").child(FrUID).setValue(values)
                
                MyUrl.child(item.FruserUID).setValue(FriendInformation)
                FrUrl.child(userUID).setValue(MyInformation)
              DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Request").child(item.FruserUID).removeValue()
                
                cell.hideButton()
                
                
            }
            
        } else {
            
            
            showErrorAlert("Opps !!!", msg: "CRACC: Can't add friend right now. Please try again later")
            
            
        }
        
        
        

    }
    
    @objc func handleIgnoreFriend(sender: UIButton) {
        

        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        
        if let cell = RequestTablevIew.cellForRow(at: indexPath) as? FriendRequestCell {
            
            
            
            let item = requestFrArray[sender.tag]
            
            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Request").child(item.FruserUID).removeValue()
            
                cell.hideButton()
        }
        
        
        
        
       
    
        
        
    }
    
    
    
    @IBAction func friendRequestBtnPressed(_ sender: Any) {
        
        
        
        isFriendList = false
        friendRequestImg.isHidden = false
        friendListImg.isHidden = true
        chooseGameModeView.isHidden = true
        undoVC()
        RequestTablevIew.isHidden = false
        FrMode = FriendMode.FriendRequest
        getFrRequest()
    }
    
    
    
    @IBAction func friendListBtnPressed(_ sender: Any) {
        
        
        
        isFriendList = true
        friendRequestImg.isHidden = true
        friendListImg.isHidden = false
        chooseGameModeView.isHidden = true
        undoVC()
        RequestTablevIew.isHidden = true
        FrMode = FriendMode.FriendList
        getFrList()
        
    }
    
    
    func getFrList() {
        
        
        FriendListArray.removeAll()
        tableView.reloadData()
        
        
        
        
        let FriendListtUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")
        
        handleObserve = FriendListtUrl.queryOrdered(byChild: "timePlay").observe(.childAdded, with: { (FriendList) in
            
            if FriendList.exists() {
                
                
                
                if let postDict = FriendList.value as? Dictionary<String, Any> {
                    
                    let key = FriendList.key
                    let FrData = FriendModel(postKey: key, FriendModel: postDict)
                    self.FriendListArray.insert(FrData, at: 0)
                    
                    
                }
                
                self.tableView.reloadData()
                
                
                
                
            } else {
                
                
                
                
            }
            
            
        })
        
        
        
    }
    
    
    
    func getFrRequest() {
        
        
        requestFrArray.removeAll()
        RequestTablevIew.reloadData()
        
        let RequestUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Request")
        
        
        
        RequestUrl.queryOrdered(byChild: "timePlay").observeSingleEvent(of: .value, with: { (RequestRecent) in
            
            if RequestRecent.exists() {
                
                if let snap = RequestRecent.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            let key = RequestRecent.key
                            let FrData = FriendModel(postKey: key, FriendModel: postDict)
                            self.requestFrArray.insert(FrData, at: 0)
                            
                            
                        }
                        

                        
                    }
                    
                    self.RequestTablevIew.reloadData()
                   
                }
                
                
                
                
            } else {
                
                
                
                
            }
            
            
        })
        
        
        
        
    }
    

    @IBAction func backToMainVCBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backToMainVCBtn2Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    // search bar
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        self.FriendAddedArray.removeAll()
        self.searchBar.frame.size.width = self.view.frame.size.width - 4
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.frame.size.width = 78
        insearchMode = false
        self.addFriendTableView.isHidden = true
        self.FriendAddedArray.removeAll()
        self.addFriendTableView.reloadData()
        
        
        
        if isFriendList == true {
            
            
            friendRequestImg.isHidden = true
            friendListImg.isHidden = false
            chooseGameModeView.isHidden = true
            undoVC()
            RequestTablevIew.isHidden = true
            FrMode = FriendMode.FriendList
            
            
        } else {
            
            friendRequestImg.isHidden = false
            friendListImg.isHidden = true
            chooseGameModeView.isHidden = true
            undoVC()
            RequestTablevIew.isHidden = false
            FrMode = FriendMode.FriendRequest
            
            
        }
    }
  
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        insearchMode = false
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        
        if searchBar.text == nil || searchBar.text == "" {
            
            insearchMode = false
            tableView.reloadData()
            
        }
            
        else {
            
            
            insearchMode = true
            if isFriendList == true {
                
                filterList = FriendListArray.filter({$0.Frname.range(of: searchText) != nil })
                
                if filterList.isEmpty != true {
                    
                    tableView.reloadData()
                    
                } else {
                    
                    
                    self.addFriendTableView.isHidden = false
                    searchForNewFriend(friendNickName: searchText, isFriendList: true)
                    
                }
                
                
            } else {
                
                filterList = requestFrArray.filter({$0.Frname.range(of: searchText) != nil })
                
                if filterList.isEmpty != true {
                    
                    RequestTablevIew.reloadData()
                    
                } else {
                    
                    
                    self.addFriendTableView.isHidden = false
                    searchForNewFriend(friendNickName: searchText, isFriendList: false)
                    
                }
   
            }
           
            
        }
        
    }
    
    func searchForNewFriend(friendNickName: String, isFriendList: Bool) {
        
        
        if isFriendList == true {
            
           let RequestUrl = DataService.instance.nickNameDataRef.child(friendNickName)
            
            
            RequestUrl.observeSingleEvent(of: .value, with: { (snapshot) in
                
              
                if snapshot.exists() {
                    
                    self.FriendAddedArray.removeAll()
                    
                    
                    if let snap = snapshot.value as? Dictionary<String, AnyObject> {
                        
                        if let uid = snap["userUID"] as? String {
                            
                            if uid != userUID {
                                
                                let key = snapshot.key
                                let FrData = FriendAddModel(postKey: key, AddFriendModel: snap)
                                self.FriendAddedArray.insert(FrData, at: 0)
                                
                            }
                            
                            
                            self.addFriendTableView.isHidden = false
                            self.FrMode = FriendMode.FriendAdd
                            self.addFriendTableView.reloadData()
                            
                        } else {
                            
                            print("its you")
                        }
                        
                        
                    }
                    
                    
                    
                } else {
                    
                    print("not found")
                    
                }
                
            })
            
        } else {
            
            
            let RequestUrl = DataService.instance.nickNameDataRef.child(friendNickName)
            let FriendListtUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")
            
            
            RequestUrl.observeSingleEvent(of: .value, with: { (snapshot) in
                
                
                if snapshot.exists() {
                    
                    self.FriendAddedArray.removeAll()
                    
                    
                    if let snap = snapshot.value as? Dictionary<String, AnyObject> {
                        
                        if let uid = snap["userUID"] as? String {
                            
                            if uid != userUID {
                                
                                FriendListtUrl.child(uid).observeSingleEvent(of: .value, with: { (snapFr) in
                                    
                                    
                                    if snapFr.exists() {
                                        
                                        self.showErrorAlert("Opps !!!", msg: "This user has already been in your friend list" )
                                        
                                    } else {
                                        
                                        
                                        let key = snapshot.key
                                        let FrData = FriendAddModel(postKey: key, AddFriendModel: snap)
                                        self.FriendAddedArray.insert(FrData, at: 0)
                                        
                                        
                                        
                                        self.addFriendTableView.isHidden = false
                                        self.FrMode = FriendMode.FriendAdd
                                        self.addFriendTableView.reloadData()
                                        
                                    }
                                    
                                    
                                })
                                
                                
                            } else {
                                
                                print("its you")
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    
                } else {
                    
                    print("not found")
                    
                }
                
            })
            
        }
        
        
    }
    
}
