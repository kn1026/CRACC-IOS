//
//  RequestJoinedModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/6/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation


class RequestJoinedModel {
    
    
    
    
    
    fileprivate var _RequestedlocationName: String!
    fileprivate var _RequesteduserUID: String!
    fileprivate var _RequestedGameID: String!
    fileprivate var _RequestedGameName: String!
    fileprivate var _RequestedGametype: String!
    fileprivate var _RequestedTimestamp: Any!
    fileprivate var _RequestedchatKey: String!
    fileprivate var _Requestedcountry: String!
    fileprivate var _Requestedname: String!
    fileprivate var _Requestedtype: String!
    fileprivate var _RequestedKey: String!
    fileprivate var _RequestNumberOfPeople: String!
    fileprivate var _timePlay: Any!
    
    
    
    
    
    var RequestedlocationName: String! {
        get {
            if _RequestedlocationName == nil {
                _RequestedlocationName = ""
            }
            return _RequestedlocationName
        }
        
    }
    
    var RequestNumberOfPeople: String! {
        get {
            if _RequestNumberOfPeople == nil {
                _RequestNumberOfPeople = ""
            }
            return _RequestNumberOfPeople
        }
        
    }
    
    var RequestedKey: String! {
        get {
            if _RequestedKey == nil {
                _RequestedKey = ""
            }
            return _RequestedKey
        }
        
    }

    
    var Requestedcountry: String! {
        get {
            if _Requestedcountry == nil {
                _Requestedcountry = ""
            }
            return _Requestedcountry
        }
        
    }
    var RequesteduserUID: String! {
        get {
            if _RequesteduserUID == nil {
                _RequesteduserUID = ""
            }
            return _RequesteduserUID
        }
        
    }
    
    var RequestedGameID: String! {
        get {
            if _RequestedGameID == nil {
                _RequestedGameID = ""
            }
            return _RequestedGameID
        }
        
    }
    
    
    
    var RequestedGameName: String! {
        get {
            if _RequestedGameName == nil {
                _RequestedGameName = ""
            }
            return _RequestedGameName
        }
        
    }
    
    var RequestedGametype: String! {
        get {
            if _RequestedGametype == nil {
                _RequestedGametype = ""
            }
            return _RequestedGametype
        }
    }
    
    
    var RequestedchatKey: String! {
        get {
            if _RequestedchatKey == nil {
                _RequestedchatKey = ""
            }
            return _RequestedchatKey
        }
        
    }
    
    var RequestedTimestamp: Any! {
        get {
            if _RequestedTimestamp == nil {
                _RequestedTimestamp = 0
            }
            return _RequestedTimestamp
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
    
    var Requestedname: String! {
        get {
            if _Requestedname == nil {
                _Requestedname = ""
            }
            return _Requestedname
        }
        
    }
    
    var Requestedtype: String! {
        get {
            if _Requestedtype == nil {
                _Requestedtype = ""
            }
            return _Requestedtype
        }
        
    }
    
    
    
    
    
    
    init(postKey: String, RequestJoinedModel: Dictionary<String, Any>) {
        
        
        
        if let Requestedcountry = RequestJoinedModel["Requestedcountry"] as? String {
            self._Requestedcountry = Requestedcountry
            
        }
        if let RequesteduserUID = RequestJoinedModel["RequesteduserUID"] as? String {
            self._RequesteduserUID = RequesteduserUID
            
        }
        if let RequestedGameID = RequestJoinedModel["RequestedGameID"] as? String {
            self._RequestedGameID = RequestedGameID
            
        }
        if let RequestedGameName = RequestJoinedModel["RequestedGameName"] as? String {
            self._RequestedGameName = RequestedGameName
            
        }
        if let RequestedGametype = RequestJoinedModel["RequestedGametype"] as? String {
            self._RequestedGametype = RequestedGametype
            
        }
        if let RequestedchatKey = RequestJoinedModel["RequestedchatKey"] as? String {
            self._RequestedchatKey = RequestedchatKey
            
        }
        if let Requestedname = RequestJoinedModel["Requestedname"] as? String {
            self._Requestedname = Requestedname
            
        }
        if let Requestedtype = RequestJoinedModel["Requestedtype"] as? String {
            self._Requestedtype = Requestedtype
            
        }
        if let RequestedTimestamp = RequestJoinedModel["RequestedTimestamp"] {
            self._RequestedTimestamp = RequestedTimestamp
            
        }
        if let timePlay = RequestJoinedModel["timePlay"] {
            self._timePlay = timePlay
            
        }
        
    
        if let RequestedKey = RequestJoinedModel["RequestedKey"] as? String {
            self._RequestedKey = RequestedKey
            
        }
        
        if let RequestNumberOfPeople = RequestJoinedModel["RequestNumberOfPeople"] as? String {
            self._RequestNumberOfPeople = RequestNumberOfPeople
            
        }
        
        
        if let RequestedlocationName = RequestJoinedModel["RequestedlocationName"] as? String {
            self._RequestedlocationName = RequestedlocationName
            
        }
        
       
    }
    
    
    
    
    
}
