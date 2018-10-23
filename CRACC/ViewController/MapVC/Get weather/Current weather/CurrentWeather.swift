//
//  CurrentWeather.swift
//  CRACC
//
//  Created by Khoi Nguyen on 10/31/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation
import UIKit
import Alamofire


class CurrentWeather {
    var _cityName: String!
    var _date: String!
    var _weatherType: String!
    var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = ""
        }
        return _cityName
    }
    
    var date: String {
        if _date == nil {
            _date = ""
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
    }
    
    var weatherType: String {
        if _weatherType == nil {
            _weatherType = ""
        }
        return _weatherType
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadWeatherDetails(latitude: Double, longitude: Double, completed: @escaping DownloadComplete) {
        //Download Current Weather Data
        
       let CURRENT_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(OpenMapWeather_key)"
        
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized
                    print(self._cityName)
                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    
                    if let main = weather[0]["main"] as? String {
                        self._weatherType = main.capitalized
                        
                    }
                    
                }
                
                if let main = dict["main"] as? Dictionary<String, AnyObject> {
                    
                    if let currentTemperature = main["temp"] as? Double {
                        
                        let kelvinToFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
                        
                        let kelvinToFarenheit = Double(round(10 * kelvinToFarenheitPreDivision/10))
                        
                        self._currentTemp = kelvinToFarenheit

                    }
                }
            }
            completed()
        }
 
    }
}

extension Date {
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
}
