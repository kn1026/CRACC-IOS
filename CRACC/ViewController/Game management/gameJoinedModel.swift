//
//  gameJoinedModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/26/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation


class gameJoinedModel {
    
    
    fileprivate var _country: String!
    fileprivate var _type: String!
    fileprivate var _HosterUID: String!
    fileprivate var _timePlay: Any!
    fileprivate var _gameID: String!
    fileprivate var _locationName: String!
    fileprivate var _hosterUID: String!
    fileprivate var _Canceled: Int!
   
    
    var Canceled: Int! {
        get {
            if _Canceled == nil {
                _Canceled = 0
            }
            return _Canceled
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
    var hosterUID: String! {
        get {
            if _hosterUID == nil {
                _hosterUID = ""
            }
            return _hosterUID
        }
        
    }
    
    var locationName: String! {
        get {
            if _locationName == nil {
                _locationName = ""
            }
            return _locationName
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
    
    
    var gameID: String! {
        get {
            if _gameID == nil {
                _gameID = ""
            }
            return _gameID
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
    
    
    
    init(postKey: String, gameJoinedModel: Dictionary<String, Any>) {
        
        
        
        if let country = gameJoinedModel["country"] as? String {
            self._country = country
            
        }
        if let HosterUID = gameJoinedModel["HosterUID"] as? String {
            self._HosterUID = HosterUID
            
        }
        if let type = gameJoinedModel["type"] as? String {
            self._type = type
            
        }
        if let timePlay = gameJoinedModel["timePlay"] {
            self._timePlay = timePlay
        }
        if let gameID = gameJoinedModel["GameID"] as? String {
            self._gameID = gameID
            
        }
        if let locationName = gameJoinedModel["locationName"] as? String {
            self._locationName = locationName
            
        }
        if let hosterUID = gameJoinedModel["hosterUID"] as? String {
            self._hosterUID = hosterUID
            
        }
        if let Canceled = gameJoinedModel["Canceled"] as? Int {
            self._Canceled = Canceled
            
        }
        
        
        
        
        
    }
    
    
    
    
    
}
