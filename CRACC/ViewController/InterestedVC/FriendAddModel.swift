//
//  FriendAddModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/24/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation

class FriendAddModel {
    
    
    fileprivate var _FrAvatarUrl: String!
    fileprivate var _Frname: String!
    fileprivate var _FruserUID: String!
    fileprivate var _FrTimestamp: Any!
    fileprivate var _FrType: String!
    
    
    
    
    var FrAvatarUrl: String! {
        get {
            if _FrAvatarUrl == nil {
                _FrAvatarUrl = ""
            }
            return _FrAvatarUrl
        }
        
    }
    
    var FrType: String! {
        get {
            if _FrType == nil {
                _FrType = ""
            }
            return _FrType
        }
        
    }
    
    
    var FrTimestamp: Any! {
        get {
            if _FrTimestamp == nil {
                _FrTimestamp = 0
            }
            return _FrTimestamp
        }
    }
    
    
    
    
    var Frname: String! {
        get {
            if _Frname == nil {
                _Frname = ""
            }
            return _Frname
        }
        
    }
    
    
    
    var FruserUID: String! {
        get {
            if _FruserUID == nil {
                _FruserUID = ""
            }
            return _FruserUID
        }
        
    }
    
    
    
    
    
    init(postKey: String, AddFriendModel: Dictionary<String, Any>) {
        
        
        
        if let FrAvatarUrl = AddFriendModel["avatarUrl"] as? String {
            self._FrAvatarUrl = FrAvatarUrl
            
        }
        
        if let Frname = AddFriendModel["nickname"] as? String {
            self._Frname = Frname
            
        }
        
        if let FruserUID = AddFriendModel["userUID"] as? String {
            self._FruserUID = FruserUID
            
        }
        
        if let FrTimestamp = AddFriendModel["Timestamp"] {
            self._FrTimestamp = FrTimestamp
            
        }
        
        if let FrType = AddFriendModel["Type"] as? String {
            self._FrType = FrType
            
        }
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
}
