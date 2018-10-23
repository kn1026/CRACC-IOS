//
//  ExpGameModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/7/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation


class ExpGameModel {
    
    
    fileprivate var _country: String!
    fileprivate var _type: String!
    fileprivate var _gameID: String!
    fileprivate var _timeStamp: Any!
    
    
    
    
    
    
    var timeStamp: Any! {
        get {
            if _timeStamp == nil {
                _timeStamp = 0
            }
            return _timeStamp
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
  
    
    
    
    var type: String! {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
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
    
    
    
    
    
    init(postKey: String, gameJoinedModel: Dictionary<String, Any>) {
        
        
        
        if let country = gameJoinedModel["country"] as? String {
            self._country = country
            
        }
        
        if let type = gameJoinedModel["type"] as? String {
            self._type = type
            
        }
        
        if let gameID = gameJoinedModel["GameID"] as? String {
            self._gameID = gameID
            
            
        }
        
        if let timeStamp = gameJoinedModel["timePlay"]  {
            self._timeStamp = timeStamp
            
            
        }
        
        
        
        
        
        
    }
    
    
    
    
    
}
