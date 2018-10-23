//
//  CommunityModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/31/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation



class CommunityModel {
    

    
    fileprivate var _CommunityName: String!
    fileprivate var _CommunityUID: String!
    fileprivate var _CommunityAvatarUrl: String!
    fileprivate var _CommunityKey: String!
    fileprivate var _GameID: String!
    fileprivate var _TypePost: String!
    fileprivate var _country: String!
    fileprivate var _name: String!
    fileprivate var _type: String!
    fileprivate var _timestamp: Any!
    fileprivate var _creationDate: Date!
    
    
    
    var hasLiked = false
    var LikeCount: Int?
    
    
    
   
    
    var creationDate: Date! {
        get {
            if _creationDate == nil {
                _creationDate = nil
            }
            return _creationDate
        }
        
    }
    
    
    var CommunityAvatarUrl: String! {
        get {
            if _CommunityAvatarUrl == nil {
                _CommunityAvatarUrl = ""
            }
            return _CommunityAvatarUrl
        }
        
    }
    
    var CommunityUID: String! {
        get {
            if _CommunityUID == nil {
                _CommunityUID = ""
            }
            return _CommunityUID
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
    
    var CommunityKey: String! {
        get {
            if _CommunityKey == nil {
                _CommunityKey = ""
            }
            return _CommunityKey
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
    var TypePost: String! {
        get {
            if _TypePost == nil {
                _TypePost = ""
            }
            return _TypePost
        }
        
    }
    var country: String! {
        get {
            if _country == nil {
                _country = ""
            }
            return _country
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
    
    
    var timestamp: Any! {
        get {
            if _timestamp == nil {
                _timestamp = 0
            }
            return _timestamp
        }
    }
    
    
    
    
    var CommunityName: String! {
        get {
            if _CommunityName == nil {
                _CommunityName = ""
            }
            return _CommunityName
        }
        
    }
    
    
    
    
    
    
    init(postKey: String, CommunityModel: Dictionary<String, Any>) {
        
        if let type = CommunityModel["type"] as? String {
            self._type = type
            
        }
        if let CommunityKey = CommunityModel["CommunityKey"] as? String {
            self._CommunityKey = CommunityKey
            
        }
        if let CommunityUID = CommunityModel["CommunityUID"] as? String {
            self._CommunityUID = CommunityUID
            
        }
        if let GameID = CommunityModel["GameID"] as? String {
            self._GameID = GameID
            
        }
        if let TypePost = CommunityModel["TypePost"] as? String {
            self._TypePost = TypePost
            
        }
        if let country = CommunityModel["country"] as? String {
            self._country = country
            
        }
        
        if let CommunityName = CommunityModel["CommunityName"] as? String {
            self._CommunityName = CommunityName
            
        }
        
        if let name = CommunityModel["name"] as? String {
            self._name = name
            
        }
        
        if let CommunityAvatarUrl = CommunityModel["CommunityAvatarUrl"] as? String {
            self._CommunityAvatarUrl = CommunityAvatarUrl
            
        }
        
        if let timestamp = CommunityModel["timestamp"] {
            self._timestamp = timestamp
            let time = timestamp as? Double ?? 0
            self._creationDate = Date(timeIntervalSince1970: time)
            
            
        }
        
        
        
        
    }
    
    
    
    
    
}
