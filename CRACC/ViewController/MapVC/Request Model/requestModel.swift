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
    fileprivate var _HosterType: String!
    
    fileprivate var _VideoUrl: String!
    fileprivate var _numberOfpeople: String!
    fileprivate var _OwnerUID: String!
    fileprivate var _OwnerName: String!
    fileprivate var _latitude: Double!
    fileprivate var _longtitude: Double!
    fileprivate var _temperature: Int!
    fileprivate var _highTemp: Int!
    fileprivate var _lowTemp: Int!
    fileprivate var _locationName: String!
    fileprivate var _timePlay: Any!
    fileprivate var _weatherDescription: String!
    fileprivate var _gameName: String!
    fileprivate var _type: String!
    fileprivate var _avatarUrl: String!
    fileprivate var _DescriptionWeather: String!
    fileprivate var _chatKey: String!
    fileprivate var _CommunityKey: String!
    fileprivate var _country: String!
    fileprivate var _JoinedUserArray: [Dictionary<String, AnyObject>]!
    
    //CommunityKey
    
    
    var HosterType: String! {
        get {
            if _HosterType == nil {
                _HosterType = ""
            }
            return _HosterType
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
    
    var type: String! {
        get {
            if _type == nil {
                _type = ""
            }
            return _type
        }
        
    }
    
    var JoinedUserArray: [Dictionary<String, AnyObject>]! {
        
        
        get {
        
            if _JoinedUserArray == nil {
                _JoinedUserArray = []
            }
            return _JoinedUserArray
        
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
    
    var chatKey: String! {
        get {
            if _chatKey == nil {
                _chatKey = ""
            }
            return _chatKey
        }
        
    }
    
    var DescriptionWeather: String! {
        get {
            if _DescriptionWeather == nil {
                _DescriptionWeather = ""
            }
            return _DescriptionWeather
        }
        
    }
    
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
                _VideoUrl = "nil"
            }
            return _VideoUrl
        }
        
    }
    
    
    var avatarUrl: String! {
        get {
            if _avatarUrl == nil {
                _avatarUrl = "nil"
            }
            return _avatarUrl
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
    
    var numberOfpeople: String {
        get {
            if _numberOfpeople == nil {
                _numberOfpeople = "0"
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
    var highTemp: Int {
        get {
            if _highTemp == nil {
                _highTemp = 0
            }
            return _highTemp
        }
    }
    var lowTemp: Int {
        get {
            if _lowTemp == nil {
                _lowTemp = 0
            }
            return _lowTemp
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
        
        
        
   
        if let gameName = requestGameList["name"] as? String {
            self._gameName = gameName
            
        }
        if let key = requestGameList["GameID"] as? String {
            self._key = key
            
        }

        if let VideoUrl = requestGameList["VideoUrl"] as? String {
            self._VideoUrl = VideoUrl
            
        }
        
        if let avatarUrl = requestGameList["avatarUrl"] as? String {
            self._avatarUrl = avatarUrl
            
        }

        if let OwnerUID = requestGameList["HosterUID"] as? String {
            self._OwnerUID = OwnerUID
            
        }

        if let OwnerName = requestGameList["ownerName"] as? String {
            self._OwnerName = OwnerName
            
        }

        if let timePlay = requestGameList["timePlay"] {
            self._timePlay = timePlay
            
        }

        if let numberOfpeople = requestGameList["numberOfPeople"] as? String {
            self._numberOfpeople = numberOfpeople
            
        }

        if let latitude = requestGameList["lat"] as? Double {
            self._latitude = latitude
            
        }

        if let longtitude = requestGameList["lon"] as? Double {
            self._longtitude = longtitude
            
        }

        if let temperature = requestGameList["temperature"] as? Int {
            self._temperature = temperature
            
        }
        if let highTemp = requestGameList["highTemp"] as? Int {
            self._highTemp = highTemp
            
        }
        if let lowTemp = requestGameList["lowTemp"] as? Int {
            self._lowTemp = lowTemp
            
        }
        
        if let weatherDescription = requestGameList["weatherDescription"] as? String {
            self._weatherDescription = weatherDescription
            
        }

        if let locationName = requestGameList["locationName"] as? String {
            self._locationName = locationName
            
        }
        if let type = requestGameList["type"] as? String {
            self._type = type
            
        }
        
        if let DescriptionWeather = requestGameList["DescriptionWeather"] as? String {
            self._DescriptionWeather = DescriptionWeather
            
        }
        
        if let chatKey = requestGameList["chatKey"] as? String {
            self._chatKey = chatKey
            
        }
        
        if let country = requestGameList["Country"] as? String {
            self._country = country
            
        }
        
        if let country = requestGameList["Country"] as? String {
            self._country = country
            
        }
        if let CommunityKey = requestGameList["CommunityKey"] as? String {
            self._CommunityKey = CommunityKey
            
        }
        
        if let HosterType = requestGameList["HosterType"] as? String {
            self._HosterType = HosterType
            
        }
        
        
        
        
        
        if let JoinedUser = requestGameList["Joined_User"] as? Dictionary<String, AnyObject> {
            
            var array = [Dictionary<String, AnyObject>]()
            
            for item in JoinedUser {
            
                let index = JoinedUser[item.key] as! [String : AnyObject]
                
                
                array.append(index)
            
            }
            
            
            
            self._JoinedUserArray = array
            
            
            
            

        }
        
        

        
    }
    
    
    
    
    
    
    
    
    
    
}

 
