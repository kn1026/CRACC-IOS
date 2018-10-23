//
//  requestModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 11/6/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation
import UIKit



class requestModel {
    fileprivate var _key: String!
    fileprivate var _VideoUrl: String!
    fileprivate var _numberOfpeople: Int!
    fileprivate var _OwnerUID: String!
    fileprivate var _OwnerName: String!
    fileprivate var _latitude: Double!
    fileprivate var _longtitude: Double!
    fileprivate var _temperature: Int!
    fileprivate var _locationName: String!
    fileprivate var _timePlay: Any!
    fileprivate var _weatherDescription: String!
    fileprivate var _gameName: String!
    
    
    var gameName: String! {
        get {
            if _gameName == nil {
                _gameName = ""
            }
            return _gameName
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
    
    var VideoUrl: String! {
        get {
            if _VideoUrl == nil {
                _VideoUrl = ""
            }
            return _VideoUrl
        }
        
    }
    
    
    var OwnerUID: String! {
        get {
            if _OwnerUID == nil {
                _OwnerUID = ""
            }
            return _OwnerUID
        }
    }
    
    var OwnerName: String! {
        get {
            if _OwnerName == nil {
                _OwnerName = ""
            }
            return _OwnerName
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
    
    var numberOfpeople: Int {
        get {
            if _numberOfpeople == nil {
                _numberOfpeople = 0
            }
            return _numberOfpeople
        }
    }
    var latitude: Double {
        get {
            if _latitude == nil {
                _latitude = 0
            }
            return _latitude
        }
    }
    var longtitude: Double {
        get {
            if _longtitude == nil {
                _longtitude = 0
            }
            return _longtitude
        }
    }
    
    var temperature: Int {
        get {
            if _temperature == nil {
                _temperature = 0
            }
            return _temperature
        }
    }
    
    var weatherDescription: String! {
        get {
            if _weatherDescription == nil {
                _weatherDescription = ""
            }
            return _weatherDescription
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
    
    init(postKey: String, requestGameList: Dictionary<String, Any>) {
        
        
        if let gameName = requestGameList["Nickname"] as? String {
            self._gameName = gameName
            
        }
        if let key = requestGameList["Nickname"] as? String {
            self._key = key
            
        }

        if let VideoUrl = requestGameList["Nickname"] as? String {
            self._VideoUrl = VideoUrl
            
        }

        if let OwnerUID = requestGameList["Nickname"] as? String {
            self._OwnerUID = OwnerUID
            
        }

        if let OwnerName = requestGameList["Nickname"] as? String {
            self._OwnerName = OwnerName
            
        }

        if let timePlay = requestGameList["Nickname"] {
            self._timePlay = timePlay
            
        }

        if let numberOfpeople = requestGameList["Nickname"] as? Int {
            self._numberOfpeople = numberOfpeople
            
        }

        if let latitude = requestGameList["Nickname"] as? Double {
            self._latitude = latitude
            
        }

        if let longtitude = requestGameList["Nickname"] as? Double {
            self._longtitude = longtitude
            
        }

        if let temperature = requestGameList["Nickname"] as? Int {
            self._temperature = temperature
            
        }
        
        if let weatherDescription = requestGameList["Nickname"] as? String {
            self._weatherDescription = weatherDescription
            
        }

        if let locationName = requestGameList["Nickname"] as? String {
            self._gameName = locationName
            
        }

        
    }
    
    
    
    
    
    
    
    
    
    
}
