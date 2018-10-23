//
//  CommunityVC.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/2/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase



class CommunityVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var community = [CommunityModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        tableView.delegate = self
        tableView.dataSource = self
        viewWitdh = Double(self.view.frame.width)
        
        fetchAllPosts()
        
    }
    
    
    
    
 
    fileprivate func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    

    
    
    
    fileprivate func fetchPosts() {
        guard ((Auth.auth().currentUser?.uid) != nil) else { return }
        
        self.fetchPostsWithUser(UID: userUID)
        
    }
 
    
    fileprivate func fetchPostsWithUser(UID: String?) {
        let ref = DataService.instance.mainDataBaseRef.child("Community").child(UID!)
        ref.queryLimited(toLast: 100).observeSingleEvent(of: .value, with: { (snapshot) in
 
            if let snap = snapshot.children.allObjects as? [DataSnapshot] {
                
                for item in snap {
                    if let postDict = item.value as? Dictionary<String, Any> {
                        
                        let communityKey = postDict["CommunityKey"] as? String
                        let post = CommunityModel(postKey: snapshot.key, CommunityModel: postDict)
                        DataService.instance.mainDataBaseRef.child("Likes").child(communityKey!).child(userUID).observeSingleEvent(of: .value, with: { (snap) in
                            
                            if let value = snap.value as? Int, value == 1 {
                                post.hasLiked = true
                            } else {
                                post.hasLiked = false
                            }

                            
                            self.community.append(post)
                            self.community.sort(by: { (p1, p2) -> Bool in
                                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
                            })
                            self.tableView.reloadData()
                        
                            
                        })
                        
                    }
            
                    
                }
  
                
            }
            
            
            
            
        }) { (err) in
            print("Failed to fetch posts:", err)
        }
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return community.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView{
            
            let item: CommunityModel
            
            item = community[indexPath.row]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier:  "CommunityCell", for: indexPath) as? CommunityCell {
                
                if indexPath.row > 0 {
                    
                    let lineFrame = CGRect(x:30, y:0, width: viewWitdh - 62, height: 1)
                    let line = UIView(frame: lineFrame)
                    line.backgroundColor = UIColor.groupTableViewBackground
                    cell.addSubview(line)
                    
                }
                
                cell.LikeBtn.tag = indexPath.row
                cell.LikeBtn.addTarget(self, action: #selector(CommunityVC.handleLike), for: .touchUpInside)
                
                
                
                cell.configureCell(item)
                
                
                
                return cell
                
                
            } else {
                
                
                
                return CommunityCell()
            }
            
            
        } else {
            
            return UITableViewCell()
            
        }
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    @objc func handleLike(sender: UIButton) {
    
        
        
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let item = community[sender.tag]
        
        guard let itemId = item.CommunityKey else { return }
        let values = [userUID: item.hasLiked == true ? 0 : 1]
        
        
        
        DataService.instance.mainDataBaseRef.child("Likes").child(itemId).updateChildValues(values) { (err, _) in
            
            if let err = err {
                print("Failed to like post:", err)
                return
            }
            
            print("Successfully liked post.")
            
            item.hasLiked = !item.hasLiked
            
            self.community[indexPath.item] = item
            
            self.tableView?.reloadRows(at: [indexPath], with: .automatic)
            
        }
        
        
        if item.hasLiked == true {
            
            DataService.instance.mainDataBaseRef.child("LikesCount").child(itemId).child(userUID).removeValue()
            DataService.instance.mainDataBaseRef.child("LikesNoti").child(item.CommunityUID).child(userUID).removeValue()
            
        } else {
            
            
            
            DataService.instance.mainDataBaseRef.child("LikesCount").child(itemId).updateChildValues(values) { (err, _) in
                
                if let err = err {
                    print("Failed to like post:", err)
                    return
                }
                
            }
            if item.CommunityUID != userUID {
                
                DataService.instance.mainDataBaseRef.child("LikesNoti").child(item.CommunityUID).child(userUID).removeValue()
                DataService.instance.mainDataBaseRef.child("LikesNoti").child(item.CommunityUID).updateChildValues(values) { (err, _) in
                    
                    if let err = err {
                        print("Failed to like post:", err)
                        return
                    }
                    
                }
                
            }
            

        }
        
        
        
    
        
    }
    
    
    
    fileprivate func fetchFollowingUserIds() {
        guard ((Auth.auth().currentUser?.uid) != nil) else { return }
        
        let FriendListtUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")
        
        FriendListtUrl.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            
            userIdsDictionary.forEach({ (arg) in
                
                let key = arg.key
                
                self.fetchPostsWithUser(UID: key)
            })
            
        }) { (err) in
            print("Failed to fetch following user ids:", err)
        }
        
    }
    
    
    

    @IBAction func goBackToManVCBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    @IBAction func GoBackToMainVCBtnPressed2(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
