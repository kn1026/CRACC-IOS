//
//  Forecast.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/31/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Forecast {
    
    var _date: String!
    var _timestamp: Double!
    var _weatherType: String!
    var _description: String!
    var _highTemp: String!
    var _lowTemp: String!
    var _temp: String!
    
    
    var timestamp: Double {
        if _timestamp == nil {
            _timestamp = 0.0
        }
        return _timestamp
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var highTemp: String {
        if _highTemp == nil {
            _highTemp = ""
        }
        return _highTemp
    }
    
    var temp: String {
        if _temp == nil {
            _temp = ""
        }
        return _temp
    }
    
    var lowTemp: String {
        if _lowTemp == nil {
            _lowTemp = ""
        }
        return _lowTemp
    }
    
    
    
    init(weatherDict: Dictionary<String, AnyObject>) {
        
        
        
        
        if let temp = weatherDict["main"] as? Dictionary<String, AnyObject> {
            
            
            if let min = temp["temp_min"] as? Double {
                
                let kelvinToFarenheitPreDivision = (min * (9/5) - 459.67)
                
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._lowTemp = "\(kelvinToFarenheit)"
            }
            
            if let max = temp["temp"] as? Double {
                
                let kelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
                
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._highTemp = "\(kelvinToFarenheit)"
                
            }
            
            if let max = temp["temp_max"] as? Double {
                
                let kelvinToFarenheitPreDivision = (max * (9/5) - 459.67)
                
                let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                
                self._temp = "\(kelvinToFarenheit)"
                
            }
            
        }
        
        if let weather = weatherDict["weather"] as? [Dictionary<String, AnyObject>] {
            
            if let main = weather[0]["main"] as? String {
                self._weatherType = main
            }
            
            if let description = weather[0]["description"] as? String {
                self._description = description
            }
        }
        
        if let timestamp = weatherDict["dt"] as? Double {
            
            self._timestamp = timestamp
           
        }
        
    }


}


