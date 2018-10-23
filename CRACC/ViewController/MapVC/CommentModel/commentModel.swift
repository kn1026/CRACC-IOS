//
//  commentModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 1/16/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation



class CommentModel {
   
    
    fileprivate var _Cmtname: String!
    fileprivate var _CmtAvatarUrl: String!
    fileprivate var _CmtText: String!
    fileprivate var _CmtUID: String!
    fileprivate var _CmtUsertype: String!
    fileprivate var _rateStar: Int!
    fileprivate var _CmtTimestamp: Any!
    
    
    
    
    
    
    var CmtText: String! {
        get {
            if _CmtText == nil {
                _CmtText = ""
            }
            return _CmtText
        }
        
    }
    
    
    
    
    var rateStar: Int! {
        get {
            if _rateStar == nil {
                _rateStar = 0
            }
            return _rateStar
        }
        
    }
    
    
    var CmtAvatarUrl: String! {
        get {
            if _CmtAvatarUrl == nil {
                _CmtAvatarUrl = ""
            }
            return _CmtAvatarUrl
        }
        
    }
    
    
    var CmtTimestamp: Any! {
        get {
            if _CmtTimestamp == nil {
                _CmtTimestamp = 0
            }
            return _CmtTimestamp
        }
    }
    
    
    
    
    var Cmtname: String! {
        get {
            if _Cmtname == nil {
                _Cmtname = ""
            }
            return _Cmtname
        }
        
    }
    var CmtUsertype: String! {
        get {
            if _CmtUsertype == nil {
                _CmtUsertype = ""
            }
            return _CmtUsertype
        }
        
    }
    
    
    
    var CmtUID: String! {
        get {
            if _CmtUID == nil {
                _CmtUID = ""
            }
            return _CmtUID
        }
        
    }
    
    
    
    
    
    init(postKey: String, CommentModel: Dictionary<String, Any>) {
        
        
        
        if let Cmtname = CommentModel["Cmtname"] as? String {
            self._Cmtname = Cmtname
            
        }
        
        if let CmtText = CommentModel["CmtText"] as? String {
            self._CmtText = CmtText
            
        }
        
        if let CmtAvatarUrl = CommentModel["CmtAvatarUrl"] as? String {
            self._CmtAvatarUrl = CmtAvatarUrl
            
        }
        
        
        if let CmtUsertype = CommentModel["CmtUsertype"] as? String {
            self._CmtUsertype = CmtUsertype
            
        }
        
        if let CmtUID = CommentModel["CmtUID"] as? String {
            self._CmtUID = CmtUID
            
        }
        if let rateStar = CommentModel["rateStar"] as? Int {
            self._rateStar = rateStar
            
        }
        
        if let CmtTimestamp = CommentModel["CmtTimestamp"] {
            self._CmtTimestamp = CmtTimestamp
            
        }
        
        
        
        
    }
    
    
    
    
    
}
