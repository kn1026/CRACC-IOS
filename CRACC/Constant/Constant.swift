//
//  Constant.swift
//  CRACC
//
//  Created by Khoi Nguyen on 9/30/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import Foundation
import UIKit
import Cache



var userType = ""
let Shadow_Gray: CGFloat = 120.0 / 255.0
var userUID = ""
let GoogleMap_key = "AIzaSyAAYuBDXTubo_qcayPX6og_MrWq9-iM_KE"
let OpenMapWeather_key = "42a1771a0b787bf12e734ada0cfc80cb"
let Second_OpenMapWeather_key = "b90582f9d2ca0ab563954574697ea5b9"
var temporaryImage: UIImage?

let BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
var DoneUrl: URL?
let LATITUDE = "lat="
let LONGITUDE = "&lon="
let APP_ID = "&appid="
let change = 10800000

let ChosenColor = UIColor(red: 113/255, green: 111/255, blue: 111/255, alpha: 1.0)

typealias DownloadComplete = () -> ()


//let FORECAST_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?lat=\(Location.sharedInstance.latitude!)&lon=\(Location.sharedInstance.longitude!)&cnt=10&mode=json&appid=//"



let diskConfig = DiskConfig(name: "Floppy")
let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)

let InformationStorage = try? Storage(diskConfig: diskConfig, memoryConfig: memoryConfig)

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}

func timeAgoSinceDate(_ date:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = Date()
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "\(String(describing: components.year)) years ago"
    } else if (components.year! >= 1){
        if (numericDates){
            return "1 year ago"
        } else {
            return "Last year"
        }
    } else if (components.month! >= 2) {
        return "\(components.month!) months ago"
    } else if (components.month! >= 1){
        if (numericDates){
            return "1 month ago"
        } else {
            return "Last month"
        }
    } else if (components.weekOfYear! >= 2) {
        return "\(components.weekOfYear!) weeks ago"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){
            return "1 week ago"
        } else {
            return "Last week"
        }
    } else if (components.day! >= 2) {
        return "\(components.day!) days ago"
    } else if (components.day! >= 1){
        if (numericDates){
            return "1 day ago"
        } else {
            return "Yesterday"
        }
    } else if (components.hour! >= 2) {
        return "\(components.hour!) hrs ago"
    } else if (components.hour! >= 1){
        if (numericDates){
            return "1 hr ago"
        } else {
            return "An hour ago"
        }
    } else if (components.minute! >= 2) {
        return "\(components.minute!) mins ago"
    } else if (components.minute! >= 1){
        if (numericDates){
            return "1 min ago"
        } else {
            return "A min ago"
        }
    } else if (components.second! >= 3) {
        return "\(components.second!)s"
    } else {
        return "Just now"
    }
    
}


func delay(_ seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}



var ManagedGameKey = ""
var ManagedGameType = ""
var ManagedGameCountry = ""
var ManagehosterUID = ""
var ManageKeyChat = ""
var ManageCommunityKey = ""
var ManageNumberOfPeple = ""
var ManageTimePlayed = Int64(000000000)

var InfoUID = ""
var InfoType = ""
var viewWitdh = 0.0


var FBProfile = [String:AnyObject]()
var FBmatchInfo = [String:AnyObject]()
var badgeNumber = 0

var isGroupSend = false
var keysend = ""
var frNotiUID = ""
var frNotiType = ""
