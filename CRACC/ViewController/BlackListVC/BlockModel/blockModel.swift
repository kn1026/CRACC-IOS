//
//  blockModel.swift
//  CRACC
//
//  Created by Khoi Nguyen on 3/10/18.
//  Copyright © 2018 Cracc LLC. All rights reserved.
//

import Foundation


class blockModel {

    fileprivate var _BlockName: String!
    fileprivate var _BlockTime: Any!
    fileprivate var _BlockType: String!
    fileprivate var _BlockUID: String!
    
    
    
    var BlockTime: Any! {
        get {
            if _BlockTime == nil {
                _BlockTime = 0
            }
            return _BlockTime
        }
    }
    
    
    var BlockName: String! {
        get {
            if _BlockName == nil {
                _BlockName = ""
            }
            return _BlockName
        }
        
    }

    var BlockType: String! {
        get {
            if _BlockType == nil {
                _BlockType = ""
            }
            return _BlockType
        }
        
    }
    
    var BlockUID: String! {
        get {
            if _BlockUID == nil {
                _BlockUID = ""
            }
            return _BlockUID
        }
        
    }

    init(postKey: String, blockModel: Dictionary<String, Any>) {
        
        
        
        if let BlockName = blockModel["BlockName"] as? String {
            self._BlockName = BlockName
            
        }
        if let BlockType = blockModel["BlockType"] as? String {
            self._BlockType = BlockType
            
        }
        if let BlockUID = blockModel["BlockUID"] as? String {
            self._BlockUID = BlockUID
            
        }
        if let BlockTime = blockModel["BlockTime"] {
            self._BlockTime = BlockTime
            
        }
        
        
        
        
    }



}
