//
//  RecentlyPlayedModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/7/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation

class RecentlyPlayedModel {
    
    
    fileprivate var _JoinedAvatarUrl: String!
    fileprivate var _Joinedname: String!
    fileprivate var _JoineduserUID: String!
    fileprivate var _JoineduserType: String!
    fileprivate var _JoinedTimestamp: Any!
    
    
    
    
    var JoinedAvatarUrl: String! {
        get {
            if _JoinedAvatarUrl == nil {
                _JoinedAvatarUrl = ""
            }
            return _JoinedAvatarUrl
        }
        
    }
    
    
    var JoinedTimestamp: Any! {
        get {
            if _JoinedTimestamp == nil {
                _JoinedTimestamp = 0
            }
            return _JoinedTimestamp
        }
    }
    
    
    
    
    var Joinedname: String! {
        get {
            if _Joinedname == nil {
                _Joinedname = ""
            }
            return _Joinedname
        }
        
    }
    var JoineduserType: String! {
        get {
            if _JoineduserType == nil {
                _JoineduserType = ""
            }
            return _JoineduserType
        }
        
    }
    
    
    
    var JoineduserUID: String! {
        get {
            if _JoineduserUID == nil {
                _JoineduserUID = ""
            }
            return _JoineduserUID
        }
        
    }
    
    
    
    
    
    init(postKey: String, recentlyPlayedModel: Dictionary<String, Any>) {
        
        
        
        if let JoinedAvatarUrl = recentlyPlayedModel["JoinedAvatarUrl"] as? String {
            self._JoinedAvatarUrl = JoinedAvatarUrl
            
        }
        
        if let Joinedname = recentlyPlayedModel["Joinedname"] as? String {
            self._Joinedname = Joinedname
            
        }
        
        if let JoineduserUID = recentlyPlayedModel["JoineduserUID"] as? String {
            self._JoineduserUID = JoineduserUID
            
        }
        
        
        if let JoinedTimestamp = recentlyPlayedModel["JoinedTimestamp"] {
            self._JoinedTimestamp = JoinedTimestamp
            
        }
        
        if let JoineduserType = recentlyPlayedModel["Joinedtype"] as? String {
            self._JoineduserType = JoineduserType
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
}
