//
//  chatModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/14/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation

class chatModel {
    
    
    fileprivate var _Country: String!
    fileprivate var _GameID: String!
    
    fileprivate var _name: String!
    fileprivate var _type: String!
    fileprivate var _HosterUID: String!
    fileprivate var _timePlay: Any!
    fileprivate var _key: String!
    
    fileprivate var _FrAvatarUrl: String!
    fileprivate var _Frname: String!
    fileprivate var _FruserUID: String!
    fileprivate var _FrTimestamp: Any!
    fileprivate var _FrType: String!
    
    fileprivate var _isGroup: Int!
    
    
    var Country: String! {
        get {
            if _Country == nil {
                _Country = ""
            }
            return _Country
        }
        
    }
    
    var GameID: String! {
        get {
            if _GameID == nil {
                _GameID = ""
            }
            return _GameID
        }
        
    }

    
    var isGroup: Int! {
        get {
            if _isGroup == nil {
                _isGroup = 0
            }
            return _isGroup
        }
        
    }
    
    
    var name: String! {
        get {
            if _name == nil {
                _name = ""
            }
            return _name
        }
        
    }
    
    
    var type: String! {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
        
    }
    
    var HosterUID: String! {
        get {
            if _HosterUID == nil {
                _HosterUID = ""
            }
            return _HosterUID
        }
    }
    

    var key: String! {
        get {
            if _key == nil {
                _key = ""
            }
            return _key
        }
        
    }
    
    var timePlay: Any! {
        get {
            if _timePlay == nil {
                _timePlay = 0
            }
            return _timePlay
        }
    }
    
    //
    
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
    
    
    
    
    
    init(postKey: String, ChatList: Dictionary<String, Any>) {
        
       
        
        if let name = ChatList["name"] as? String {
            self._name = name
            
        }
        if let HosterUID = ChatList["HosterUID"] as? String {
            self._HosterUID = HosterUID
            
        }
        if let type = ChatList["type"] as? String {
            self._type = type
            
        }
        if let timePlay = ChatList["time"] {
            self._timePlay = timePlay
        }
        if let key = ChatList["chatKey"] as? String {
            self._key = key
            
        }
        //
        
        if let FrAvatarUrl = ChatList["frAvatarUrl"] as? String {
            self._FrAvatarUrl = FrAvatarUrl
            
        }
        
        if let Frname = ChatList["FrName"] as? String {
            self._Frname = Frname
            
        }
        
        if let FrType = ChatList["FriendType"] as? String {
            self._FrType = FrType
            
        }
        
        if let FruserUID = ChatList["FriendUID"] as? String {
            self._FruserUID = FruserUID
            
        }
        
        if let FrTimestamp = ChatList["time"] {
            self._FrTimestamp = FrTimestamp
            
        }
        
        if let isGroup = ChatList["isGroup"] as? Int {
            self._isGroup = isGroup
            
        }
        
        if let GameID = ChatList["GameID"] as? String {
            self._GameID = GameID
            
        }
        if let Country = ChatList["Country"] as? String {
            self._Country = Country
            
        }
        
        
        
        
    }
    
    
    
    
    
}
