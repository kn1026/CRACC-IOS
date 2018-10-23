//
//  ViewController.swift
//  CRACC
//
//  Created by Khoi Nguyen on 9/30/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import GooglePlaces
import Firebase
import CameraManager
import Cache
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import Pulsator
import Alamofire
import AVKit
import AVFoundation
import GeoFire
import FirebaseStorage
import FirebaseAuth
import SwiftyJSON
import MGSwipeTableCell
import MapKit
import UserNotifications
import JDropDownAlert
import SCLAlertView
import Device


enum tableViewControl  {
    
    case controlGameList
    case chatList
    case MVPlist
    case commentList
    case addChat
    case controlPeople


}

enum ControlView {
    case GameView
    case InformationViewMode
    case chatViewMode
    case CreateNewGame
    case ProfileViewMode
    case hosterController
    case gameListView
    case rateGameView
    case addChatView
    case controlPeopleView
    case EditView
    case termView
    case Done
}

enum collectionViewControll {

    case requestGame
    case CreateGame


}

enum searchForLocation {

    case normalSearch
    case CreateSearch
    case settingSearch



}

enum pickView {
    
    case age
    case gender
    case numberOfPeople
    
    
    
}




var position: CGPoint!


class MapVC: UIViewController, GMSMapViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate,UITextViewDelegate, UISearchBarDelegate,MGSwipeTableCellDelegate, UNUserNotificationCenterDelegate {
    
    
    
    var lostHandle: UInt!
    @IBOutlet weak var termTxtView: UITextView!
    @IBOutlet weak var termView: UIView!
    @IBOutlet weak var termOfUseBtn: UIButton!
    
    var isAnimated = false
    
    @IBOutlet weak var gameListHeight: NSLayoutConstraint!
    @IBOutlet weak var blacklistCount: CountLbl!
    @IBOutlet weak var blackListBtn: UIButton!
    var animationPath = GMSMutablePath()
    
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    
    @IBOutlet weak var ReportBtn2: UIButton!
    @IBOutlet weak var reportBtn1: UIButton!
    @IBOutlet weak var hosterDistance: UILabel!
    @IBOutlet weak var createBtn: ModifiedBtnCorner!
    @IBOutlet weak var launchNavigationBtn: UIButton!
    var placeName = ""
    
    @IBOutlet weak var hosterWeatherView: UIView!
    var inSettingMode = false
    
    @IBOutlet weak var settingGameIcon: UIImageView!
    @IBOutlet weak var settingGameName: UITextField!
    @IBOutlet weak var settingGameLocation: UITextField!
    @IBOutlet weak var settingGameTime: UITextField!
    @IBOutlet weak var settingGameNumberOfPeople: UITextField!
    @IBOutlet weak var settingIconImg: UIImageView!
    
    @IBOutlet weak var cloneBtn: UIButton!
    @IBOutlet weak var bullyBtn: UIButton!
    @IBOutlet weak var defamesBtn: UIButton!
    @IBOutlet weak var spamBtn: UIButton!
    @IBOutlet weak var fakeBtn: UIButton!
    @IBOutlet weak var cheatBtn: UIButton!
    @IBOutlet weak var otherBtn: UIButton!
    @IBOutlet weak var reportView: UIView!
    
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    
    @IBOutlet weak var settingGameView: ModifiedInformationView!
    
    @IBOutlet weak var editGameBtn: UIButton!
    
    
    @IBOutlet weak var hosterWeatherIcon: UIImageView!
    @IBOutlet weak var hosterMinTemp: UILabel!
    @IBOutlet weak var hosterHighTemp: UILabel!
    @IBOutlet weak var hosterAverageTemp: UILabel!
    //
    
    
    var setingIcon = ""
    var setingGameName = ""
    var setingGameLocation = ""
    var setingGameTime = ""
    var setingNumberOfPeople = ""
    
    
    
    @IBOutlet weak var friendRequestCount: UILabel!
    
    //
    
    @IBOutlet weak var controlPeopleTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var controlPeopleView: ChooseFriendView!
    @IBOutlet weak var controlPeopleTableView: UITableView!
    var controlGameIndexed: Int!
    var joinedUserArr = [RecentlyPlayedModel]()
    
    
    var insearchMode = false
    
    var frUID: String?
    var frName: String?
    var frType: String?
    var frAvatarUrl: String?
    
    
    @IBOutlet weak var searchBarWidth: NSLayoutConstraint!
    @IBOutlet weak var searchBar: modifiedSearchBarAddChat!
    @IBOutlet weak var addChatTableView: UITableView!
    @IBOutlet weak var blurView2: UIView!
    @IBOutlet weak var addChatView: ModifyCornerForAddChatView!
    var FriendListArray = [FriendModel]()
    var filterList = [FriendModel]()
    
    @IBOutlet weak var addChatBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addChatLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var addChatTrailingConstraint: NSLayoutConstraint!
    
    
    var index = [Int]()
    
    //
    
    var commentUserArr = [CommentModel]()
    
    //
    
    
    @IBOutlet weak var informationTableView: UITableView!
    
    @IBOutlet weak var informationSetting: UIButton!
    
    @IBOutlet weak var informationStar3: UIButton!
    
    @IBOutlet weak var informationStar2: UIButton!
    //
    @IBOutlet weak var informationStar1: UIButton!
    @IBOutlet weak var informationStar4: UIButton!
    
    @IBOutlet weak var informationStar5: UIButton!
    
    @IBOutlet weak var informationAge: UILabel!
    
    @IBOutlet weak var informationLastGamePlayed: UILabel!
    
    @IBOutlet weak var informationGameCount: UILabel!
    
    @IBOutlet weak var informationCanceledGame: UILabel!
    
    
    var rateHosterUID = ""
    var ratehosterType = ""
    
    
    var ChooseMVPPlayerArr = [RecentlyPlayedModel]()
    
    var MVPIndex: Int?
    
    
    ///

    @IBOutlet weak var MVPView: ChooseFriendView!
    @IBOutlet weak var MVPtableView: UITableView!
    
    
    
    // rate view
    let starImage = UIImage(named: "star")
    let nostarImage = UIImage(named: "nostar")
    
    //
    
    var starCount = 0
    
    
    //
    @IBOutlet weak var rateView: ModifiedInformationView!
    @IBOutlet weak var rateGameIcon: UIImageView!
    @IBOutlet weak var rateOwnerAvatarImg: RoundedImgAndBorder!
    @IBOutlet weak var rateGameName: UILabel!
    @IBOutlet weak var rateGameDate: UILabel!
    @IBOutlet weak var rateGameTime: UILabel!
    @IBOutlet weak var rateGameAdd: UILabel!
    
    @IBOutlet weak var rateStar1: UIButton!
    @IBOutlet weak var rateStar2: UIButton!
    @IBOutlet weak var rateStar3: UIButton!
    @IBOutlet weak var rateStar4: UIButton!
    @IBOutlet weak var rateStar5: UIButton!
    
    @IBOutlet weak var rateCommentTxtView: CommentField!
    @IBOutlet weak var MVPBtn: RoundedBtnForCreateGame!
    
    //
    
    var listMakrer = [GMSMarker]()
    @IBOutlet weak var locationGameListView: UILabel!
    @IBOutlet weak var gameListView: ModifiedGameListView!
    var tableControl = tableViewControl.chatList
    @IBOutlet weak var tableGameList: UITableView!
    var numberOfPeople: Int?
    var keyChat: String?
    var nameGroupChat: String?
    var hosterUID: String?
    var hosterType: String?
    
    var timePLay: Any?
    var typeChosen: String?
    var destinationName: String?
    var countryOfGameViewed: String?
    var gameKeyJoined: String?
    var locationJoined: String?
    var JoinedIndex: Int?
    var JoinedhosterUID: String?
    var numberOfJoinPeople = [Dictionary<String, AnyObject>]()
    

    var avatarUrl: String!
    var groupKeyChat: String?
    var GroupName: String?
    var isGroup: Bool!
    
    
    @IBOutlet weak var joinNowBtn: ModifiedBtnCorner!
    @IBOutlet weak var inviteAndLeaveView: UIView!
    
    var MinAgeSelected: String?
    var MaxAgeSelected: String?
    var GenderSelected: String?
    
    
    var chatList = [chatModel]()
    var pickerViewController = pickView.numberOfPeople
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var ageLbl: UITextField!
    @IBOutlet weak var genderLbl: UITextField!
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var videoLoader: UIActivityIndicatorView!
    @IBOutlet weak var avatarLoader: UIActivityIndicatorView!
    @IBOutlet weak var dateHosterControl: UILabel!
    @IBOutlet weak var timeHosterControl: UILabel!
    @IBOutlet weak var PeopleCountHosterControl: UILabel!
    @IBOutlet weak var addressHosterControl: UILabel!
    @IBOutlet weak var playVideoHosterControl: UIButton!
    @IBOutlet weak var nameHosterControl: UILabel!
    @IBOutlet weak var descriptionWeatherHosterControl: UILabel!
    @IBOutlet weak var typeWeatherHosterControl: UIImageView!
    @IBOutlet weak var avatarImgHosterControll: addBorderAndRoundedCornerImgView!
    @IBOutlet weak var typeGameHosterControll: UIImageView!
    
    @IBOutlet weak var hosterController: ModifiedOwnerGameControl!
    
    @IBOutlet weak var openRequestGameView: UIView!
    @IBOutlet weak var percentageOfRainOrSnow: UILabel!
    @IBOutlet weak var averageTempLblWeatherView: UILabel!
    @IBOutlet weak var highTempLblWeatherView: UILabel!
    @IBOutlet weak var lowTempLblWeatherView: UILabel!
    @IBOutlet weak var imageWeatherView: UIImageView!
    @IBOutlet weak var weatherView: UIView!
    var destinationLocation: CLLocation!
    var OriginalLocation: CLLocation!
    var localLocation: CLLocation!
    var createLocation: CLLocation!
    var highTemp: Double?
    var lowTemp: Double?
    @IBOutlet weak var typeGameView: UIImageView!
    @IBOutlet weak var weatherTypeGameView: UIImageView!
    
    @IBOutlet weak var avatarGameView: addBorderAndRoundedCornerImgView!
    @IBOutlet weak var weatherDescriptionGamView: UILabel!
    
    @IBOutlet weak var nameGameView: UILabel!
    
    @IBOutlet weak var playVideoBtn: UIButton!
    
    @IBOutlet weak var DateGameView: UILabel!
    
    @IBOutlet weak var addressGameView: UILabel!
    
    @IBOutlet weak var numberOfPeopleGameView: UILabel!
    
    @IBOutlet weak var timeGameView: UILabel!
    
    @IBOutlet weak var distanceGameView: UILabel!
    var gameRequest: requestModel!
    var listGameRequest = [requestModel]()
    var GameList = [requestModel]()
    var gameKey = [String]()
    var typeWeather: String?
    var DescriptionWeather: String?
    var temperature: Double?
    var ownerName: String?
    let geocoder = CLGeocoder()
    var originalLat: CLLocationDegrees?
    var originalLon: CLLocationDegrees?
    
    var settingLat: CLLocationDegrees?
    var settingLon: CLLocationDegrees?
    
    
    
    
    @IBOutlet weak var playVideoView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var DoneRecordedView: UIView!
    @IBOutlet weak var openCameraView: ModifiedCameraFrontView!
    
    @IBOutlet weak var weatherIcon: UIImageView!
    var type: String?
    var swipeBack = UISwipeGestureRecognizer()
    var alreadyLocation: String?
    var lat: CLLocationDegrees?
    var lon: CLLocationDegrees?
    var Timechange: Int64?
    var forecasts = [Forecast]()
    var countryCreated: String?
    var countryRequested: String?
    
    var timeSelected: Double?
    var timeSetting: Double?
    var currentWeather: CurrentWeather!
    var forecastWeather: Forecast!
    var selectedPicker: String?
    var selectedImgPicker: UIImage?
    var playerVideo: AVPlayer!
    var playController = AVPlayerViewController()
    @IBOutlet weak var imageType: UIImageView!
    @IBOutlet weak var numberPeopleLbl: UITextField!
    @IBOutlet weak var requestGameView: ModifiedChooseGameView!
    
    @IBOutlet weak var ChooseGameTypeView: ModifiedChooseGameType!
    
    @IBOutlet weak var dateLbl: UITextField!
    
    @IBOutlet weak var LocationLbl: UITextField!
    
    @IBOutlet weak var nameLbl: UITextField!
    
    var isdate = false
    
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var myLocationLbl: UILabel!
    @IBOutlet weak var myLocationSearchBar: ModifiedSearchBarView!
    @IBOutlet weak var destinationSearchBar: ModifiedSearchBarView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var chooseGameTypeCollectionView: UICollectionView!
    
    
    let autocompleteController = GMSAutocompleteViewController()
    var NumberOfPeople = [String]()
    var Gender = ["Male", "Female", "Both"]
    var MaxAge = [String]()
    var MinAge = [String]()
    var ListGame = ["Basketball", "Soccer", "Pool", "Cricket", "Football", "Gym", "Running"]
    var listImage = [UIImage(named: "basketball"), UIImage(named: "soccer"),UIImage(named: "pool"),UIImage(named: "cricket"),UIImage(named: "football"), UIImage(named: "gym"), UIImage(named: "running")]
    

    var HotTemperatureColor = UIColor(red: 237/255, green: 102/255, blue: 97/255, alpha: 1.0)
    var WarmTemperatureColor = UIColor(red: 242/255, green: 178/255, blue: 86/255, alpha: 1.0)
    var CoolTemperatureColor = UIColor(red: 108/255, green: 167/255, blue: 231/255, alpha: 1.0)
    var ColdTemperatureColor = UIColor(red: 81/255, green: 128/255, blue: 179/255, alpha: 1.0)
    
   
    

    var controlSearch = searchForLocation.normalSearch
    var ControltMode = ControlView.Done
    var ControllCollection = collectionViewControll.requestGame
    
    
    // setup orientation for camera
    
    @IBOutlet weak var profileNameLbl: UILabel!
    @IBOutlet weak var InformationNameLbl: UILabel!
    @IBOutlet weak var ProfileImgView: ImageRound!
    @IBOutlet weak var InformationImgView: RoundedImgAndBorder!
    @IBOutlet weak var avatarImg: UIImageView!
    var orientation: String!
    
    let cameraManager = CameraManager()
    
    @IBOutlet weak var cameraView: UIView!
    var Done = true
    
    
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    // create game view
    
    @IBOutlet weak var createGameViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var createGameView: ModifiedInformationView!
    
    // list btn of ProfileView
    
    @IBOutlet weak var createNewGameBtn2: UIButton!
    @IBOutlet weak var InformationBtn2: UIButton!
    @IBOutlet weak var InterestedBtn2: UIButton!
    @IBOutlet weak var communityBtn2: UIButton!
    @IBOutlet weak var logoutBtn2: UIButton!
    
    
    // constraint for chatView
    
    @IBOutlet weak var bottomConstraintForChatView: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraintForChatView: NSLayoutConstraint!
    
    var CreateGameTop = 0
    @IBOutlet weak var profileBtn: RoundBtn!
    
    
    
    var IconImage = UIImage(named: "direction")
    var formatter = NumberFormatter()
    
    
    @IBOutlet weak var InformationView: ModifiedInformationView!
    
    
    
    
    
    
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var controlGameView: Modified2cornerView!
    @IBOutlet weak var heightOfControlGameView2: NSLayoutConstraint!
    @IBOutlet weak var heightOfControlGameView: NSLayoutConstraint!
    @IBOutlet weak var locationBtn: RoundBtn!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var navigationVC: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    
    @IBOutlet weak var chatViewLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var chatImage: UIButton!
    
    @IBOutlet weak var GameManagementImage: UIButton!
    
    //@IBOutlet weak var heightOfDetailView: NSLayoutConstraint!
    

    @IBOutlet weak var heightOfCreateGame: NSLayoutConstraint!
    var marker = GMSMarker()
    
    
    var isKeyboard = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard Auth.auth().currentUser != nil else {
            return
        }
      
        
        
        friendRequestCount.isHidden = true
        blacklistCount.isHidden = true
        
        videoLoader.hidesWhenStopped = true
        avatarLoader.hidesWhenStopped = true
        
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
       
        // setting content allignment of list button in profile view
        SetContentAllignmenttoBtn()
        
        heightOfControlGameView.constant = self.view.frame.height * (379/736) + 30
        
        leadingConstraintForChatView.constant = self.view.frame.width * (1/2)
        
        controlPeopleTrailingConstraint.constant = self.view.frame.width * (30/320)
        
        bottomConstraintForChatView.constant = self.view.frame.height * (1/2) - 105
        
        
          addChatBottomConstraint.constant = self.view.frame.height * (1/2) - 120
        addChatLeadingConstraint.constant = self.view.frame.width * (140/320)
        addChatTrailingConstraint.constant = self.view.frame.width * (40/320)
        
        //heightOfCreateGame.constant = self.view.frame.height * (400/568)
        gameListHeight.constant = self.view.frame.height * (467/568)
        
        switch Device.type() {
        case .iPod:         heightOfCreateGame.constant = self.view.frame.height * (382/568)
        case .iPhone:       heightOfCreateGame.constant = self.view.frame.height * (382/568)
        case .iPad:         heightOfCreateGame.constant = self.view.frame.height * (450/568)
        default:            heightOfCreateGame.constant = self.view.frame.height * (382/568)
        }
        
        // declare self for all delegate function
        mapView.delegate = self
        locationManager.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        chatTableView.dataSource = self
        chatTableView.delegate = self
        tableGameList.dataSource = self
        tableGameList.delegate = self
        informationTableView.delegate = self
        informationTableView.dataSource = self
        addChatTableView.delegate = self
        addChatTableView.dataSource = self
        controlPeopleTableView.delegate = self
        controlPeopleTableView.dataSource = self
        searchBar.delegate = self
        
        
        MVPtableView.dataSource = self
        MVPtableView.delegate = self
        
        
        rateCommentTxtView.delegate = self
        autocompleteController.delegate = self
        
        currentWeather = CurrentWeather()
        
        chooseGameTypeCollectionView.delegate = self
        chooseGameTypeCollectionView.dataSource = self
        //blurMap()
        
        
        if let CacheavatarImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: "avatarImg").image {
        
            self.avatarImg.image = CacheavatarImg
            self.ProfileImgView.image = CacheavatarImg
            self.InformationImgView.image = CacheavatarImg
        
        } else {
            
            let img = UIImage(named: "CRACC")
            
            
            self.avatarImg.image = img
            self.ProfileImgView.image = img
            self.InformationImgView.image = img
            
        }
        
        if let CachedName = try? InformationStorage?.object(ofType: String.self, forKey: "nickname"){
        
        
            self.profileNameLbl.text = CachedName
            self.InformationNameLbl.text = CachedName
            ownerName = CachedName
            
        
        
        }
        
        if let CachedavatarUrl = try? InformationStorage?.object(ofType: String.self, forKey: "avatarUrl"){
            
            
            
            avatarUrl = CachedavatarUrl
            
            
        } else {
            
            avatarUrl = "nil"
        }
        
        
        setupDefaultMap()
        
        styleMap()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.view.setNeedsLayout()
        configureLocationServices()
        

        swipeBack.addTarget(self, action: #selector(MapVC.closeVideo))
        swipeBack.direction = .up
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.termTxtView.setContentOffset(CGPoint.zero, animated: false)
        self.termTxtView.layer.cornerRadius = 3.0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard Auth.auth().currentUser != nil else {
            return
        }
    
        
        
        if createGameView.isHidden != true {
            
            
            if DoneUrl != nil {
            
                
            DoneRecordedView.isHidden = false
            openCameraView.isHidden = true
            
                return
            }
            
            self.cameraManager.resumeCaptureSession()
            
            
            
        }
        
        
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        guard Auth.auth().currentUser != nil else {
            return
            
            
        }
        
        if userUID == "" || userType == "" {
            
            userUID = (Auth.auth().currentUser?.uid)!
            if let CachedType = try? InformationStorage?.object(ofType: String.self, forKey: "type"){
                
                
                if CachedType == "Google" {
                    
                    userType = "Google"
                    
                    
                    
                } else if CachedType == "Facebook" {
                    
                    
                    userType = "Facebook"
                    
                } else {
                    
                    userType = "Email"
                    
                }
               
                
            }

        }
        
        lostHandle = DataService.instance.connectedRef.observe(.value, with: { snapShot in
            if let connected = snapShot.value as? Bool, connected {
                
                
                DataService.instance.connectedRef.removeObserver(withHandle: self.lostHandle)
                
                let userDefaults = UserDefaults.standard
                
                if userDefaults.bool(forKey: "hasAcceptedTerm") == false {
                    print("Not agree with term yet")
                    self.ControltMode = ControlView.termView
                    self.termView.isHidden = false
                    self.blurView.isHidden = false
                    
                } else {
                    
                    if userDefaults.bool(forKey: "hasUpdatedToDatabase") == false {
                        print("THavenot updated yet")
                        
                        DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("TermOfUse").child("Agreed").setValue(1)
                        
                        // Update the flag indicator
                        userDefaults.set(true, forKey: "hasUpdatedToDatabase")
                        userDefaults.synchronize() // This forces the app to update userDefaults

                        // Run code here for the first launch
                        
                        
                    
                        
                    }
                    
                    if userDefaults.bool(forKey: "hasPlayedIntro") == false {
                        print("The app is launching for the first time. Setting UserDefaults...")
                        
                        self.watchIntroVid()
                        
                        // Update the flag indicator
                        userDefaults.set(true, forKey: "hasPlayedIntro")
                        userDefaults.synchronize() // This forces the app to update userDefaults
                        
                        // Run code here for the first launch
                        
                    }
                    
                    
                }
               
                
                
            } else {
               
                DataService.instance.connectedRef.removeObserver(withHandle: self.lostHandle)
                let userDefaults = UserDefaults.standard
                
                if userDefaults.bool(forKey: "hasAcceptedTerm") == false {
                    print("Not agree with term yet")
                    
                    self.ControltMode = ControlView.termView
                    self.termView.isHidden = false
                    self.blurView.isHidden = false
                
                    
                } else {
                    
                    
                    if userDefaults.bool(forKey: "hasPlayedIntro") == false {
                        print("The app is launching for the first time. Setting UserDefaults...")
                        
                        self.watchIntroVid()
                        
                        // Update the flag indicator
                        userDefaults.set(true, forKey: "hasPlayedIntro")
                        userDefaults.synchronize() // This forces the app to update userDefaults
                        
                        // Run code here for the first launch
                        
                    }
                    
                    
                }
                
                
            }
            
            
        })
       

    }
    
    @IBAction func blackListBtn1Pressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showBlackListVC", sender: nil)
    }
    
    @IBAction func blackListBtn2Pressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showBlackListVC", sender: nil)
    }
    
    func addLocalNoftification() {
        
        
        if #available(iOS 10.0, *) {
            //iOS 10 or above version
            let center = UNUserNotificationCenter.current()
            let content = UNMutableNotificationContent()
            content.title = "Late wake up call"
            content.body = "The early bird catches the worm, but the second mouse gets the cheese."
            content.categoryIdentifier = "alarm"
            content.userInfo = ["customData": "fizzbuzz"]
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 15
            dateComponents.minute = 49
            
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        } else {
            // ios 9
            let notification = UILocalNotification()
            notification.fireDate = NSDate(timeIntervalSinceNow: 5) as Date
            notification.alertBody = "Hey you! Yeah you! Swipe to unlock!"
            notification.alertAction = "be awesome!"
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.shared.scheduleLocalNotification(notification)
            
            let notification1 = UILocalNotification()
            notification1.fireDate = NSDate(timeIntervalSinceNow: 15) as Date
            notification1.alertBody = "Hey you! Yeah you! Swipe to unlock!"
            notification1.alertAction = "be awesome!"
            notification1.soundName = UILocalNotificationDefaultSoundName
            
            UIApplication.shared.scheduleLocalNotification(notification1)
            
        }
    }
    
    @IBAction func launchNavigation1BtnPressed(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Which map do you want to use ?", message: "", preferredStyle: .actionSheet)
        
        
        let googleMap = UIAlertAction(title: "Google Map", style: .default) { (alert) in
            
            self.launchGoogleMap()
            
        }
        
        let appleMap = UIAlertAction(title: "Apple Map", style: .default) { (alert) in
            
            self.AppleMap()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        
        sheet.addAction(googleMap)
        sheet.addAction(appleMap)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func launchNavigation2BtnPressed(_ sender: Any) {
        
        
        let sheet = UIAlertController(title: "Which map do you want to use ?", message: "", preferredStyle: .actionSheet)
        
        
        let googleMap = UIAlertAction(title: "Google Map", style: .default) { (alert) in
            
            self.launchGoogleMap()
            
        }
        
        let appleMap = UIAlertAction(title: "Apple Map", style: .default) { (alert) in
            
            self.AppleMap()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        
        sheet.addAction(googleMap)
        sheet.addAction(appleMap)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    func launchGoogleMap() {

        let Deslatitude: CLLocationDegrees = destinationLocation.coordinate.latitude
        let Deslongitude: CLLocationDegrees = destinationLocation.coordinate.longitude
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            UIApplication.shared.openURL(URL(string:"comgooglemaps://?saddr=&daddr=\(Deslatitude),\(Deslongitude)&directionsmode=driving")!)
        }
    }
    
    
    func AppleMap() {
        
        
        
        let latitude: CLLocationDegrees = destinationLocation.coordinate.latitude
        let longitude: CLLocationDegrees = destinationLocation.coordinate.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = placeName
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    
    
    @IBAction func showHosterWeatherViewBtnPressed(_ sender: Any) {
        
        
        self.hosterWeatherView.isHidden = false
        
        delay(2.0) { () -> () in
            self.hosterWeatherView.isHidden = true
        }
        
    }
    
    @objc func showKeyboard(_ notification: Notification) {
        
        isKeyboard = true
        
    }
    
    @objc func hideKeyboard(_ notification: Notification) {
        
        isKeyboard = false
        
    }
    
    // star function
    
    @IBAction func star1BtnPressed(_ sender: Any) {
        
        
        
        
        rateStar1.setImage(starImage, for: .normal)
        
        // unstar
        
        
        rateStar2.setImage(nostarImage, for: .normal)
        rateStar3.setImage(nostarImage, for: .normal)
        rateStar4.setImage(nostarImage, for: .normal)
        rateStar5.setImage(nostarImage, for: .normal)
        
        
        starCount = 1
        
        
    }
    
    @IBAction func star2BtnPressed(_ sender: Any) {
        
        rateStar1.setImage(starImage, for: .normal)
        rateStar2.setImage(starImage, for: .normal)
        
        // unstar
        
        rateStar3.setImage(nostarImage, for: .normal)
        rateStar4.setImage(nostarImage, for: .normal)
        rateStar5.setImage(nostarImage, for: .normal)
        
        starCount = 2
        
        
    }
    
    @IBAction func star3BtnPressed(_ sender: Any) {
        rateStar1.setImage(starImage, for: .normal)
        rateStar2.setImage(starImage, for: .normal)
        rateStar3.setImage(starImage, for: .normal)
        
        // unstar
        rateStar4.setImage(nostarImage, for: .normal)
        rateStar5.setImage(nostarImage, for: .normal)
        
        starCount = 3
    }
    
    @IBAction func star4BtnPressed(_ sender: Any) {
        rateStar1.setImage(starImage, for: .normal)
        rateStar2.setImage(starImage, for: .normal)
        rateStar3.setImage(starImage, for: .normal)
        rateStar4.setImage(starImage, for: .normal)
        
        // unstar
        rateStar5.setImage(nostarImage, for: .normal)
        
        starCount = 4
    }
    
    @IBAction func star5BtnPressed(_ sender: Any) {
        rateStar1.setImage(starImage, for: .normal)
        rateStar2.setImage(starImage, for: .normal)
        rateStar3.setImage(starImage, for: .normal)
        rateStar4.setImage(starImage, for: .normal)
        rateStar5.setImage(starImage, for: .normal)
        
        
        starCount = 5
    }
    
    @IBAction func MVPBtnPressed(_ sender: Any) {
        
        
        
        blurView.isHidden = false
        MVPView.isHidden = false
        
        if ChooseMVPPlayerArr.isEmpty != true {
            
            
            tableControl = tableViewControl.MVPlist
            MVPtableView.reloadData()
            
        }
        
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func openAddChatViewBtnPressed(_ sender: Any) {
        
        
        NotificationCenter.default.addObserver( self, selector: #selector(MapVC.showKeyboard(_:)),
                                                name: UIResponder.keyboardWillShowNotification,
                                                object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.hideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        
        self.blurView2.isHidden = false
        self.addChatView.isHidden = false
        self.ControltMode = .addChatView
        self.tableControl = .addChat
        
        
        
        
        
        
        getFrList()
        
    }
    
    func getFrList() {
        
        
        FriendListArray.removeAll()
        addChatTableView.reloadData()
        
        let FriendListtUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_List")
        let AddChattUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Add_Chat")
        
        FriendListtUrl.queryOrdered(byChild: "timePlay").observeSingleEvent(of: .value, with: { (FriendList) in
            
            if FriendList.exists() {
                
                //Add_Chat
                
                if let snap = FriendList.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            if let uid = postDict["FriendUID"] as? String {
                                
                                
                                AddChattUrl.child(uid).observeSingleEvent(of: .value, with: { (AddChat) in
                                    
                                    if AddChat.exists() {
                                        
                                        
                                    } else {
                                        
                                        let key = FriendList.key
                                        let FrData = FriendModel(postKey: key, FriendModel: postDict)
                                        self.FriendListArray.insert(FrData, at: 0)
                                        
                                        
                                        self.addChatTableView.reloadData()
                                        
                                    }
                                    
                                })
                                
                            }
                            
                    
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
                
                
            } else {
                
                
                
                
            }
            
            
        })
        
        
        
        
    }
    
    @IBAction func declineBtnPressed(_ sender: Any) {
        
        DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("TermOfUse").child("Agreed").setValue(0)
        
            let instance = InstanceID.instanceID()
            _ = InstanceID.deleteID(instance)
            InstanceID.instanceID().deleteID { (err:Error?) in
                if err != nil{
                    print(err.debugDescription);
                } else {
                    print("Token Deleted");
                }
            }
        
            try! Auth.auth().signOut()
            GIDSignIn.sharedInstance().signOut()
            FBSDKLoginManager().logOut()
        
            try? InformationStorage?.removeAll()
            DataService.instance.mainDataBaseRef.removeAllObservers()
            self.performSegue(withIdentifier: "GoBackToSignInVC", sender: nil)
        
        
        
    }
    // search bar
    
    @IBAction func agreeBtnPressed(_ sender: Any) {
        
        
        
        let userDefaults = UserDefaults.standard
    DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("TermOfUse").child("Agreed").setValue(1)
        self.termView.isHidden = true
        self.blurView.isHidden = true
        
        // Update the flag indicator
        userDefaults.set(true, forKey: "hasAcceptedTerm")
        userDefaults.synchronize() // This forces the app to update userDefaults
        
        self.controlPeopleView.isHidden = true
        self.blurView.isHidden = true
        self.ControltMode = .Done
        
        if userDefaults.bool(forKey: "hasPlayedIntro") == false {
            print("The app is launching for the first time. Setting UserDefaults...")
            
            watchIntroVid()
            
            // Update the flag indicator
            userDefaults.set(true, forKey: "hasPlayedIntro")
            userDefaults.synchronize() // This forces the app to update userDefaults
            
            // Run code here for the first launch
            
        }
        
        
        
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        
        self.searchBar.frame.size.width = self.addChatView.frame.size.width - 30
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        
        self.searchBar.frame.size.width = 70
        insearchMode = false
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            
            insearchMode = false
            addChatTableView.reloadData()
            
        }
            
        else {
            
            
            insearchMode = true
            filterList = FriendListArray.filter({$0.Frname.range(of: searchText) != nil })
            addChatTableView.reloadData()
            
            
        }
    }
    
    //
    
    @IBAction func finishAddChatViewBtnPressed(_ sender: Any) {
        
        
        if isKeyboard == true {
            
            self.view.endEditing(true)
        }
        
        
        if index.isEmpty != true {
            
            let myUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
            
            for i in index {
                
            
                
                let item = FriendListArray[i]
                
                let information: Dictionary<String, AnyObject> = ["FrName": item.Frname as AnyObject, "frAvatarUrl": item.FrAvatarUrl as AnyObject, "FriendType": item.FrType as AnyObject, "FriendUID": item.FruserUID as AnyObject, "isGroup": 0 as AnyObject, "time": ServerValue.timestamp() as AnyObject]
                
                
                myUrl.child("Add_Chat").child(item.FruserUID).setValue(information)
                
                
                
            }
            
            
            tableControl = tableViewControl.chatList
            self.chatList.removeAll()
            index.removeAll()
            self.chatTableView.reloadData()
            
            
            
            
            getAddChat() {
                
                self.getlistChat()
                
            }
            
            
            
        }
        
        
        addChatView.isHidden = true
        blurView2.isHidden = true
        self.ControltMode = .chatViewMode
        

    }
    
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        if starCount != 0, rateCommentTxtView.text != "", rateCommentTxtView.text != "Write comment for hoster here ...", rateHosterUID != "", ratehosterType != "", self.ownerName != "" {
            
            var MyType = ""
            
            if let CachedType = try? InformationStorage?.object(ofType: String.self, forKey: "type"){
                
                MyType = CachedType!
                
            }
            
            if let commentText = rateCommentTxtView.text {
                
                if MVPIndex != nil {
                    
                    if let MVPcount = MVPIndex {
                        
                        let item = ChooseMVPPlayerArr[MVPcount]
                        
                        let mvpPlayerUrl = DataService.instance.mainDataBaseRef.child("User").child(item.JoineduserType).child(item.JoineduserUID)
                        
                        let CommunityRef = DataService.instance.mainDataBaseRef.child("Community").child(item.JoineduserUID).childByAutoId()
                        let CommunityKey = CommunityRef.key
                        
                        let communityInformation: Dictionary<String, AnyObject> = ["name": nameGroupChat as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": ManagedGameKey as AnyObject, "type": ManagedGameType as AnyObject, "country": ManagedGameCountry as AnyObject, "TypePost": "MVP" as AnyObject, "CommunityName": item.Joinedname as AnyObject , "CommunityAvatarUrl": item.JoinedAvatarUrl as AnyObject, "CommunityKey": CommunityKey as AnyObject, "CommunityUID": item.JoineduserUID as AnyObject]
                        
                        let mvpInformation: Dictionary<String, AnyObject> = ["votedName": self.ownerName as AnyObject, "VoteUID": userUID as AnyObject, "VoteAvatarUrl": self.avatarUrl as AnyObject , "VoteTimestamp": ServerValue.timestamp() as AnyObject, "VoteUsertype": MyType as AnyObject, "MVPGameKey": ManagedGameKey as AnyObject]
                        
                        
                        CommunityRef.setValue(communityInformation)
                        mvpPlayerUrl.child("MVP").childByAutoId().setValue(mvpInformation)
                    }
                    
                }
                
                
               
                
                
                
                let HosterUrl = DataService.instance.mainDataBaseRef.child("User").child(ratehosterType).child(rateHosterUID)
                let myUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
                
                
               
                
                
                let CommentInformation: Dictionary<String, AnyObject>  = ["Cmtname": self.ownerName as AnyObject, "CmtUID": userUID as AnyObject, "CmtAvatarUrl": self.avatarUrl as AnyObject , "CmtTimestamp": ServerValue.timestamp() as AnyObject, "CmtUsertype": MyType as AnyObject, "rateStar": starCount as AnyObject, "CmtText": commentText as AnyObject]
                let RatedInformation: Dictionary<String, AnyObject>  = ["RatedGameKey": ManagedGameKey as AnyObject, "RatedTimestamp": ServerValue.timestamp() as AnyObject]

                myUrl.child("Rated_Game").childByAutoId().setValue(RatedInformation)
                HosterUrl.child("Rating").childByAutoId().setValue(CommentInformation)
                
                
                
                
                UndoTheMainMapActivity()
                
                
            }

            
            
        } else {
            
            
            
            let alert = SCLAlertView()
            
            
            _ = alert.showError("Oops!!!", subTitle: "CRACC: Please rate for the star and make a comment for the host to imrpove our community")
            
            
        }
    }
    
    func fitAllMarkers(_path: GMSPath) {
        var bounds = GMSCoordinateBounds()
        for index in 1..._path.count() {
            bounds = bounds.includingCoordinate(_path.coordinate(at: index))
        }
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 150.0))
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        let item = listGameRequest[controlGameIndexed]
        
        if settingGameLocation.text != "" || settingGameTime.text != "" || settingGameNumberOfPeople.text != "" || settingGameName.text != "" {
            //.GamePostRef.child(country).child(type).child(GameKey)
            // cache game my game and joined game and chat list
            let url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("Information")
            let Communityurl = DataService.instance.mainDataBaseRef.child("Community").child(userUID).child(ManageCommunityKey)
            let gameCor = DataService.instance.GameCoordinateRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("l")
            
            if settingGameLocation.text != ""{
                //lon, lat, locationName
                
                if settingLat != nil, settingLon != nil {
                    url.child("lon").setValue(settingLon)
                    url.child("lat").setValue(settingLat)
                    url.child("locationName").setValue(settingGameLocation.text)
                    gameCor.child("1").setValue(settingLon)
                    gameCor.child("0").setValue(settingLat)
                    
                    if temperature != nil {
                        
                        url.child("DescriptionWeather").setValue(DescriptionWeather)
                        url.child("weatherDescription").setValue(typeWeather)
                        url.child("temperature").setValue(temperature)
                        url.child("highTemp").setValue(highTemp)
                        url.child("lowTemp").setValue(lowTemp)
                        
                    }
                    
                    
                    

                    
                   
                    let MyJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("My_Game").child(ManagedGameKey)
                    let MyCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(ManagedGameKey)
                    
                    MyJoinedUrl.child("locationName").setValue(settingGameLocation.text)
                    MyCachedUrl.child("locationName").setValue(settingGameLocation.text)
                    
                    
                    if item.JoinedUserArray.count > 0 {
                        
                        if let CheckedUserArray = item.JoinedUserArray {
                            
                            for items in CheckedUserArray {
                                
                                
                                let frUID = items["JoineduserUID"] as? String
                                let frType = items["Joinedtype"] as? String
                                
                            
                                let frJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Game_Joined").child(ManagedGameKey)
                                let frCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Cached_Game").child(ManagedGameKey)
                                
                                frJoinedUrl.child("locationName").setValue(settingGameLocation.text)
                                frCachedUrl.child("locationName").setValue(settingGameLocation.text)
                            }
                            
                        }
                        
                        
                        
                        
                    }
                }
                
                
            }
            
            if settingGameTime.text != "" {
                
                if timeSetting != nil {
                    timeSetting = timeSetting! * 1000
                    url.child("timePlay").setValue(timeSetting)
                    
                    
                    if temperature != nil {
                        
                        url.child("DescriptionWeather").setValue(DescriptionWeather)
                        url.child("weatherDescription").setValue(typeWeather)
                        url.child("temperature").setValue(temperature)
                        url.child("highTemp").setValue(highTemp)
                        url.child("lowTemp").setValue(lowTemp)
                        
                    }
                    
                    
                    let MyChatUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Chat_List").child(ManageKeyChat)
                    let MyJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("My_Game").child(ManagedGameKey)
                    let MyCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(ManagedGameKey)
                    MyChatUrl.child("time").setValue(timeSetting)
                    MyJoinedUrl.child("timePlay").setValue(timeSetting)
                    MyCachedUrl.child("timePlay").setValue(timeSetting)
                    
                    
                    if item.JoinedUserArray.count > 0 {
                        
                        if let CheckedUserArray = item.JoinedUserArray {
                            
                            for items in CheckedUserArray {
                                
                                
                                let frUID = items["JoineduserUID"] as? String
                                let frType = items["Joinedtype"] as? String
                                
                                let frChatUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Chat_List").child(ManageKeyChat)
                                let frJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Game_Joined").child(ManagedGameKey)
                                let frCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Cached_Game").child(ManagedGameKey)
                                frChatUrl.child("time").setValue(timeSetting)
                                frJoinedUrl.child("timePlay").setValue(timeSetting)
                                frCachedUrl.child("timePlay").setValue(timeSetting)
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                }
            }
            
            if settingGameNumberOfPeople.text != "" {
                
                if let number = settingGameNumberOfPeople.text {
                    
                    url.child("numberOfPeople").setValue(number)
                    
                }

            }
            
            if settingGameName.text != "" {
                
                if let name = settingGameName.text {
                    
                    url.child("name").setValue(name)
                    Communityurl.child("name").setValue(name)
                   
                    
                    let MyChatUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Chat_List").child(ManageKeyChat)
                    let MyJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("My_Game").child(ManagedGameKey)
                    let MyCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(ManagedGameKey)
                    MyChatUrl.child("name").setValue(name)
                    MyJoinedUrl.child("name").setValue(name)
                    MyCachedUrl.child("name").setValue(name)
                    
                    
                    if item.JoinedUserArray.count > 0 {
                        
                        if let CheckedUserArray = item.JoinedUserArray {
                            
                            for items in CheckedUserArray {
                                
                                
                                let frUID = items["JoineduserUID"] as? String
                                let frType = items["Joinedtype"] as? String
                                
                                let frChatUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Chat_List").child(ManageKeyChat)
                                let frJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Game_Joined").child(ManagedGameKey)
                                let frCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Cached_Game").child(ManagedGameKey)
                                frChatUrl.child("name").setValue(name)
                                frJoinedUrl.child("name").setValue(name)
                                frCachedUrl.child("name").setValue(name)
                            }
                            
                        }
                        
                        
                        
                        
                    }
                    
                }
                
                
                
                
            }
            
            
            if self.settingGameView.isHidden == false {
                let alert = JDropDownAlert()
                let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                alert.alertWith("Successfully saved",
                                topLabelColor: UIColor.white,
                                messageLabelColor: UIColor.white,
                                backgroundColor: color)
                
                temperature = nil
                //alreadyLocation = ""
                settingLat = nil
                settingLon = nil
                self.view.endEditing(true)
                inSettingMode = false
                self.settingGameView.isHidden = true
                self.blurView.isHidden = true
                self.ControltMode = .hosterController
                getGameFromManageView(country: ManagedGameCountry, type: ManagedGameType, GameKey: ManagedGameKey)
                
            }
            
        } else {
            
            
            let alert = SCLAlertView()
            
            
            _ = alert.showError("Oops!!!", subTitle: "CRACC: You need to make change at leat one field to update your current game")
            
        }
        
    }
    
    
    @IBAction func cancelThisGameBtnPressed(_ sender: Any) {
        
        
        
        
        
        let item = listGameRequest[controlGameIndexed]
        let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
        let url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey)
        let postDict: Dictionary<String, AnyObject> = ["name": item.gameName as AnyObject, "locationName": item.locationName as AnyObject, "timePlay": item.timePlay as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": item.key as AnyObject, "type": item.type as AnyObject, "country": item.country as AnyObject, "hosterUID": item.OwnerUID as AnyObject, "CommunityKey": item.CommunityKey as AnyObject]
        
        userUrl.child("Match_History").child("Canceled").child("GameCount").childByAutoId().setValue(postDict)
        userUrl.child("Match_History").child("Canceled").child(item.type).childByAutoId().setValue(postDict)
        userUrl.child("Cached_Game").child(item.key).removeValue()
        url.removeValue()
        
        let MyChatUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Chat_List").child(ManageKeyChat)
        let MyJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("My_Game").child(ManagedGameKey)
        let MyCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(ManagedGameKey)
        MyChatUrl.removeValue()
        MyJoinedUrl.child("Canceled").setValue(1)
        MyCachedUrl.removeValue()
        
        
        if item.JoinedUserArray.count > 0 {
            
            if let CheckedUserArray = item.JoinedUserArray {
                
                for items in CheckedUserArray {
                    
                    
                    let frUID = items["JoineduserUID"] as? String
                    let frType = items["Joinedtype"] as? String
                    
                    let frChatUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Chat_List").child(ManageKeyChat)
                    let frJoinedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Game_Joined").child(ManagedGameKey)
                    let frCachedUrl = DataService.instance.mainDataBaseRef.child("User").child(frType!).child(frUID!).child("Cached_Game").child(ManagedGameKey)
                    frChatUrl.removeValue()
                    frJoinedUrl.child("Canceled").setValue(1)
                    frCachedUrl.removeValue()
                }
                
            }
            
            
            
            
        }
        
        self.view.endEditing(true)
        inSettingMode = false
        settingLat = nil
        settingLon = nil
        settingIconImg.image = nil
        temperature = nil
        self.settingGameView.isHidden = true
        self.blurView.isHidden = true
        UndoTheMainMapActivity()
        
        let alert = JDropDownAlert()
        let color = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 0.9)
        alert.alertWith("Successfully canceled",
                        topLabelColor: UIColor.white,
                        messageLabelColor: UIColor.white,
                        backgroundColor: color)
        
        
        
    }
    
    @IBAction func editGameBtnPressed(_ sender: Any) {
        
        inSettingMode = true
        settingIconImg.image = nil
        controlSearch = searchForLocation.settingSearch
        settingGameIcon.image = UIImage(named: setingIcon)
        settingGameName.placeholder = setingGameName
        settingGameLocation.placeholder = setingGameLocation
        settingGameTime.placeholder = setingGameTime
        settingGameNumberOfPeople.placeholder = setingNumberOfPeople
        
        settingGameName.text = ""
        settingGameLocation.text = ""
        settingGameTime.text = ""
        settingGameNumberOfPeople.text = ""
        
        
        blurView.isHidden = false
        settingGameView.isHidden = false
        self.ControltMode = .EditView
    }
    
    @IBAction func settingLocationBtnPressed(_ sender: Any) {
        
        
        controlSearch = searchForLocation.settingSearch
        self.present(autocompleteController, animated: true, completion: nil)
        
        
        
    }
    
    
    
    @IBAction func settingGameTimeBtnPressed(_ sender: Any) {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerView.minimumDate = Date().addingTimeInterval(60 * 60 * 3)
        datePickerView.maximumDate = Date().addingTimeInterval(60 * 60 * 24 * 5)
        
        settingGameTime.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(MapVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
        
    }
    
    @IBAction func settingGameNumberOfPeopleBtnPressed(_ sender: Any) {
        
        
        for x in 1...30 {
            
            let xStr = String(x)
            NumberOfPeople.append(xStr)
            
        }
        
        pickerViewController = pickView.numberOfPeople
        createDayPicker()
        
    }
    // text view
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        rateCommentTxtView.text = ""
    }
    
    
    // open game from game management
    
    
    @objc func openGameFromSideView() {
    

        if ManagedGameKey != "", ManagedGameType != "", ManagedGameCountry != "", ManagehosterUID != "" {

        
            NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "DidTapManageGame")), object: nil)
            NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "DidTapExpGame")), object: nil)
            NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
            
            getGameFromManageView(country: ManagedGameCountry, type: ManagedGameType, GameKey: ManagedGameKey)
            
            
            
        
        } else {
        
          
            
            
            
            let alert = SCLAlertView()
            
            
            _ = alert.showError("Oops!!!", subTitle: "CRACC: Cannot open game, Please try again")
        
        }
    
    }
    
    
    @objc func openRateView() {
        
        
        if ManagedGameKey != "", ManagedGameType != "", ManagedGameCountry != "", ManagehosterUID != "" {
            
            
            starCount = 0
            
            MVPBtn.setImage(nil, for: .normal)
            
            MVPBtn.layer.masksToBounds = true
            MVPBtn.layer.borderColor = UIColor.lightGray.cgColor
            MVPBtn.layer.borderWidth = 1
            MVPBtn.setTitle("MVP", for: .normal)
            
            MVPIndex = nil
            rateHosterUID = ""
            ratehosterType = ""
            
            rateStar1.setImage(nostarImage, for: .normal)
            rateStar2.setImage(nostarImage, for: .normal)
            rateStar3.setImage(nostarImage, for: .normal)
            rateStar4.setImage(nostarImage, for: .normal)
            rateStar5.setImage(nostarImage, for: .normal)
            
            
            rateCommentTxtView.text = "Write comment for hoster here ..."
            
            
            
            NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "DidTapManageGame")), object: nil)
            NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "DidTapExpGame")), object: nil)
            NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
            
            
            OpenRateView(country: ManagedGameCountry, type: ManagedGameType, GameKey: ManagedGameKey)
            
            
            
            
        } else {
            
            
            
            
            let alert = SCLAlertView()
            
            
            _ = alert.showError("Oops!!!", subTitle: "CRACC: Cannot open game, Please try again")
            
        }
        
        
        
        
        
    }
    
    func OpenRateView(country: String, type: String, GameKey: String) {
        
        
        
        
            ChooseMVPPlayerArr.removeAll()
        DataService.instance.GamePostRef.child(country).child(type).child(GameKey).observeSingleEvent(of: .value, with: { (snapInfo) in
            
            
            if snapInfo.exists() {
                
                
                
                
                if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            
                            if let gameName = postDict["name"] as? String, let avatarUrl = postDict["avatarUrl"] as? String, let timePlay = postDict["timePlay"], let type = postDict["type"] as? String, let locationName = postDict["locationName"] as? String {
                                
                                
                                self.blurMap()
                                self.freezeTheMapActivity()
                                self.rateView.isHidden = false
                                self.ControltMode = .rateGameView
                                
                                //
                                
                                self.rateGameName.text = gameName
                                self.rateGameAdd.text = locationName
                                
                                // process timestamp
                                
                                
                                let dateFormatter = DateFormatter()
                                let timeFormatter = DateFormatter()
                                dateFormatter.locale = Locale(identifier: "en_US")
                                timeFormatter.locale = Locale(identifier: "en_US")
                                dateFormatter.dateStyle = DateFormatter.Style.medium
                                timeFormatter.timeStyle = DateFormatter.Style.short
                                let time = (timePlay as? TimeInterval)! / 1000
                                let date = Date(timeIntervalSince1970: time)
                                let Dateresult = dateFormatter.string(from: date)
                                let Timeresult = timeFormatter.string(from: date)
                                self.rateGameDate.text = Dateresult
                                self.rateGameTime.text = Timeresult
                                
                                
                                // process icon
                                
                                let icon = type.lowercased()
                                self.rateGameIcon.image = UIImage(named: icon)
                                
                                // process avatar img
                                
                                
                                if avatarUrl != "nil" {
                                    
                                    if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: avatarUrl).image {
                                        
                                        
                                        
                                        self.rateOwnerAvatarImg.image = ownerImageCached
                                        
                                        
                                    } else {
                                        
                                        
                                        Alamofire.request(avatarUrl).responseImage { response in
                                            
                                            if let image = response.result.value {
                                                
                                                let wrapper = ImageWrapper(image: image)
                                                try? InformationStorage?.setObject(wrapper, forKey: avatarUrl)
                                                self.rateOwnerAvatarImg.image = image
                                                
                                            }
                                            
                                        }
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    self.rateOwnerAvatarImg.image = UIImage(named: "CRACC")
                                    
                                }
                                
                                if let hosterUID = postDict["HosterUID"] as? String {
                                    
                                    
                                    self.rateHosterUID = postDict["HosterUID"] as! String
                                    self.ratehosterType = postDict["HosterType"] as! String
                                    
                                    if hosterUID != userUID {
                                        
                                        let JoinedInformation: Dictionary<String, AnyObject>  = ["Joinedname": postDict["ownerName"] as AnyObject, "JoineduserUID": postDict["HosterUID"] as AnyObject, "JoinedAvatarUrl": postDict["avatarUrl"] as AnyObject , "JoinedTimestamp": postDict["timestamp"] as AnyObject, "Joinedtype": postDict["HosterType"] as AnyObject]
                                        
                                        
                                        let hostData = RecentlyPlayedModel(postKey: item.key, recentlyPlayedModel: JoinedInformation)
                                        self.ChooseMVPPlayerArr.insert(hostData, at: 0)
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                                
                                
                                
                                if let FriendPlayed = postDict["Joined_User"] as? Dictionary<String, Any> {
                                    
                                    for user in FriendPlayed {
                                        
                                        let userDict = user.value as? Dictionary<String, Any>
                                        
                                        let key = user.key
                                        
                                        if key != userUID {
                                            
                                            let mvpData = RecentlyPlayedModel(postKey: key, recentlyPlayedModel: userDict!)
                                            self.ChooseMVPPlayerArr.insert(mvpData, at: 0)
                                            
                                        }
                                        
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                                
                            }
                            
                           
                            
                            
                            
                          
                            
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
            }
            
            
            
        })
        
        
        
    }
    
    
    func getGameFromManageView(country: String, type: String, GameKey: String) {
    
            self.listGameRequest.removeAll()
            self.listMakrer.removeAll()
            //mapView.clear()
        
        
        DataService.instance.GamePostRef.child(country).child(type).child(GameKey).observeSingleEvent(of: .value, with: { (snapInfo) in
            
            
            if snapInfo.exists() {
                
                
                
                
                if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            
                            let key = snapInfo.key
                            let RequestData = requestModel(postKey: key, requestGameList: postDict)
                            self.listGameRequest.insert(RequestData, at: 0)
                            
                            
                            
                            if ManagehosterUID != userUID {
                                
                                self.ControltMode = .GameView
                                self.openNormalGameView(index: 0, markers: nil)
                                
                                
                            } else {
                                
                                self.ControltMode = .hosterController
                                self.openHosterControl(index: 0, marker: nil)
                                
                            }
                            
                            self.blurMap()
                            self.freezeTheMapActivity()
                            self.addGameToMap()
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
                
            }
           
            
            
        })
    
    
    
    }
    

    
    
    
    func setupDefaultMap() {
    
        marker.isFlat = false
        
        // check if Image not nil
        guard IconImage != nil else {
            return
        }
        // resize image to 30-32
        IconImage = resizeImage(image: IconImage!, targetSize: CGSize(width: 28.0, height: 30.0))
        // setup marker icon
        marker.icon = IconImage
        marker.tracksViewChanges = true
    
    
    }
    
    func styleMap() {
    
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "customizedMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
    
    
    
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        
        
        cameraManager.stopCaptureSession()
        
        

        
        
        
    }
    

    func configureLocationService() {
        
        centerMapOnUserLocation()
    }
    
    
    
    @IBAction func GameMangeBtnPressed(_ sender: Any) {
        
        if let container = self.so_containerViewController {
            container.isSideViewControllerPresented = true
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "openGameManageMent")), object: nil)
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "ResetRecentlyPlay")), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(MapVC.openGameFromSideView), name: (NSNotification.Name(rawValue: "DidTapManageGame")), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(MapVC.openRateView), name: (NSNotification.Name(rawValue: "DidTapExpGame")), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(MapVC.openInformationView), name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
           
        }
    
        
    }
    
    
    
    
    
    func SetContentAllignmenttoBtn() {
        createNewGameBtn2.contentHorizontalAlignment = .left
        InformationBtn2.contentHorizontalAlignment = .left
        InterestedBtn2.contentHorizontalAlignment = .left
        communityBtn2.contentHorizontalAlignment = .left
        logoutBtn2.contentHorizontalAlignment = .left
        reportBtn1.contentHorizontalAlignment = .left
        blackListBtn.contentHorizontalAlignment = .left
        termOfUseBtn.contentHorizontalAlignment = .left
        cloneBtn.contentHorizontalAlignment = .left
        bullyBtn.contentHorizontalAlignment = .left
        defamesBtn.contentHorizontalAlignment = .left
        spamBtn.contentHorizontalAlignment = .left
        fakeBtn.contentHorizontalAlignment = .left
        cheatBtn.contentHorizontalAlignment = .left
        otherBtn.contentHorizontalAlignment = .left
        
        
    }
    
    
    @IBAction func termOfUserBtn1Pressed(_ sender: Any) {
        //moveToTermOfUserVC
        self.performSegue(withIdentifier: "moveToTermOfUserVC", sender: nil)
    }
    
    @IBAction func termOfUserBtn2Pressed(_ sender: Any) {
        self.performSegue(withIdentifier: "moveToTermOfUserVC", sender: nil)
    }
    
    // setup camera
    
    func setupCamera() {
    
        // load first orientation
        
        orientation = "front"
        
        // ask for permission camera user
        cameraManager.showAccessPermissionPopupAutomatically = true
        // set default output
        cameraManager.cameraOutputMode = .stillImage
        
        
        // check camera condition and use
        
        let currentCameraState = cameraManager.currentCameraStatus()
        
        
        if currentCameraState == .notDetermined {
            
            askForPermission()
            
        } else {
            addCameraToView()
        }
        
        cameraManager.flashMode = .auto
    
    
    
    }
    
    
    // private func add camera to view
    
    fileprivate func addCameraToView()
        
        
    {
        
        cameraManager.cameraDevice = .front
        
        
        // camera camera view
        _ = cameraManager.addPreviewLayerToView(cameraView)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
            
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // ask for permission for the first time
    
    fileprivate func askForPermission() {
        cameraManager.askUserForCameraPermission({ permissionGranted in
            if permissionGranted {
                self.addCameraToView()
            }
        })
    }
    
    
    
    // chat button setup
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        
        
        tableControl = tableViewControl.chatList
        ControltMode = .chatViewMode
        chatView.isHidden =  false
        
        blurMap()
        freezeTheMapActivity()
        
        
        getAddChat() {
            
            self.getlistChat()
            
        }
        
        // add gesture to close when necessary
        
        
    }
    
    func blurMap() {
        
        
        self.mapView.backgroundColor = UIColor.darkGray
        self.mapView.alpha = 0.4
        self.navigationVC.alpha = 0.4
        self.locationBtn.alpha = 0.4
        
        
        view.endEditing(true)
        myLocationSearchBar.isHidden = true
        destinationSearchBar.isHidden = true
        self.requestGameView.isHidden = true
        self.openRequestGameView.isHidden = true
        
        
        
        
    }
    
    func freezeTheMapActivity() {
        
        
        self.mapView.isUserInteractionEnabled = false
        self.locationBtn.isUserInteractionEnabled = false
        self.chatImage.isUserInteractionEnabled = false
        self.GameManagementImage.isUserInteractionEnabled = false
        self.profileBtn.isUserInteractionEnabled = false
        
        // hold the open
        
        
        
        
    }
    
    @objc func UndoTheMainMapActivity() {
        
        self.mapView.isUserInteractionEnabled = true
        self.locationBtn.isUserInteractionEnabled = true
        self.chatImage.isUserInteractionEnabled = true
        self.GameManagementImage.isUserInteractionEnabled = true
        self.profileBtn.isUserInteractionEnabled = true
        
        
        
        // undo blur
        
        self.mapView.backgroundColor = UIColor.clear
        self.mapView.alpha = 1.0
        self.navigationVC.alpha = 1.0
        self.locationBtn.alpha = 1.0
        
        // hide unecessaryView
        profileView.isHidden =  true
        chatView.isHidden = true
        InformationView.isHidden = true
        controlGameView.isHidden = true
        createGameView.isHidden = true
        ChooseGameTypeView.isHidden = true
        addChatView.isHidden = true
        hosterController.isHidden = true
        gameListView.isHidden = true
        rateView.isHidden = true
        controlPeopleView.isHidden = true
        addChatView.isHidden = true
        blurView.isHidden = true
        blurView2.isHidden = true
        
        ControltMode = ControlView.Done
        
        // stop camera session
        cameraManager.stopCaptureSession()
        
        // unhide search bar
        
        
        
        view.endEditing(true)
        myLocationSearchBar.isHidden = false
        ControllCollection = collectionViewControll.requestGame
        
        CloseGameView()
        
        
        
    }
        
    @IBAction func openCameraVC(_ sender: Any) {
        
        
        DoneUrl = nil
        self.performSegue(withIdentifier: "moveToCamersVC", sender: nil)
        
    
        
        
        
    }
    
    @IBAction func openGamView(_ sender: Any) {
        
        
        self.collectionView.reloadData()
        ControllCollection = collectionViewControll.requestGame
        self.openRequestGameView.isHidden = true
        self.requestGameView.isHidden = false
        
       
        
        
        
        
    }
    
    @IBAction func closeGameViewBtnPressed(_ sender: Any) {
        
        CloseGameView()
        
        
    }
    
    func CloseGameView() {
        
        self.openRequestGameView.isHidden = false
        self.requestGameView.isHidden = true
        
    }
    @IBAction func seclectionAfterFinishRecordBtnPressed(_ sender: Any) {
        
        
        
        let sheet = UIAlertController(title: "Choose option with recorded video?", message: "", preferredStyle: .actionSheet)
        
        
        let watchItAgain = UIAlertAction(title: "Watch it again", style: .default) { (alert) in
            
            self.WatchVideoAgain()
            
        }
        
        let delete = UIAlertAction(title: "Delete", style: .default) { (alert) in
            
           self.deleteVideo()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        
        sheet.addAction(watchItAgain)
        sheet.addAction(delete)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func WatchVideoAgain() {
    
    
        videoLoader.startAnimating()
        self.containerView.addGestureRecognizer(swipeBack)
        self.playController.showsPlaybackControls = false
        self.playController.view.isUserInteractionEnabled = false
        playController.removeFromParent()
        cameraManager.stopCaptureSession()
        self.containerView.isHidden = false

        
        if let url = DoneUrl {
            
            DispatchQueue.main.async {
                self.playerVideo = AVPlayer(url: url)
                self.playController.player = self.playerVideo
                self.playController.view.frame = self.view.frame
                self.addChild(self.playController)
                self.playVideoView.addSubview(self.playController.view)
                self.playerVideo.isMuted = false
                
                self.videoLoader.stopAnimating()
                self.playerVideo.play()
                
                
                NotificationCenter.default.addObserver(self, selector: #selector(MapVC.replay(note:)),
                                                       name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerVideo.currentItem)
                
            }
            
            
            
        }
    
    
    
    }
    
    func watchIntroVid() {
        
        videoLoader.startAnimating()
        self.containerView.addGestureRecognizer(swipeBack)
        self.playController.showsPlaybackControls = false
        self.playController.view.isUserInteractionEnabled = false
        playController.removeFromParent()
        self.containerView.isHidden = false
        
        let path = Bundle.main.path(forResource: "Intro", ofType:"mp4")
        let url = NSURL.fileURL(withPath: path!)
        self.playerVideo = AVPlayer(url: url)
        self.playController.player = self.playerVideo
        self.playController.view.frame = self.view.frame
        self.addChild(self.playController)
        self.playVideoView.addSubview(self.playController.view)
        self.playerVideo.isMuted = false
        
        self.videoLoader.stopAnimating()
        self.playerVideo.play()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.close(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerVideo.currentItem)
        
    }
    
    @objc func close(note: NSNotification) {
        
        self.containerView.removeGestureRecognizer(swipeBack)
        self.containerView.isHidden = true
        self.playerVideo.pause()
        playController.removeFromParent()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerVideo.currentItem)
        self.playerVideo = nil
    }
    
    func deleteVideo() {
    
        if DoneUrl != nil {
            DoneUrl = nil
            
            DoneRecordedView.isHidden = true
            openCameraView.isHidden = false
            
        }
        
        self.cameraManager.resumeCaptureSession()
    
    }
    
    @objc func replay(note: NSNotification) {
        
        DispatchQueue.main.async {
            self.playerVideo.seek(to: CMTime.zero)
            self.playerVideo.play()
            
            
        }
        
    }
    
    
    
    
    @IBAction func reportBtnPressed(_ sender: Any) {
        
        
        reportView.isHidden = false
        
        
    }
    
    
    
    
    @IBAction func SettingBtnPressed(_ sender: Any) {
        ControltMode = .ProfileViewMode
        
        
        
        
        profileView.isHidden =  false
        
        
        
        let RequestUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Friend_Request")
        let Game_RequestUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Game_Request")
        
        
        
        RequestUrl.observeSingleEvent(of: .value, with: { (RequestRecent) in
            
            if RequestRecent.exists() {
                self.friendRequestCount.isHidden = false
                let count = String(RequestRecent.childrenCount)
                if RequestRecent.childrenCount >= 10 {
                    
                    self.friendRequestCount.text = "+"
                    
                } else {
                    
                    self.friendRequestCount.text = count
                }
                
            } else {
                
                self.friendRequestCount.isHidden = true
                
            }
            
        })
        
        
        Game_RequestUrl.observeSingleEvent(of: .value, with: { (Request) in
            
            if Request.exists() {
                self.blacklistCount.isHidden = false
                let count = String(Request.childrenCount)
                if Request.childrenCount >= 10 {
                    
                    self.blacklistCount.text = "+"
                    
                } else {
                    
                    self.blacklistCount.text = count
                }
                
            } else {
                
                self.blacklistCount.isHidden = true
                
            }
            
        })
        
        
        
        
        
        
     
        blurMap()
        freezeTheMapActivity()
        // add gesture to close when necessary
        
    
        
        
    }
    
    @IBAction func CenterMyLocation(_ sender: Any) {
        
        centerMapOnUserLocation()
    }
    // Profile setting btn
    @IBAction func createNewGameBtnPressed(_ sender: Any) {
        
        
        ControltMode = ControlView.CreateNewGame
        profileView.isHidden = true
        createGameView.isHidden =  false
        if containerView.isHidden == true {
            setupCamera()
        }
        cameraManager.resumeCaptureSession()
        blurMap()
        freezeTheMapActivity()
        
        // add gesture to close when necessary
     
    }
    @IBAction func createNewGameBtn2Pressed(_ sender: Any) {
        
        ControltMode = ControlView.CreateNewGame
        profileView.isHidden = true
        createGameView.isHidden =  false
        setupCamera()
        cameraManager.resumeCaptureSession()
        blurMap()
        freezeTheMapActivity()
        // add gesture to close when necessary
      
    }
    
    @IBAction func InfomationBtnPressed(_ sender: Any) {
        
        
        InfoUID = userUID
        InfoType = userType
        openInformationView()

    }
    
    
    func openMyInformationView(UID: String?, Type: String?, completed: @escaping DownloadComplete) {
        
        
        if UID != userUID {
            informationSetting.isHidden = true
            reportBtn.isHidden = false
            
        } else {
            informationSetting.isHidden = false
            reportBtn.isHidden = true
            
        }
        
        
        self.commentUserArr.removeAll()
        
        let userUrl = DataService.instance.mainDataBaseRef.child("User").child(Type!).child(UID!)
        
        
        
        
        
        userUrl.child("Match_History").child("Information").observeSingleEvent(of: .value, with: { (Info) in
            
            if let InfoDict = Info.value as? Dictionary<String, Any> {
                
                let date = Date()
                let calendar = Calendar.current
                
                let year = calendar.component(.year, from: date)
                
                
                if let BirthYear = InfoDict["Birthday"] as? String, let avatar =  InfoDict["avatarUrl"] as? String, let lastTimePlay = InfoDict["LastTimePlayed"], let name = InfoDict["Name"] as? String{
                    
                    
                userUrl.child("Match_History").child("Game_Played").child("GameCount").observeSingleEvent(of: .value, with: { (countInfo) in
                    
                    
                        if countInfo.exists() {
                        
                            self.informationGameCount.text = String(countInfo.childrenCount)
                        
                        } else {
                            
                            self.informationGameCount.text = "0"
                            
                        }
                        
                        
                    })
                    
                    
                userUrl.child("Match_History").child("Canceled").child("GameCount").observeSingleEvent(of: .value, with: { (CanceledInfo) in
                    
                    
                    if CanceledInfo.exists() {
                        
                        
                        self.informationCanceledGame.text = String(CanceledInfo.childrenCount)
                        
                    } else {
                        
                        self.informationCanceledGame.text = "0"
                        
                    }
                        
                    })
                    
                    
                    
                    if (BirthYear.contains(",")) {
                        
                        var isBirthday = false
                        var FinalBirthday = [String]()
                        
                        
                        let testBirthdaylArr = Array(BirthYear)
                        
                        
                        for i in testBirthdaylArr  {
                            
                            if isBirthday == false {
                                
                                if i == "," {
                                    
                                    isBirthday = true
                                    
                                }
                                
                            } else {
                                
                                let num = String(i)
                                
                                
                                FinalBirthday.append(num)
                                
                            }
                            
                        }
                        
                        
                        let result = FinalBirthday.dropFirst()
                        if let bornYear = Int(result.joined()) {
                            
                            
                            
                            let currentAge = year - bornYear
                            self.informationAge.text = String(currentAge)
                            
                        }
                        
                        
                        
                    } else {
                        
                        let finalBirthday = Int(BirthYear)
                        let age = year  - finalBirthday!
                        self.informationAge.text = String(age)
                        
                    }
                    

                    self.InformationNameLbl.text = name
                    
                    
                    //
                    
                    // process timestamp
                    let dateFormatter = DateFormatter()
                    let timeFormatter = DateFormatter()
                    dateFormatter.dateStyle = DateFormatter.Style.medium
                    timeFormatter.timeStyle = DateFormatter.Style.short
                    
                    
                    
                    if lastTimePlay is String {
                        
                        self.informationLastGamePlayed.text = ""
                        
                    } else {
                        var time: TimeInterval
                        time = (lastTimePlay as? TimeInterval)! / 1000
                        
                        let date = Date(timeIntervalSince1970: time)
                        let Dateresult = dateFormatter.string(from: date)
                        self.informationLastGamePlayed.text = Dateresult
                        
                    }
                    
                    if avatar != "nil" {
                        
                        if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: avatar).image {
                            
                            
                            
                            self.InformationImgView.image = ownerImageCached
                            
                            
                        } else {
                            
                            
                            Alamofire.request(avatar).responseImage { response in
                                
                                if let image = response.result.value {
                                    
                                    let wrapper = ImageWrapper(image: image)
                                    try? InformationStorage?.setObject(wrapper, forKey: avatar)
                                    self.InformationImgView.image = image
                                    
                                }
                                
                            }
                            
                            
                            
                            
                            
                        }
                        
                    } else {
                        
                        
                        
                        self.InformationImgView.image = UIImage(named: "CRACC")
                    }
                    
                    
                    
                    
                    
                    
                    
                }
            
            
                
            }
            
        
            
        })
        
        userUrl.child("Rating").queryOrdered(byChild: "CmtTimestamp").queryLimited(toLast: 20).observeSingleEvent(of: .value, with: { (snapInfos) in
            
            
            if snapInfos.exists() {
                
                if let snap = snapInfos.children.allObjects as? [DataSnapshot] {
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            
                            
                            if UID != postDict["CmtUID"] as? String {
                                
                                let key = snapInfos.key
                                
                                
                                let CmtData = CommentModel(postKey: key, CommentModel: postDict)
                                self.commentUserArr.insert(CmtData, at: 0)
                            }
                            
                            
                            
                        }
                        
                        
                        
                        
                    }
                    
                    
                     completed()
                }
                
            } else {
                
                completed()
                
                
                
            }
            
            
            
        })
       
        
        
        
        
        
    }
    
    func loadCommentAndCountStar() {
        
        
        
        
        
        if commentUserArr.isEmpty != true {
            
            tableControl = tableViewControl.commentList
            
            
            var starArray = [Int]()
            
            self.informationTableView.reloadData()
            
            for i in commentUserArr {
                
                
                if let star = i.rateStar {
                    
                    starArray.append(star)
                    
                }
                
                
            }
            
            
            
            
            let starAverage = starArray.average
            
            
            if starAverage >= 4.5 {
                
                
                informationStar1.setImage(starImage, for: .normal)
                informationStar2.setImage(starImage, for: .normal)
                informationStar3.setImage(starImage, for: .normal)
                informationStar4.setImage(starImage, for: .normal)
                informationStar5.setImage(starImage, for: .normal)
                
                //5
            } else if starAverage > 3.5, starAverage < 4.5 {
                
                informationStar1.setImage(starImage, for: .normal)
                informationStar2.setImage(starImage, for: .normal)
                informationStar3.setImage(starImage, for: .normal)
                informationStar4.setImage(starImage, for: .normal)
                
                //4
                
                informationStar5.setImage(nostarImage, for: .normal)
                
            } else if starAverage > 2.5, starAverage < 3.5 {
                
                
                informationStar1.setImage(starImage, for: .normal)
                informationStar2.setImage(starImage, for: .normal)
                informationStar3.setImage(starImage, for: .normal)
                //3
                
                
                informationStar4.setImage(nostarImage, for: .normal)
                informationStar5.setImage(nostarImage, for: .normal)
                
            } else if starAverage > 1.5, starAverage < 2.5 {
                
                informationStar1.setImage(starImage, for: .normal)
                informationStar2.setImage(starImage, for: .normal)
                
                //2
                
                informationStar3.setImage(nostarImage, for: .normal)
                informationStar4.setImage(nostarImage, for: .normal)
                informationStar5.setImage(nostarImage, for: .normal)
                
            } else {
                informationStar1.setImage(starImage, for: .normal)
                
                //1
                
                
                
                informationStar2.setImage(nostarImage, for: .normal)
                informationStar3.setImage(nostarImage, for: .normal)
                informationStar4.setImage(nostarImage, for: .normal)
                informationStar5.setImage(nostarImage, for: .normal)
                
            }
            
            
            
            
        } else {
            
            informationTableView.reloadData()
            informationStar1.setImage(starImage, for: .normal)
            informationStar2.setImage(starImage, for: .normal)
            informationStar3.setImage(starImage, for: .normal)
            informationStar4.setImage(starImage, for: .normal)
            informationStar5.setImage(starImage, for: .normal)
            
            
        }
        
        
        
    }
    

    
    
    
    
    @IBAction func InterestedBtnPressed(_ sender: Any) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.openInformationView), name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
        self.performSegue(withIdentifier: "moveToInterestedVC", sender: nil)
        
    }
    @IBAction func InterestedBtn2Pressed(_ sender: Any) {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(MapVC.openInformationView), name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
        self.performSegue(withIdentifier: "moveToInterestedVC", sender: nil)
        
    }
    @IBAction func communityBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCommunityVC", sender: nil)
    }
    
    @IBAction func communityBtn2Pressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToCommunityVC", sender: nil)

    }
    
    
    @IBAction func information2Btnpressed(_ sender: Any) {
        InfoUID = userUID
        InfoType = userType
        openInformationView()
        
    }
    
    
    @objc func openInformationView() {
        
        openInformation()
        
    }
    
    
    func openInformation() {
        
        UndoTheMainMapActivity()
        ControltMode = .InformationViewMode
        profileView.isHidden = true
        InformationView.isHidden =  false
        
        blurMap()
        freezeTheMapActivity()
        // add gesture to close when necessary
        NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "OpenUserInformation")), object: nil)
        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "getRecentlyPlayed")), object: nil)
        
        
        openMyInformationView(UID: InfoUID, Type: InfoType){
            self.loadCommentAndCountStar()
        }
        
    }
    
    @IBAction func logOutBtnPressed(_ sender: Any) {

        Logout()

    }
    
    
    func Logout() {
     
        let instance = InstanceID.instanceID()
        _ = InstanceID.deleteID(instance)
        InstanceID.instanceID().deleteID { (err:Error?) in
            if err != nil{
                print(err.debugDescription);
            } else {
                print("Token Deleted");
            }
        }
        
        try! Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        
        try? InformationStorage?.removeAll()
        DataService.instance.mainDataBaseRef.removeAllObservers()
        self.performSegue(withIdentifier: "GoBackToSignInVC", sender: nil)
    
    
    }
    
    
    
    
    @IBAction func logOutBtn2Pressed(_ sender: Any) {
        
        Logout()
    }
    
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "goToSettingVC", sender: nil)
        
        
        
        
    }
    
    
    @IBAction func getDirectionBtnPressed(_ sender: Any) {
        
        let origin = "\(OriginalLocation.coordinate.latitude),\(OriginalLocation.coordinate.longitude)"
        let destination = "\(destinationLocation.coordinate.latitude),\(destinationLocation.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&sensor=true&key=\(GoogleMap_key)"
        print(url)
        self.polyline.map = nil
        destinationSearchBar.isHidden = false
        destinationLbl.text = destinationName
        Alamofire.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                self.path = GMSPath.init(fromEncodedPath: points!)!
                self.polyline = GMSPolyline.init(path: self.path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.red
                self.polyline.map = self.mapView
                
                
                self.fitAllMarkers(_path: self.path)
            }
            
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: OriginalLocation.coordinate.latitude, longitude: OriginalLocation.coordinate.longitude, zoom: 14)
        mapView.animate(to: camera)
        self.UndoTheMainMapActivity()
        
        
        
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first! as UITouch? {
            let touchedtPoint = touch.location(in: self.view)
            
            switch (ControltMode) {
                
            case .termView:
                if termView.frame.contains(touchedtPoint) {
                    
                    
                } else {
                    
                    
                }
            case .ProfileViewMode:
                if profileView.frame.contains(touchedtPoint) {
                    print("Nothing")
                
                } else {
                
                    UndoTheMainMapActivity()
                
                }
            case .chatViewMode:
                if chatView.frame.contains(touchedtPoint) {
                    
                    
                } else {
                    
                    UndoTheMainMapActivity()
                    
                }
            case .InformationViewMode:
                if InformationView.frame.contains(touchedtPoint) {
                    
                    
                } else {
                    
                    UndoTheMainMapActivity()
                    
                }
                
            case .CreateNewGame:
                if createGameView.frame.contains(touchedtPoint) {
                    self.view.endEditing(true)
                    
                    if self.ChooseGameTypeView.isHidden == false {
                        
                        if isAnimated == true {
                            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                                self.gameListView.center.y += self.gameListView.frame.height - 100
                            }, completion: nil)
                            isAnimated = false
                        }
                        
                        
                        self.ChooseGameTypeView.isHidden = true
                        self.blurView.isHidden = true
                        
                    }
                    
                } else {
                    
                    
                    if isAnimated == true {
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                            self.gameListView.center.y += self.gameListView.frame.height - 100
                        }, completion: nil)
                        isAnimated = false
                    }
                    
                    UndoTheMainMapActivity()
                    
                }
                
            case .GameView:
                if controlGameView.frame.contains(touchedtPoint) {
                    
                    
                    
                } else {
                    
                    if self.containerView.isHidden != false {
                        
                        if isAnimated == true {
                            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                                self.gameListView.center.y += self.gameListView.frame.height - 100
                            }, completion: nil)
                            isAnimated = false
                        }

                        UndoTheMainMapActivity()
                    
                    }
                    
                    
                    
                }
            case .hosterController:
                if hosterController.frame.contains(touchedtPoint) {
                    
                    
                    
                } else {
                    
                    if self.containerView.isHidden != false {
                        
                        if isAnimated == true {
                            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                                self.gameListView.center.y += self.gameListView.frame.height - 100
                            }, completion: nil)
                            isAnimated = false
                        }
                        
                        UndoTheMainMapActivity()
                        
                    }
                    
                    
                    
                }
                
            case .gameListView:
                
                if gameListView.frame.contains(touchedtPoint) {
                    
                    
                    
                } else {
                    
                    
                    
                    
                    
                    if isAnimated == true {
                        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                            self.gameListView.center.y += self.gameListView.frame.height - 100
                        }, completion: nil)
                        isAnimated = false
                    }
                   
                   UndoTheMainMapActivity()
                    
                    
                    
                }
                
            case .rateGameView:
                
                if rateView.frame.contains(touchedtPoint) {
                    
                    
                    if self.MVPView.isHidden == false {
                        
                        self.MVPView.isHidden = true
                        self.blurView.isHidden = true
                        
                    }
                    
                    self.view.endEditing(true)
                    
                } else {
                    
                    
                   
                    UndoTheMainMapActivity()
                    
                    
                    
                }
                
            case .addChatView:
                
                if addChatView.frame.contains(touchedtPoint) {
                    
                    if isKeyboard == true {
                        
                        self.view.endEditing(true)
                        
                    }
                    
                } else {
                    
                    if isKeyboard == true {
                        
                        self.view.endEditing(true)
                        
                    } else {
                        
                        if addChatView.isHidden != true {
                            
                            addChatView.isHidden = true
                            blurView2.isHidden = true
                            self.ControltMode = .chatViewMode
                            
                            if index.isEmpty != true {
                                
                                index.removeAll()
                                
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                
            case .controlPeopleView:
                if controlPeopleView.frame.contains(touchedtPoint) {
                    
                    
                } else {
                    
                    
                    if self.controlPeopleView.isHidden == false {
                        
                        self.controlPeopleView.isHidden = true
                        self.blurView.isHidden = true
                        self.ControltMode = .hosterController
                        getGameFromManageView(country: ManagedGameCountry, type: ManagedGameType, GameKey: ManagedGameKey)
                        
                    }
                    
                    
                    
                    
                    
                }
                
            case .EditView:
                if settingGameView.frame.contains(touchedtPoint) {
                    
                    self.view.endEditing(true)
                    
                } else {
                    
                    
                    
                    if self.settingGameView.isHidden == false {
                        
                        self.view.endEditing(true)
                        inSettingMode = false
                        settingLat = nil
                        settingLon = nil
                        settingIconImg.image = nil
                        temperature = nil
                        self.settingGameView.isHidden = true
                        self.blurView.isHidden = true
                        self.ControltMode = .hosterController
                        getGameFromManageView(country: ManagedGameCountry, type: ManagedGameType, GameKey: ManagedGameKey)
                        
                    }
                    
                    
                    
                }
                
            default:
                print("Done")
            }
        
        
        
        }
        

    }
    
    
    @IBAction func openSearchPlaceBtnPressed(_ sender: Any) {
        
        
        controlSearch = searchForLocation.normalSearch
        self.present(autocompleteController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func chooseAgeBtnPressed(_ sender: Any) {
        
        
        for x in 10...100 {
            
            let xStr = String(x)
            MaxAge.append(xStr)
            MinAge.append(xStr)
            
        }
        
        pickerViewController = pickView.age
        createDayPicker()
    }
    
    @IBAction func chooseGenderBtnPressed(_ sender: Any) {
        
        pickerViewController = pickView.gender
        createDayPicker()
        
    }
    
    @IBAction func inviteFriendBtnPressed(_ sender: Any) {
        
    }
    
    @IBAction func TypeGameBtnPressed(_ sender: Any) {
        
        ControllCollection = collectionViewControll.CreateGame
        self.blurView.isHidden = false
        self.ChooseGameTypeView.isHidden = false
        self.chooseGameTypeCollectionView.reloadData()
        
        
    }
    
    
    @IBAction func LocationTxtField(_ sender: Any) {
        
        controlSearch = searchForLocation.CreateSearch
        self.present(autocompleteController, animated: true, completion: nil)
        
    }
    
    @IBAction func dateTxtField(_ sender: Any) {
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerView.minimumDate = Date().addingTimeInterval(60 * 60 * 3)
        datePickerView.maximumDate = Date().addingTimeInterval(60 * 60 * 24 * 5)

        dateLbl.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(MapVC.datePickerValueChanged), for: UIControl.Event.valueChanged)
        
    }
    
    @IBAction func joinNowBtnPressed(_ sender: Any) {
        
       
        
        
        if keyChat != "", nameGroupChat != "", hosterUID != "", timePLay != nil , typeChosen != "", countryOfGameViewed != "", gameKeyJoined != "", ownerName != "", userUID != "", avatarUrl != "", locationJoined != "", JoinedIndex != nil, JoinedhosterUID != "", numberOfPeople != nil{
            
            let banUrl = DataService.instance.mainDataBaseRef.child("Kicked_Game").child(ManagedGameKey).child(userUID)
            
            banUrl.observeSingleEvent(of: .value, with: { (snapInfo) in
                
                if snapInfo.exists() {
                    
                    
                    DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Requested").child(ManagedGameKey).observeSingleEvent(of: .value, with: { (snap) in
                        
                        
                        if snap.exists() {
                            
                            let appearance = SCLAlertView.SCLAppearance(dynamicAnimatorActive: true)
                            _ = SCLAlertView(appearance: appearance).showNotice("Oops !!!", subTitle: "You have already requested to join this game !!!!")
                            
                            
                        } else {
                            
                            let appearance = SCLAlertView.SCLAppearance(
                                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                                showCloseButton: false,
                                dynamicAnimatorActive: true,
                                buttonsLayout: .horizontal
                            )
                            let alert = SCLAlertView(appearance: appearance)
                            _ = alert.addButton("Cancel") {
                                
                            }
                            _ = alert.addButton("Request") {
                                
                                let url = DataService.instance.mainDataBaseRef.child("User").child(self.hosterType!).child(self.hosterUID!).child("Game_Request").childByAutoId()
                                let key = url.key
                                let RequestedInformation: Dictionary<String, AnyObject>  = ["Requestedname": self.ownerName as AnyObject, "RequesteduserUID": userUID as AnyObject, "RequestedTimestamp": ServerValue.timestamp() as AnyObject, "Requestedtype": userType as AnyObject, "timePlay": self.timePLay as AnyObject,"RequestedGameName": self.nameGroupChat as AnyObject,"RequestedGameID": self.gameKeyJoined as AnyObject, "RequestedGametype": self.typeChosen as AnyObject, "Requestedcountry": self.countryOfGameViewed as AnyObject,"RequestedchatKey": self.keyChat as AnyObject, "RequestedKey": key as AnyObject, "RequestNumberOfPeople": self.numberOfPeople as AnyObject, "RequestedlocationName": self.locationJoined as AnyObject]
                                
                                
                                let myUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Requested")
                                url.setValue(RequestedInformation)
                                myUrl.child(ManagedGameKey).setValue(1)
                                
                                
                                
                                self.joinNowBtn.setTitle("Requested", for: .normal)
                                let alert = JDropDownAlert()
                                
                                let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                                alert.alertWith("Requested sent",
                                                topLabelColor: UIColor.white,
                                                messageLabelColor: UIColor.white,
                                                backgroundColor: color)
                                
                                
                            }
                            
                            let icon = UIImage(named:"CRACC")
                            let color = UIColor(red: 72/255, green: 172/255, blue: 233/255, alpha: 1.0)
                            
                            _ = alert.showCustom("Oopps !!!", subTitle: "CRACC: Because you has been kicked out by the host of this game, you need to request and get an approval to join again", color: color, icon: icon!)
                            
                        }
                        
                        
                        
                        
                    })
                    
                } else {
                    
                    self.joinNowBtn.isHidden = true
                    self.inviteAndLeaveView.isHidden = false
                    
                    
                    
                    if let CachedType = try? InformationStorage?.object(ofType: String.self, forKey: "type"){
                        
                        let CommunityRef = DataService.instance.mainDataBaseRef.child("Community").child(userUID).childByAutoId()
                        let CommunityKey = CommunityRef.key
                        
                        if self.numberOfPeople == 0 {
                            
                            let JoinedInformation: Dictionary<String, AnyObject>  = ["Joinedname": self.ownerName as AnyObject, "JoineduserUID": userUID as AnyObject, "JoinedAvatarUrl": self.avatarUrl as AnyObject , "JoinedTimestamp": ServerValue.timestamp() as AnyObject, "Joinedtype": CachedType as AnyObject]
                            
                            let chatInformation: Dictionary<String, AnyObject> = ["name":  self.nameGroupChat as AnyObject, "time": self.timePLay as AnyObject, "chatKey": self.keyChat as AnyObject, "HosterUID": self.hosterUID as AnyObject, "isGroup": 1 as AnyObject, "GameID": self.gameKeyJoined as AnyObject, "type": self.typeChosen as AnyObject, "Country": self.countryOfGameViewed as AnyObject]
                            let GameInformation: Dictionary<String, AnyObject> = ["name": self.nameGroupChat as AnyObject, "locationName": self.locationJoined as AnyObject, "timePlay": self.timePLay as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": self.gameKeyJoined as AnyObject, "type": self.typeChosen as AnyObject, "country": self.countryOfGameViewed as AnyObject, "hosterUID": self.JoinedhosterUID as AnyObject, "CommunityKey": CommunityKey as AnyObject, "Canceled": 0 as AnyObject]
                            
                            let info: Dictionary<String, AnyObject> = ["chatKey": self.gameKeyJoined! as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "avatarUrl": self.avatarUrl as AnyObject]
                            
                            
                            let communityInformation: Dictionary<String, AnyObject> = ["name": self.nameGroupChat as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": self.gameKeyJoined as AnyObject, "type": self.typeChosen as AnyObject, "country": self.countryOfGameViewed as AnyObject, "TypePost": "Joined" as AnyObject, "CommunityName": self.ownerName as AnyObject , "CommunityAvatarUrl": self.avatarUrl as AnyObject, "CommunityKey": CommunityKey as AnyObject, "CommunityUID": userUID as AnyObject]
                            
                            
                            let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "Joined" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject, "gameType": self.typeChosen as AnyObject]
                            
                            
                            
                            
                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                            
                            
                            let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
                            
                            
                            
                            CommunityRef.setValue(communityInformation)
                            let url = DataService.instance.GamePostRef.child(self.countryOfGameViewed!).child(self.typeChosen!).child(self.gameKeyJoined!).child("Information").child("Joined_User").child(userUID)
                            
                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(self.gameKeyJoined!).setValue(GameInformation)
                            
                            
                            
                            
                            
                            userUrl.child("Chat_List").child(self.keyChat!).setValue(chatInformation)
                            
                            userUrl.child("Game_Joined").child(self.gameKeyJoined!).setValue(GameInformation)
                            
                            
                            url.setValue(JoinedInformation)
                            DataService.instance.GameChatRef.child(self.keyChat!).child("user").child(userUID).setValue(info)
                            
                            
                            

                            let Url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("Information").child("Joined_User")
                            
                            Url.observeSingleEvent(of: .value, with: { (snapIn) in
                                
                                if snapIn.exists() {
                                    
                                    let count = snapIn.childrenCount
                                    
                                    
                                    self.numberOfPeopleGameView.text = String(count) + " out of " + String(ManageNumberOfPeple)
                                    
                                }
                                
                                
                                
                            })
                            
                            
                            
                            let alert = JDropDownAlert()
                            
                            let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                            alert.alertWith("Successfully Joined",
                                            topLabelColor: UIColor.white,
                                            messageLabelColor: UIColor.white,
                                            backgroundColor: color)
                            
                        } else {
                            
                            
                            DataService.instance.GamePostRef.child(self.countryOfGameViewed!).child(self.typeChosen!).child(self.gameKeyJoined!).child("Joined_User").observeSingleEvent(of: .value, with: { (snapInfo) in
                                
                                
                                if snapInfo.exists() {
                                    
                                    let count = Int(snapInfo.childrenCount)
                                    
                                    
                                    if let joinedCount = self.numberOfPeople {
                                        
                                        if count < joinedCount {
                                            
                                            let JoinedInformation: Dictionary<String, AnyObject>  = ["Joinedname": self.ownerName as AnyObject, "JoineduserUID": userUID as AnyObject, "JoinedAvatarUrl": self.avatarUrl as AnyObject , "JoinedTimestamp": ServerValue.timestamp() as AnyObject, "Joinedtype": CachedType as AnyObject]
                                            
                                            let chatInformation: Dictionary<String, AnyObject> = ["name":  self.nameGroupChat as AnyObject, "time": self.timePLay as AnyObject, "chatKey": self.keyChat as AnyObject, "HosterUID": self.hosterUID as AnyObject, "isGroup": 1 as AnyObject, "GameID": self.gameKeyJoined as AnyObject,"type": self.typeChosen as AnyObject, "Country": self.countryOfGameViewed as AnyObject]
                                            let GameInformation: Dictionary<String, AnyObject> = ["name": self.nameGroupChat as AnyObject, "locationName": self.locationJoined as AnyObject, "timePlay": self.timePLay as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": self.gameKeyJoined as AnyObject, "type": self.typeChosen as AnyObject, "country": self.countryOfGameViewed as AnyObject, "hosterUID": self.JoinedhosterUID as AnyObject, "CommunityKey": CommunityKey as AnyObject, "Canceled": 0 as AnyObject]
                                            
                                            let communityInformation: Dictionary<String, AnyObject> = ["name": self.nameGroupChat as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": self.gameKeyJoined as AnyObject, "type": self.typeChosen as AnyObject, "country": self.countryOfGameViewed as AnyObject, "TypePost": "Joined" as AnyObject, "CommunityName": self.ownerName as AnyObject , "CommunityAvatarUrl": self.avatarUrl as AnyObject, "CommunityKey": CommunityKey as AnyObject, "CommunityUID": userUID as AnyObject]
                                            
                                            let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "Joined" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject, "gameType": self.typeChosen as AnyObject]
                                            
                                            
                                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                                            
                                            
                                            let info: Dictionary<String, AnyObject> = ["chatKey": self.gameKeyJoined! as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "avatarUrl": self.avatarUrl as AnyObject]
                                            
                                            
                                            let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
                                            
                                            
                                            CommunityRef.setValue(communityInformation)
                                            
                                            let url = DataService.instance.GamePostRef.child(self.countryOfGameViewed!).child(self.typeChosen!).child(self.gameKeyJoined!).child("Information").child("Joined_User").child(userUID)
                                            
                                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(self.gameKeyJoined!).setValue(GameInformation)
                                            
                                            
                                            
                                            
                                            
                                            userUrl.child("Chat_List").child(self.keyChat!).setValue(chatInformation)
                                            
                                            userUrl.child("Game_Joined").child(self.gameKeyJoined!).setValue(GameInformation)
                                            
                                            
                                            url.setValue(JoinedInformation)
                                            
                                            DataService.instance.GameChatRef.child(self.keyChat!).child("user").child(userUID).setValue(info)
                                            
                                           /// self.getGameFromManageView(country: ManagedGameCountry, type: ManagedGameType, GameKey: ManagedGameKey)
                                            
                                            let Url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("Information").child("Joined_User")
                                            
                                            Url.observeSingleEvent(of: .value, with: { (snapIn) in
                                                
                                                if snapIn.exists() {
                                                    
                                                    let count = snapIn.childrenCount
                                                    
                                                    
                                                    self.numberOfPeopleGameView.text = String(count) + " out of " + String(ManageNumberOfPeple)
                                                    
                                                }
                                                
                                                
                                                
                                            })
                                            
                                            let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                                            let alert = JDropDownAlert()
                                            
                                            
                                            alert.alertWith("Successfully Joined",
                                                            topLabelColor: UIColor.white,
                                                            messageLabelColor: UIColor.white,
                                                            backgroundColor: color)
                                            
                                        } else {
                                            
                                            self.showErrorAlert("Oopps !!!", msg: "CRACC: This game has full of joined people. We are so sorry about that.")
                                            
                                        }
                                        
                                    }
                                    
                                    
                                } else {
                                    
                                    
                                    let JoinedInformation: Dictionary<String, AnyObject>  = ["Joinedname": self.ownerName as AnyObject, "JoineduserUID": userUID as AnyObject, "JoinedAvatarUrl": self.avatarUrl as AnyObject , "JoinedTimestamp": ServerValue.timestamp() as AnyObject, "Joinedtype": CachedType as AnyObject]
                                    
                                    let chatInformation: Dictionary<String, AnyObject> = ["name":  self.nameGroupChat as AnyObject, "time": self.self.timePLay as AnyObject, "chatKey": self.keyChat as AnyObject, "type": self.typeChosen as AnyObject, "HosterUID": self.hosterUID as AnyObject, "isGroup": 1 as AnyObject, "GameID": self.gameKeyJoined as AnyObject, "Country": self.countryOfGameViewed as AnyObject]
                                    let GameInformation: Dictionary<String, AnyObject> = ["name": self.nameGroupChat as AnyObject, "locationName": self.locationJoined as AnyObject, "timePlay": self.timePLay as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": self.gameKeyJoined as AnyObject, "type": self.self.typeChosen as AnyObject, "country": self.countryOfGameViewed as AnyObject, "hosterUID": self.JoinedhosterUID as AnyObject, "Canceled": 0 as AnyObject]
                                    
                                    
                                    let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "Joined" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject, "gameType": self.typeChosen as AnyObject]
                                    
                                    
                                    DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                                    
                                    let info: Dictionary<String, AnyObject> = ["chatKey": self.gameKeyJoined! as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "avatarUrl": self.avatarUrl as AnyObject]
                                    
                                    
                                    let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
                                    
                                    
                                    let url = DataService.instance.GamePostRef.child(self.countryOfGameViewed!).child(self.typeChosen!).child(self.gameKeyJoined!).child("Information").child("Joined_User").child(userUID)
                                    
                                    DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(self.gameKeyJoined!).setValue(GameInformation)
                                    
                                    
                                    
                                    
                                    
                                    userUrl.child("Chat_List").child(self.keyChat!).setValue(chatInformation)
                                    
                                    userUrl.child("Game_Joined").child(self.gameKeyJoined!).setValue(GameInformation)
                                    
                                    
                                    url.setValue(JoinedInformation)
                                    
                                    
                                    
                                    
                                    
                                    DataService.instance.GameChatRef.child(self.keyChat!).child("user").child(userUID).setValue(info)
                                    
                                    
                                  //  self.getGameFromManageView(country: ManagedGameCountry, type: ManagedGameType, GameKey: ManagedGameKey)
                                    
                                    let Url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("Information").child("Joined_User")
                                    
                                    Url.observeSingleEvent(of: .value, with: { (snapIn) in
                                        
                                        if snapIn.exists() {
                                            
                                            let count = snapIn.childrenCount
                                            
                                            
                                            self.numberOfPeopleGameView.text = String(count) + " out of " + String(ManageNumberOfPeple)
                                            
                                        }
                                        
                                        
                                        
                                    })
                                    
                                    let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                                    let alert = JDropDownAlert()
                                    
                                    
                                    alert.alertWith("Successfully Joined",
                                                    topLabelColor: UIColor.white,
                                                    messageLabelColor: UIColor.white,
                                                    backgroundColor: color)
                                }
                                
                                
                            })
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }
                
                
                
            })
            
            
            
            
            
        
            
            
            
        
        } else {
        
            self.showErrorAlert("Oops !!!", msg: "CRACC: Error occured, please try to join again")
        
        }
        
        
        
        
        
        
    }
    @IBAction func inviteBtnPressed(_ sender: Any) {
    }
    
    @IBAction func leaveBtnPressed(_ sender: Any) {
        
        
        
       
        if userUID != "", userType != "" {
            // setup Information
            let Url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("Information").child("Joined_User")
            let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
            
            let chatUrl = DataService.instance.GameChatRef.child(ManageKeyChat)
            
            Url.child(userUID).removeValue()
            userUrl.child("Game_Joined").child(ManagedGameKey).removeValue()
            userUrl.child("Cached_Game").child(ManagedGameKey).removeValue()
            userUrl.child("Chat_List").child(ManageKeyChat).removeValue()
            chatUrl.child("user").child(userUID).removeValue()
            chatUrl.child("online").child(userUID).removeValue()
            
            joinNowBtn.isHidden = false
            inviteAndLeaveView.isHidden = true
            
            
            Url.observeSingleEvent(of: .value, with: { (snapIn) in
                
                if snapIn.exists() {
                    
                    let count = snapIn.childrenCount
                    
                    
                    self.numberOfPeopleGameView.text = String(count) + " out of " + String(ManageNumberOfPeple)
                    
                } else {
                    
                    self.numberOfPeopleGameView.text = String(0) + " out of " + String(ManageNumberOfPeple)
                    
                }
                
                
                
            })
            
        } else {
            
            showErrorAlert("Oops !!!", msg: "CRACC: Cannot leave the game, please try again.")
        }
        
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        timeFormatter.timeStyle = DateFormatter.Style.short
        if inSettingMode {
            
            settingGameTime.text = dateFormatter.string(from: sender.date) + " " + timeFormatter.string(from: sender.date)
            let time = (Int64((sender.date.timeIntervalSince1970)))
            timeSetting = Double(time)
            if settingGameLocation.text != "" {
                
                if alreadyLocation != settingGameLocation.text {
                    alreadyLocation = settingGameLocation.text
                    
                    if let lat = settingLat, let lon = settingLon {
                        self.forecasts.removeAll()
                        self.downloadForecastData(latitude: lat, longitude: lon) {
                            self.getWeather(time: self.timeSetting!)
                            
                        }
                        
                    }
                    
                    
                } else {
                    
                    self.getWeather(time: self.timeSetting!)
                    
                    
                }
                
            }
            
            
        } else {
            
            dateLbl.text = dateFormatter.string(from: sender.date) + " " + timeFormatter.string(from: sender.date)
            
            let time = (Int64((sender.date.timeIntervalSince1970)))
            timeSelected = Double(time)
            
            
            
            
            if LocationLbl.text != "" {
                
                
                if alreadyLocation != LocationLbl.text {
                    alreadyLocation = LocationLbl.text
                    
                    if let lat = lat, let lon = lon {
                        self.forecasts.removeAll()
                        self.downloadForecastData(latitude: lat, longitude: lon) {
                            self.getWeather(time: self.timeSelected!)
                            
                        }
                        
                    }
                    
                    
                } else {
                    
                    self.getWeather(time: self.timeSelected!)
                    
                    
                }
                
                
                
                
                
            }
            
        }
        
        

    }
    
    
    @IBAction func reportBtn1Pressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "MoveToReportVC", sender: nil)
        
    }
    
    @IBAction func reportBtn2Pressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "MoveToReportVC", sender: nil)
        
        
    }
    
    
    
    
    
    func downloadForecastData(latitude: Double, longitude: Double,completed: @escaping DownloadComplete) {
        //Downloading forecast weather data for TableView
        let First_ForeCast_Url = "http://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(Second_OpenMapWeather_key)"
        
        Alamofire.request(First_ForeCast_Url).responseJSON { response in
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {

                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    for obj in list {

                        let forecast = Forecast(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }

                }
            }
            completed()
        }
    }
    
    func getWeather(time: Double) {
        var change: Double!
        var value = 9999999999.00
        var result = 0.00
        
        for item in forecasts {
            
            let timestamp = item.timestamp
            if time > timestamp{
                change = time - timestamp
                
            
            } else {
                change = timestamp - time
            }
            
            
            if value > change {
                value = change
                result = item.timestamp
                
            
            }
            
           
        
        
        }
        var count = 0
        
        for items in forecasts {
        
            count += 1
            if result == items.timestamp {
            
                break
            
            
            }
            
        
        
        }
        
        let index = forecasts[count - 1]
        
        if inSettingMode {
            
            settingIconImg.image = UIImage(named: "\(index.weatherType)")
            
        } else {

            weatherIcon.image = UIImage(named: "\(index.weatherType)")
            
            
        }
        
        
        
        
        typeWeather = index.weatherType
        highTemp = Double(index.highTemp)
        lowTemp = Double(index.lowTemp)
        temperature = Double(index.temp)
        DescriptionWeather = index.description
        typeWeather = index.weatherType


    
    
    }
    
    @IBAction func numberOfPeopleTxtField(_ sender: Any) {
        for x in 1...30 {
        
            let xStr = String(x)
            NumberOfPeople.append(xStr)
        
        }
    
        pickerViewController = pickView.numberOfPeople
        createDayPicker()
    }
    
    
    @IBAction func createGameBtnPressed(_ sender: Any) {
        
        let time = (Int64(Date().timeIntervalSince1970 * 1000))
       
        let userUrl = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
        
        
        lostHandle = DataService.instance.connectedRef.observe(.value, with: { snapShot in
            if let connected = snapShot.value as? Bool, connected {
                
                
                DataService.instance.connectedRef.removeObserver(withHandle: self.lostHandle)
                
                userUrl.child("My_Game").queryOrdered(byChild: "timePlay").queryStarting(atValue: time).observeSingleEvent(of: .value, with: { (snapInfos) in
                    
                    if snapInfos.exists() {
                        
                        
                        let count = snapInfos.childrenCount
                            
                            if count > 6 {
                                
                                let alert = SCLAlertView()
                                
                                
                                _ = alert.showError("Oops!!!", subTitle: "CRACC: You have already had 6 own upcomming games already.")
                                
                                
                            } else {
                                
                                
                                 self.createGame()
                                
                            }
                            
                        
                        
                        
                    } else {
                        
                        
                        self.createGame()
                        
                        
                    }
                    
                    
                    
                })
                
            }
            else {
                
                DataService.instance.connectedRef.removeObserver(withHandle: self.lostHandle)
                
                let alert = SCLAlertView()
                
                
                _ = alert.showError("Oops!!!", subTitle: "CRACC: Please check your internet connection and try again")
                
            }
            
        })
        
       
        
        
        
    }
    
    @IBAction func closeVideoBtnPressed(_ sender: Any) {
        
        
        
        
        closeVideo()
        
        
        
        
    }
    
    @IBAction func playVideoAgainBtnPressed(_ sender: Any) {
        
    
        WatchVideoAgain()
        
    }
    
    
    @IBAction func openWeatherViewBtnPressed(_ sender: Any) {
        
        
        self.weatherView.isHidden = false
        
        delay(2.0) { () -> () in
            self.weatherView.isHidden = true
        }
        
        
        
    }
    
    @IBAction func OpenControlPeopleBtnPressed(_ sender: Any) {
        
        self.joinedUserArr.removeAll()
        self.controlPeopleTableView.reloadData()
        
        let item = listGameRequest[controlGameIndexed]
        
        if item.JoinedUserArray.count > 0 {
            
            blurView.isHidden = false
            controlPeopleView.isHidden = false
            self.ControltMode = .controlPeopleView
            self.tableControl = .controlPeople
            
            if let CheckedUserArray = item.JoinedUserArray {
                
                for items in CheckedUserArray {
                    //RecentlyPlayedModel
                    
                    
                    
                    let key = "Joined"
                    
                    let requestData = RecentlyPlayedModel(postKey: key, recentlyPlayedModel: items)
                    self.joinedUserArr.insert(requestData, at: 0)
                    self.controlPeopleTableView.reloadData()
                    
                }
                
            }
            
            
            
            
        } else {
            
            
            
        }
        
        
        
    }
    
    
    
    @objc func closeVideo() {
    
        self.containerView.removeGestureRecognizer(swipeBack)
        self.containerView.isHidden = true
        self.playerVideo.pause()
        playController.removeFromParent()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerVideo.currentItem)
        self.playerVideo = nil
    
    }
    
    func createGame() {
        
        if localLocation != nil, createLocation != nil {
            
            var distance = calculateDistanceBetweenTwoCoordinator(baseLocation: localLocation, destinationLocation: createLocation)
            
            
            
            distance = distance * 0.000621371192
            
            
            if distance <= 95.00 {
                
                
                if let name = nameLbl.text, name != "", let location = LocationLbl.text, location != "", let numberOfPeople = numberPeopleLbl.text, numberOfPeople != "", type != "", let time = dateLbl.text, time != "", userType != "" {
                    
                    
                    if temperature != nil, countryCreated != nil, type != nil, lat != nil, lon != nil, timeSelected != nil, ownerName != nil, temperature != nil, typeWeather != nil, highTemp != nil, lowTemp != nil, DescriptionWeather != nil{
                        let url = DataService.instance.GamePostRef.child(countryCreated!).child(type!).childByAutoId()
                        let geoFireUrl = DataService.instance.GameCoordinateRef.child(countryCreated!).child(type!)
                        let GameIDCheck = url.key
                        let geofireRef = geoFireUrl
                        let geoFire = GeoFire(firebaseRef: geofireRef)
                        
                        
                        let ref = DataService.instance.mainDataBaseRef.child("Messages")
                        let childRef = ref.childByAutoId()
                        let GroupChatIDCheck = childRef.key
                        
                        
                        
                        
                        
                        if userUID == "" {
                            
                            userUID = (Auth.auth().currentUser?.uid)!
                        }
                        
                        
                        timeSelected = timeSelected! * 1000
                        self.UndoTheMainMapActivity()
                        
                        let CommunityRef = DataService.instance.mainDataBaseRef.child("Community").child(userUID).childByAutoId()
                        let CommunityKey = CommunityRef.key
                        
                        
                        if DoneUrl != nil {
                            
                            
                            
                            let data = try! Data(contentsOf: DoneUrl!)
                            let metaData = StorageMetadata()
                            let imageUID = UUID().uuidString
                            metaData.contentType = "video/mp4"
                            DataService.instance.VideoStorageRef.child(imageUID).putData(data , metadata: metaData) { (metaData, err) in
                                
                                
                                
                                if err != nil {
                                    print(err?.localizedDescription as Any)
                                    return
                                }
                                
                                
                                /*
                                let Url = metaData?.downloadURL()?.absoluteString
                                
                                
                                
                                
                                let downUrl = Url! as String
 */
                                let downloadUrl = metaData?.path
                                
                                let Information: Dictionary<String, AnyObject> = ["name": name as AnyObject, "locationName": location as AnyObject, "numberOfPeople": numberOfPeople as AnyObject, "timePlay": self.timeSelected as AnyObject, "VideoUrl": downloadUrl as AnyObject, "HosterUID": userUID as AnyObject, "ownerName": self.ownerName as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": GameIDCheck as AnyObject, "lat": self.lat as AnyObject , "lon": self.lon as AnyObject, "weatherDescription": self.typeWeather as AnyObject, "temperature": self.temperature as AnyObject, "avatarUrl": self.avatarUrl as AnyObject, "type": self.type as AnyObject, "highTemp": self.highTemp as AnyObject, "lowTemp": self.lowTemp as AnyObject, "DescriptionWeather": self.DescriptionWeather as AnyObject, "chatKey": GroupChatIDCheck as AnyObject, "Country": self.countryCreated as AnyObject,"AgeMax": self.MaxAgeSelected as AnyObject, "AgeMin": self.MinAgeSelected as AnyObject, "Gender": self.genderLbl.text as AnyObject, "HosterType": userType as AnyObject, "CommunityKey": CommunityKey as AnyObject]
                                let chatInformation: Dictionary<String, AnyObject> = ["name": name as AnyObject, "time": self.timeSelected as AnyObject as AnyObject, "chatKey": GroupChatIDCheck as AnyObject, "type": self.type as AnyObject, "HosterUID": userUID as AnyObject, "isGroup": 1 as AnyObject,"Country": self.countryCreated as AnyObject, "GameID": GameIDCheck as AnyObject]
                                let info: Dictionary<String, AnyObject> = ["chatKey": GroupChatIDCheck as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "avatarUrl": self.avatarUrl as AnyObject]
                                let GameInformation: Dictionary<String, AnyObject> = ["name": name as AnyObject, "locationName": location as AnyObject, "timePlay": self.timeSelected as AnyObject as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": GameIDCheck as AnyObject, "type": self.type as AnyObject, "country": self.countryCreated as AnyObject, "hosterUID": userUID as AnyObject, "CommunityKey": CommunityKey as AnyObject, "Canceled": 0 as AnyObject]
                                
                                let communityInformation: Dictionary<String, AnyObject> = ["name": name as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": GameIDCheck as AnyObject, "type": self.type as AnyObject, "country": self.countryCreated as AnyObject, "TypePost": "Created" as AnyObject, "CommunityName": self.ownerName as AnyObject , "CommunityAvatarUrl": self.avatarUrl as AnyObject, "CommunityKey": CommunityKey as AnyObject, "CommunityUID": userUID as AnyObject]
                                
                                
                                CommunityRef.setValue(communityInformation)
                                
                                let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "Created" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject, "gameType": self.type as AnyObject]
                                
                                
                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                                
                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("My_Game").child(GameIDCheck!).setValue(GameInformation)
                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(GameIDCheck!).setValue(GameInformation)
                                
                                DataService.instance.mainDataBaseRef.child("Game_Chat_Info").child(GroupChatIDCheck!).setValue(chatInformation)
                                
                                
                                geoFire.setLocation(CLLocation(latitude: self.lat!, longitude: self.lon!), forKey: GameIDCheck!)
                                
                                url.child("Information").setValue(Information)
                                DataService.instance.GameChatRef.child(GroupChatIDCheck!).child("user").child(userUID).setValue(info)
                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Chat_List").child(GroupChatIDCheck!).setValue(chatInformation)
                                
                                
                                self.dateLbl.text = ""
                                self.nameLbl.text = ""
                                self.LocationLbl.text = ""
                                self.numberPeopleLbl.text = ""
                                self.genderLbl.text = ""
                                self.ageLbl.text = ""
                                self.imageType.image = nil
                                DoneUrl = nil
                                
                                
                                self.temperature = nil
                                self.countryCreated = nil
                                self.type = nil
                                self.lat = nil
                                self.lon = nil
                                self.timeSelected = nil
                                self.typeWeather = nil
                                
                                
                                self.weatherIcon.image = nil
                                
                                
                                
                                self.deleteVideo()
                                let alert = JDropDownAlert()
                                
                                let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                                alert.alertWith("Successfully created",
                                                topLabelColor: UIColor.white,
                                                messageLabelColor: UIColor.white,
                                                backgroundColor: color)
      
                            }
                            
                            
                        } else {
                            
                            let Information: Dictionary<String, AnyObject> = ["name": name as AnyObject, "locationName": location as AnyObject, "numberOfPeople": numberOfPeople as AnyObject, "timePlay": timeSelected as AnyObject, "VideoUrl": "nil" as AnyObject as AnyObject, "HosterUID": userUID as AnyObject,"ownerName": self.ownerName as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": GameIDCheck as AnyObject, "lat": self.lat as AnyObject, "lon": self.lon as AnyObject, "weatherDescription": self.typeWeather as AnyObject, "temperature": self.temperature as AnyObject, "avatarUrl": avatarUrl as AnyObject, "type": self.type as AnyObject, "highTemp": highTemp as AnyObject, "lowTemp": lowTemp as AnyObject, "DescriptionWeather": self.DescriptionWeather as AnyObject, "chatKey": GroupChatIDCheck as AnyObject, "Country": self.countryCreated as AnyObject, "AgeMax": MaxAgeSelected as AnyObject, "AgeMin": MinAgeSelected as AnyObject, "Gender": genderLbl.text as AnyObject, "HosterType": userType as AnyObject, "CommunityKey": CommunityKey as AnyObject]
                            let chatInformation: Dictionary<String, AnyObject> = ["name": name as AnyObject, "time": self.timeSelected as AnyObject , "chatKey": GroupChatIDCheck as AnyObject, "type": self.type as AnyObject, "HosterUID": userUID as AnyObject, "isGroup": 1 as AnyObject, "Country": self.countryCreated as AnyObject,"GameID": GameIDCheck as AnyObject]
                            
                            let info: Dictionary<String, AnyObject> = ["chatKey": GroupChatIDCheck as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "avatarUrl": avatarUrl as AnyObject]
                            
                            let GameInformation: Dictionary<String, AnyObject> = ["name": name as AnyObject, "locationName": location as AnyObject, "timePlay": self.timeSelected as AnyObject as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": GameIDCheck as AnyObject, "type": self.type as AnyObject, "country": self.countryCreated as AnyObject, "hosterUID": userUID as AnyObject, "CommunityKey": CommunityKey as AnyObject, "Canceled": 0 as AnyObject]
                            
                            let communityInformation: Dictionary<String, AnyObject> = ["name": name as AnyObject, "timestamp": ServerValue.timestamp() as AnyObject, "GameID": GameIDCheck as AnyObject, "type": self.type as AnyObject, "country": self.countryCreated as AnyObject, "TypePost": "Created" as AnyObject, "CommunityName": self.ownerName as AnyObject , "CommunityAvatarUrl": self.avatarUrl as AnyObject, "CommunityKey": CommunityKey as AnyObject, "CommunityUID": userUID as AnyObject]
                            
                            let CurrentActivity: Dictionary<String, AnyObject> = ["Type": "Created" as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject, "gameType": self.type as AnyObject]
                            
                            
                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("CurrentActivity").setValue(CurrentActivity)
                            
                            CommunityRef.setValue(communityInformation)
                            
                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("My_Game").child(GameIDCheck!).setValue(GameInformation)
                            DataService.instance.mainDataBaseRef.child("Game_Chat_Info").child(GroupChatIDCheck!).setValue(chatInformation)
                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Cached_Game").child(GameIDCheck!).setValue(GameInformation)
                            
                            
                            geoFire.setLocation(CLLocation(latitude: self.lat!, longitude: self.lon!), forKey: GameIDCheck!)
                            
                            url.child("Information").setValue(Information)
                            
                            DataService.instance.GameChatRef.child(GroupChatIDCheck!).child("user").child(userUID).setValue(info)
                            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Chat_List").child(GroupChatIDCheck!).setValue(chatInformation)
                            
                            dateLbl.text = ""
                            nameLbl.text = ""
                            LocationLbl.text = ""
                            genderLbl.text = ""
                            ageLbl.text = ""
                            numberPeopleLbl.text = ""
                            imageType.image = nil
                            DoneUrl = nil
                            
                            
                            
                            
                            
                            temperature = nil
                            countryCreated = nil
                            type = nil
                            lat = nil
                            lon = nil
                            timeSelected = nil
                            temperature = nil
                            typeWeather = nil
                            
                            weatherIcon.image = nil
                            
                            
                            containerView.isHidden = true
                            
                            
                            self.deleteVideo()
                            
                            let alert = JDropDownAlert()
                            
                            let color = UIColor(red: 144/255, green: 238/255, blue: 144/255, alpha: 1.0)
                            alert.alertWith("Successfully created",
                                topLabelColor: UIColor.white,
                                messageLabelColor: UIColor.white,
                                backgroundColor: color)
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    } else {
                        
                        
                        let alert = SCLAlertView()
                       
                        
                        _ = alert.showError("Oops!!!", subTitle: "CRACC: Please fill up add needed information to create game")
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                } else {
                    
                    let alert = SCLAlertView()
                    
                    
                    _ = alert.showError("Oops!!!", subTitle: "CRACC: Please fill up add needed information to create game")
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
            } else {
                
                
                let alert = SCLAlertView()
                
                
                _ = alert.showError("Oops!!!", subTitle: "CRACC: Your game cannot be further than 95 miles from your current location")
            }
            
        } else {
            
            
            let alert = SCLAlertView()
            
            
            _ = alert.showError("Oops!!!", subTitle: "CRACC: Cannot detect your location or your game's location , please make you have allow us to access your location or select a destination and try again")
            
            
        }
        
       

        
    }
    
    
    
    func getGameRadius(game: String,query: GFCircleQuery) {
    

        
        
        query.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            if let key = key {
                
                self.gameKey.append(key)
                
            }
            
           
        })
        
        query.observeReady {
            
            
            self.listGameRequest.removeAll()
            query.removeAllObservers()
            
            self.checkTimeStampAndDownloadData(game: game)
            
        }
        
        
    
    }
    
    func getIndex(from: [String], item: String) -> Int? {
        return from.index(where: { $0 == item })
    }
    
    
    func checkTimeStampAndDownloadData(game: String) {
        listMakrer.removeAll()
    
        let time = (Int64(Date().timeIntervalSince1970 * 1000))
        
        for item in gameKey {
        
            DataService.instance.GamePostRef.child(countryRequested!).child(game).child(item).queryOrdered(byChild: "timePlay").queryStarting(atValue: time).observeSingleEvent(of: .value, with: { (snapInfo) in
                
                
                
                
                if snapInfo.exists() {
                    
                    
                    if let snap = snapInfo.children.allObjects as? [DataSnapshot] {
                        for item in snap {
                            if let postDict = item.value as? Dictionary<String, Any> {
                                
                               
                                
                                
                                if let CheckedUserUID = postDict["HosterUID"], let CheckedUserType = postDict["HosterType"]{
                                    let confirmedUID = CheckedUserUID as? String
                                    let confirmedType = CheckedUserType as? String
                                    
                                    let url = DataService.instance.mainDataBaseRef.child("User").child(confirmedType!).child(confirmedUID!).child("Block_list")
                                    
                                    url.child(userUID).observeSingleEvent(of: .value, with: { (snapInfos) in
                                        
                                        if snapInfos.exists() {
                                            
                                            print("Owner blocked user")
                                            
                                        } else {
                                            
                                            if confirmedUID == userUID {
                                                
                                                let key = snapInfo.key
                                                
                                                let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                self.listGameRequest.insert(requestData, at: 0)
                                                
                                                self.addGameToMap()
                                                
                                            } else {
                                                
                                                let date = Date()
                                                let calendar = Calendar.current
                                                
                                                let year = calendar.component(.year, from: date)
                                                
                                                var alreadyJoined = false
                                                
                                                let max = Int((postDict["numberOfPeople"] as? String)!)
                                                
                                                if let MaxCount = max {
                                                    
                                                    if let JoinedUser = postDict["Joined_User"] as? Dictionary<String, AnyObject> {
                                                        
                                                        var array = [Dictionary<String, AnyObject>]()
                                                        let Joinedcount = JoinedUser.count
                                                        
                                                        for item in JoinedUser {
                                                            
                                                            
                                                            let index = JoinedUser[item.key] as! [String : AnyObject]
                                                            
                                                            
                                                            array.append(index)
                                                            
                                                        }
                                                        
                                                        for i in array {
                                                            
                                                            
                                                            if let JoineduserUID = i["JoineduserUID"] as? String {
                                                                
                                                                
                                                                if userUID == JoineduserUID {
                                                                    
                                                                    alreadyJoined = true
                                                                    break
                                                                    
                                                                    
                                                                }
                                                                
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        if alreadyJoined == true {
                                                            
                                                            let key = snapInfo.key
                                                            
                                                            let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                            self.listGameRequest.insert(requestData, at: 0)
                                                            
                                                            self.addGameToMap()
                                                            
                                                        } else {
                                                            
                                                            
                                                            if Joinedcount < MaxCount {
                                                                
                                                                
                                                                
                                                                if let CheckedGender = postDict["Gender"], let CheckedAgeMax = postDict["AgeMax"], let CheckedAgeMin = postDict["AgeMin"] {
                                                                    
                                                                    let confirmedGender = CheckedGender as? String
                                                                    if confirmedGender == "Both" {
                                                                        
                                                                        let confirmedMaxAge = Int((CheckedAgeMax as? String)!)
                                                                        let confirmedMinAge = Int((CheckedAgeMin as? String)!)
                                                                        
                                                                        
                                                                        if let finalMaxAge = confirmedMaxAge, let finalMinAge = confirmedMinAge {
                                                                            
                                                                            
                                                                            if let CacheBirthday = try? InformationStorage?.object(ofType: String.self, forKey: "birthday"){
                                                                                
                                                                                
                                                                                if (CacheBirthday?.contains(","))! {
                                                                                    
                                                                                    var isBirthday = false
                                                                                    var FinalBirthday = [String]()
                                                                                    
                                                                                    
                                                                                    if let birthday = CacheBirthday {
                                                                                        
                                                                                        let testBirthdaylArr = Array(birthday)
                                                                                        
                                                                                        
                                                                                        for i in testBirthdaylArr  {
                                                                                            
                                                                                            if isBirthday == false {
                                                                                                
                                                                                                if i == "," {
                                                                                                    
                                                                                                    isBirthday = true
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            } else {
                                                                                                
                                                                                                let num = String(i)
                                                                                                
                                                                                                
                                                                                                FinalBirthday.append(num)
                                                                                                
                                                                                            }
                                                                                            
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                    let result = FinalBirthday.dropFirst()
                                                                                    if let bornYear = Int(result.joined()) {
                                                                                        
                                                                                        
                                                                                        
                                                                                        let currentAge = year - bornYear
                                                                                        
                                                                                        
                                                                                        
                                                                                        if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                            
                                                                                            let key = snapInfo.key
                                                                                            
                                                                                            let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                            self.listGameRequest.insert(requestData, at: 0)
                                                                                            
                                                                                            self.addGameToMap()
                                                                                            
                                                                                        } else {
                                                                                            
                                                                                            return
                                                                                        }
                                                                                        
                                                                                        
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                    
                                                                                } else {
                                                                                    
                                                                                    if let finalBirthday = Int(CacheBirthday!) {
                                                                                        
                                                                                        
                                                                                        let currentAge = year - finalBirthday
                                                                                        
                                                                                        if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                            
                                                                                            let key = snapInfo.key
                                                                                            
                                                                                            let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                            self.listGameRequest.insert(requestData, at: 0)
                                                                                            
                                                                                            self.addGameToMap()
                                                                                            
                                                                                        } else {
                                                                                            
                                                                                            return
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                            }
                                                                            
                                                                            
                                                                        }
                                                                        
                                                                        
                                                                        
                                                                    } else {
                                                                        
                                                                        if let CachedGender = try? InformationStorage?.object(ofType: String.self, forKey: "gender"){
                                                                            
                                                                            
                                                                            var gender = CachedGender
                                                                            gender?.capitalizeFirstLetter()
                                                                            
                                                                            if let FinalGender = gender {
                                                                                
                                                                                if FinalGender != confirmedGender {
                                                                                    
                                                                                    return
                                                                                    
                                                                                }
                                                                                
                                                                                let confirmedMaxAge = Int((CheckedAgeMax as? String)!)
                                                                                let confirmedMinAge = Int((CheckedAgeMin as? String)!)
                                                                                
                                                                                
                                                                                if let finalMaxAge = confirmedMaxAge, let finalMinAge = confirmedMinAge {
                                                                                    
                                                                                    
                                                                                    if let CacheBirthday = try? InformationStorage?.object(ofType: String.self, forKey: "birthday"){
                                                                                        
                                                                                        
                                                                                        if (CacheBirthday?.contains(","))! {
                                                                                            
                                                                                            var isBirthday = false
                                                                                            var FinalBirthday = [String]()
                                                                                            
                                                                                            
                                                                                            if let birthday = CacheBirthday {
                                                                                                
                                                                                                let testBirthdaylArr = Array(birthday)
                                                                                                
                                                                                                
                                                                                                for i in testBirthdaylArr  {
                                                                                                    
                                                                                                    if isBirthday == false {
                                                                                                        
                                                                                                        if i == "," {
                                                                                                            
                                                                                                            isBirthday = true
                                                                                                            
                                                                                                        }
                                                                                                        
                                                                                                    } else {
                                                                                                        
                                                                                                        let num = String(i)
                                                                                                        
                                                                                                        
                                                                                                        FinalBirthday.append(num)
                                                                                                        
                                                                                                    }
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            }
                                                                                            
                                                                                            
                                                                                            let result = FinalBirthday.dropFirst()
                                                                                            if let bornYear = Int(result.joined()) {
                                                                                                
                                                                                                
                                                                                                
                                                                                                let currentAge = year - bornYear
                                                                                                
                                                                                                
                                                                                                
                                                                                                if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                                    
                                                                                                    let key = snapInfo.key
                                                                                                    
                                                                                                    let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                                    self.listGameRequest.insert(requestData, at: 0)
                                                                                                    
                                                                                                    self.addGameToMap()
                                                                                                    
                                                                                                } else {
                                                                                                    
                                                                                                    return
                                                                                                }
                                                                                                
                                                                                                
                                                                                                
                                                                                            }
                                                                                            
                                                                                            
                                                                                            
                                                                                        } else {
                                                                                            
                                                                                            if let finalBirthday = Int(CacheBirthday!) {
                                                                                                
                                                                                                
                                                                                                
                                                                                                let currentAge = year - finalBirthday
                                                                                                
                                                                                                if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                                    
                                                                                                    let key = snapInfo.key
                                                                                                    
                                                                                                    let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                                    self.listGameRequest.insert(requestData, at: 0)
                                                                                                    
                                                                                                    self.addGameToMap()
                                                                                                    
                                                                                                } else {
                                                                                                    
                                                                                                    return
                                                                                                }
                                                                                                
                                                                                            }
                                                                                            
                                                                                            
                                                                                        }
                                                                                        
                                                                                        
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                        
                                                                    }
                                                                } else {
                                                                    
                                                                    print("Can't filter information")
                                                                    
                                                                }
                                                                
                                                                
                                                            } else {
                                                                
                                                                return
                                                                
                                                            }
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                    } else {
                                                        
                                                        
                                                        
                                                        if let CheckedGender = postDict["Gender"], let CheckedAgeMax = postDict["AgeMax"], let CheckedAgeMin = postDict["AgeMin"] {
                                                            
                                                            let confirmedGender = CheckedGender as? String
                                                            if confirmedGender == "Both" {
                                                                
                                                                let confirmedMaxAge = Int((CheckedAgeMax as? String)!)
                                                                let confirmedMinAge = Int((CheckedAgeMin as? String)!)
                                                                
                                                                
                                                                if let finalMaxAge = confirmedMaxAge, let finalMinAge = confirmedMinAge {
                                                                    
                                                                    
                                                                    if let CacheBirthday = try? InformationStorage?.object(ofType: String.self, forKey: "birthday"){
                                                                        
                                                                        
                                                                        if (CacheBirthday?.contains(","))! {
                                                                            
                                                                            var isBirthday = false
                                                                            var FinalBirthday = [String]()
                                                                            
                                                                            
                                                                            if let birthday = CacheBirthday {
                                                                                
                                                                                let testBirthdaylArr = Array(birthday)
                                                                                
                                                                                
                                                                                for i in testBirthdaylArr  {
                                                                                    
                                                                                    if isBirthday == false {
                                                                                        
                                                                                        if i == "," {
                                                                                            
                                                                                            isBirthday = true
                                                                                            
                                                                                        }
                                                                                        
                                                                                    } else {
                                                                                        
                                                                                        let num = String(i)
                                                                                        
                                                                                        
                                                                                        FinalBirthday.append(num)
                                                                                        
                                                                                    }
                                                                                    
                                                                                }
                                                                                
                                                                            }
                                                                            
                                                                            
                                                                            let result = FinalBirthday.dropFirst()
                                                                            if let bornYear = Int(result.joined()) {
                                                                                
                                                                                
                                                                                
                                                                                let currentAge = year - bornYear
                                                                                
                                                                                
                                                                                
                                                                                
                                                                                if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                    
                                                                                    let key = snapInfo.key
                                                                                    
                                                                                    let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                    self.listGameRequest.insert(requestData, at: 0)
                                                                                    
                                                                                    self.addGameToMap()
                                                                                    
                                                                                } else {
                                                                                    
                                                                                    return
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                            }
                                                                            
                                                                            
                                                                            
                                                                        } else {
                                                                            
                                                                            if let finalBirthday = Int(CacheBirthday!) {
                                                                                
                                                                                
                                                                                
                                                                                let currentAge = year - finalBirthday
                                                                                
                                                                                if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                    
                                                                                    let key = snapInfo.key
                                                                                    
                                                                                    let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                    self.listGameRequest.insert(requestData, at: 0)
                                                                                    
                                                                                    self.addGameToMap()
                                                                                    
                                                                                } else {
                                                                                    
                                                                                    return
                                                                                }
                                                                                
                                                                            }
                                                                            
                                                                            
                                                                        }
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                }
                                                                
                                                                
                                                                
                                                            } else {
                                                                
                                                                if let CachedGender = try? InformationStorage?.object(ofType: String.self, forKey: "gender"){
                                                                    
                                                                    
                                                                    var gender = CachedGender
                                                                    gender?.capitalizeFirstLetter()
                                                                    
                                                                    if let FinalGender = gender {
                                                                        
                                                                        if FinalGender != confirmedGender {
                                                                            
                                                                            return
                                                                            
                                                                        }
                                                                        
                                                                        let confirmedMaxAge = Int((CheckedAgeMax as? String)!)
                                                                        let confirmedMinAge = Int((CheckedAgeMin as? String)!)
                                                                        
                                                                        
                                                                        if let finalMaxAge = confirmedMaxAge, let finalMinAge = confirmedMinAge {
                                                                            
                                                                            
                                                                            if let CacheBirthday = try? InformationStorage?.object(ofType: String.self, forKey: "birthday"){
                                                                                
                                                                                
                                                                                if (CacheBirthday?.contains(","))! {
                                                                                    
                                                                                    var isBirthday = false
                                                                                    var FinalBirthday = [String]()
                                                                                    
                                                                                    
                                                                                    if let birthday = CacheBirthday {
                                                                                        
                                                                                        let testBirthdaylArr = Array(birthday)
                                                                                        
                                                                                        
                                                                                        for i in testBirthdaylArr  {
                                                                                            
                                                                                            if isBirthday == false {
                                                                                                
                                                                                                if i == "," {
                                                                                                    
                                                                                                    isBirthday = true
                                                                                                    
                                                                                                }
                                                                                                
                                                                                            } else {
                                                                                                
                                                                                                let num = String(i)
                                                                                                
                                                                                                
                                                                                                FinalBirthday.append(num)
                                                                                                
                                                                                            }
                                                                                            
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                    let result = FinalBirthday.dropFirst()
                                                                                    if let bornYear = Int(result.joined()) {
                                                                                        
                                                                                        
                                                                                        
                                                                                        let currentAge = year - bornYear
                                                                                        
                                                                                        
                                                                                        
                                                                                        if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                            
                                                                                            let key = snapInfo.key
                                                                                            
                                                                                            let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                            self.listGameRequest.insert(requestData, at: 0)
                                                                                            
                                                                                            self.addGameToMap()
                                                                                            
                                                                                        } else {
                                                                                            
                                                                                            return
                                                                                        }
                                                                                        
                                                                                        
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                    
                                                                                } else {
                                                                                    
                                                                                    if let finalBirthday = Int(CacheBirthday!) {
                                                                                        
                                                                                        
                                                                                        
                                                                                        let currentAge = year - finalBirthday
                                                                                        
                                                                                        if currentAge >= finalMinAge, currentAge <= finalMaxAge {
                                                                                            
                                                                                            let key = snapInfo.key
                                                                                            
                                                                                            let requestData = requestModel(postKey: key, requestGameList: postDict)
                                                                                            self.listGameRequest.insert(requestData, at: 0)
                                                                                            
                                                                                            self.addGameToMap()
                                                                                            
                                                                                        } else {
                                                                                            
                                                                                            return
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    
                                                                                    
                                                                                }
                                                                                
                                                                                
                                                                                
                                                                            }
                                                                            
                                                                            
                                                                        }
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                    
                                                                }
                                                                
                                                            }
                                                        } else {
                                                            
                                                            print("Can't filter information")
                                                            
                                                        }
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                                
                                                
                                                
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                    
                                    
                                    
                                    
                                }
                                
                                
                                
                                
            
                                
                            }
                            
                        }
                        
                        
                    }
                    
                    
                   
                    
                }
                
                
                
                

                
            })
            
            
        }
        
    
    }
    
    
    func addGameToMap() {
        
        if listGameRequest.isEmpty != true {
            
                let information = listGameRequest[0]
            
                var IconImage: UIImage?
                
                if checkDuplicated(model: information) == true {
                    IconImage = UIImage(named: information.type + "+")
                
                } else if information.OwnerUID == userUID {

                    IconImage = UIImage(named: "Owner" + information.type)
                    
                } else if try! InformationStorage?.existsObject(ofType: String.self, forKey: information.key) != false {
                    
                    
                    
                    IconImage = UIImage(named: "Already" + information.type)
                    
                    
                    
                } else {
                    
                    IconImage = UIImage(named: information.type + "s")
                    
                }
                
                let lat = information.latitude
                let lon = information.longtitude
                let key = information.key
                

                let gameMarker = GMSMarker()
            
            
            
            
                let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                gameMarker.position = position
                let checkedMarker = checkMarkerDuplicated(checkedMarker: gameMarker)
                if checkedMarker != nil {
                  
                    checkedMarker?.map = nil
                    
                
                }
            
            
                print(information.type)
                gameMarker.title = key
                IconImage = resizeImage(image: IconImage!, targetSize: CGSize(width: 55, height: 55))
                gameMarker.icon = IconImage
                gameMarker.map = mapView
            
                listMakrer.append(gameMarker)
                
            
            
            
        } else {
            
            
            return
        }
        
            
        
        
        
        
        
        
    }
    
    func checkDuplicated(model: requestModel) -> Bool {
    
        var count = 0
        var duplicate = 0
        let longtitude = model.longtitude
        let latitude = model.latitude
    
        for item in listGameRequest {
            
            count += 1
            if item.longtitude == longtitude, item.latitude == latitude {
                
                duplicate += 1
                
            }
            
            
        }
        
        if duplicate > 1 {
 
            return true
            
        } else {
            return false
        }
    
    
    }
    
    func checkMarkerDuplicated(checkedMarker: GMSMarker) -> GMSMarker? {
        
        let lat = checkedMarker.position.latitude
        let lon = checkedMarker.position.longitude
    
        for id in listMakrer {
            
            let checkLat = id.position.latitude
            let checkLon = id.position.longitude
        
            if lat == checkLat, lon == checkLon {
            
                
                return id
            
            }
        
        }
        
        return nil
    
    }
    
    
    func calculateDistanceBetweenTwoCoordinator(baseLocation: CLLocation, destinationLocation: CLLocation) -> Double {
    
        let coordinate₀ = baseLocation
        let coordinate₁ = destinationLocation
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
        
        print(distanceInMeters)
    
        return Double(distanceInMeters)
    
    }
    
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let title = marker.title {
            
            if title != "My Location" {
            
                blurMap()
                freezeTheMapActivity()
                getInformation(key: title, marker: marker)
                
                return true
                
            }
        
            
            return false
        }
        
        
        return false
        
        
        
        
    }
    
    
    func getInformation(key: String, marker: GMSMarker) {
        
        
    
        var count = 0
        
        for item in listGameRequest {
        
            count += 1
            if item.key == key {
            
                break
            
            
            }
        
        }
        
        openGameView(index: count, marker: marker)
        
    
    
    }
    
    
    func openGameView(index: Int, marker: GMSMarker) {
        GameList.removeAll()
        var count = 0
        var duplicate = 0
        let indexed = index - 1
        let item = listGameRequest[indexed]
        let longtitude = item.longtitude
        let latitude = item.latitude
        
        for item in listGameRequest {
            
            count += 1
            if item.longtitude == longtitude, item.latitude == latitude {
                
                let listGameArray = listGameRequest[count - 1]
                GameList.insert(listGameArray, at: 0)
                duplicate += 1
                
            }
            
            
        }
       
        if duplicate > 1 {
            
            if GameList.isEmpty != true {
                
                ControltMode = .gameListView
                tableControl = .controlGameList
                gameListView.isHidden = false
                
                
                
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
                    self.gameListView.center.y -= self.gameListView.frame.height - 100
                }, completion: nil)
                
                isAnimated = true
                
                locationGameListView.text = item.locationName
                self.tableGameList.reloadData()
                
            }
            
        }
        else if item.OwnerUID != userUID {
            
            ControltMode = .GameView
            self.openNormalGameView(index: indexed, markers: marker)
            
            
        } else {
            
            ControltMode = .hosterController
            self.openHosterControl(index: indexed , marker: marker)
            
            
            
        }
        
    
        

    
    
    
    }
    
    
    func openHosterControl(index: Int, marker: GMSMarker?) {
        
        
        
        
        
        
        
        controlGameIndexed = index

        hosterController.isHidden = false
        let item = listGameRequest[index]
        
        
        ManagedGameKey = item.key
        ManagedGameType = item.type
        ManagedGameCountry = item.country
        ManagehosterUID = item.OwnerUID
        ManageKeyChat = item.chatKey
        ManageCommunityKey = item.CommunityKey
        placeName = item.locationName
        ManageTimePlayed = Int64((item.timePlay as? TimeInterval)!) / 1000

         hosterHighTemp.text = String(item.highTemp)
         hosterMinTemp.text = String(item.lowTemp)
         hosterAverageTemp.text = String(item.temperature) + "°" + "F"
         hosterWeatherIcon.image = UIImage(named: item.weatherDescription)

        
        let warm = 68..<86
        let cool = 44.6 ..< 68.0
        if item.temperature > 86 {
            
            hosterWeatherView.backgroundColor = HotTemperatureColor
            
        } else if warm.contains(item.temperature) {
            
            hosterWeatherView.backgroundColor = WarmTemperatureColor
            
            
            
        } else if cool.contains(Double(item.temperature)) {
            hosterWeatherView.backgroundColor = CoolTemperatureColor
        } else {
            
            hosterWeatherView.backgroundColor = ColdTemperatureColor
            
        }
        
        
        
        avatarImgHosterControll.image = nil
        let icon = item.type.lowercased()
        let baseLocation = CLLocation(latitude: originalLat!, longitude: originalLon!)
        
        let destinationLocations = CLLocation(latitude: item.latitude, longitude: item.longtitude)
        destinationName = item.locationName
        
        
        //
        
        //editGameBtn
        //setting lbl
        let times = Int64((item.timePlay as? TimeInterval)!) / 1000
        let todays = (Int64(Date().timeIntervalSince1970))
        
        
        
        
        if times <= todays {
            
            
            
            editGameBtn.isHidden = true
            launchNavigationBtn.isHidden = true
            
            
        } else {
            let changes = Double(times - todays)
            let day = Double(3600 * 3)
            if changes <= day {
                
                editGameBtn.isHidden = true
                
                
                
            } else {
                
                editGameBtn.isHidden = false
                
                
                
            }
            
            launchNavigationBtn.isHidden = false
        }
        
        
        var distance = calculateDistanceBetweenTwoCoordinator(baseLocation: baseLocation, destinationLocation: destinationLocations)
        
        distance = distance * 0.000621371192
        
        
        hosterDistance.text =  formatter.string(from: distance as NSNumber)! + " " + "miles"
        
        OriginalLocation = baseLocation
        destinationLocation = destinationLocations
        
        typeGameHosterControll.image = UIImage(named: icon)
        
        descriptionWeatherHosterControl.text = item.DescriptionWeather
        typeWeatherHosterControl.image = UIImage(named: item.weatherDescription)
        
        nameHosterControl.text = item.gameName
        
        addressHosterControl.text = item.locationName
        
        PeopleCountHosterControl.text = String(item.JoinedUserArray.count)
        
        // process timestamp
        
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        timeFormatter.timeStyle = DateFormatter.Style.short
        let time = (item.timePlay as? TimeInterval)! / 1000
        let date = Date(timeIntervalSince1970: time)
        let Dateresult = dateFormatter.string(from: date)
        let Timeresult = timeFormatter.string(from: date)
        dateHosterControl.text = Dateresult
        timeHosterControl.text = Timeresult
        
        
        setingIcon = icon
        setingGameName = item.gameName
        setingGameLocation = item.locationName
        setingGameTime = Dateresult + " " + Timeresult
        setingNumberOfPeople = item.numberOfpeople
        
        if item.VideoUrl != "nil" {
            
            playVideoBtn.isHidden = false
            DoneUrl = URL(string: item.VideoUrl)
            
            if try! InformationStorage?.existsObject(ofType: String.self, forKey: item.VideoUrl) != false {
                
                
            } else {
                
                
                let time = Int64((item.timePlay as? TimeInterval)!) / 1000
                let today = (Int64(Date().timeIntervalSince1970))
                
                let change = Double(time - today)
                
                
                try! InformationStorage?.setObject(item.VideoUrl, forKey: item.VideoUrl, expiry: .date(Date().addingTimeInterval(change)))
                
                WatchVideoAgain()
                

            }
            

        } else {
            
            playVideoHosterControl.isHidden = true
            
        }
        
        
        if item.avatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: item.avatarUrl).image {
                
                
                
                avatarImgHosterControll.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(item.avatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: item.avatarUrl)
                        self.avatarImgHosterControll.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
        } else {
            
            self.avatarImgHosterControll.image = UIImage(named: "CRACC")
            
        }
        
        
        
    }
    
    
    func openNormalGameView (index: Int, markers: GMSMarker?) {
        
        controlGameView.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.controlGameView.center.y -= self.controlGameView.frame.height * 2/3
        }, completion: nil)
        
        let item = listGameRequest[index]
        
        JoinedIndex = index
        
        //let gameMarker = markers
        
        /*
        if gameMarker != nil {
            
            markers?.icon = UIImage(named: "Already" + item.type)
            
        }

      */
        self.avatarGameView.image = nil
        
        
        if try! InformationStorage?.existsObject(ofType: String.self, forKey: item.key) != true {
            
            
            let time = Int64((item.timePlay as? TimeInterval)!) / 1000
            let today = (Int64(Date().timeIntervalSince1970))
            
            let change = Double(time - today)
            
            
            
            
            try! InformationStorage?.setObject(item.type, forKey: item.key, expiry: .date(Date().addingTimeInterval(change)))
            
            
        }
        
        
        ManagedGameKey = item.key
        ManagedGameType = item.type
        ManagedGameCountry = item.country
        ManageKeyChat = item.chatKey
        ManageNumberOfPeple = item.numberOfpeople
        
        
        let icon = item.type.lowercased()
        
        
        let baseLocation = CLLocation(latitude: originalLat!, longitude: originalLon!)
        
        let destinationLocations = CLLocation(latitude: item.latitude, longitude: item.longtitude)
        destinationName = item.locationName
        
        OriginalLocation = baseLocation
        destinationLocation = destinationLocations
        
        var distance = calculateDistanceBetweenTwoCoordinator(baseLocation: baseLocation, destinationLocation: destinationLocations)
        
        distance = distance * 0.000621371192
        
        
        distanceGameView.text =  formatter.string(from: distance as NSNumber)! + " " + "miles"
        
        
        
        typeGameView.image = UIImage(named: icon)
        
        
        
        weatherDescriptionGamView.text = item.DescriptionWeather
        weatherTypeGameView.image = UIImage(named: item.weatherDescription)
        
        nameGameView.text = item.gameName
        
        addressGameView.text = item.locationName
        
        numberOfPeopleGameView.text = String(item.JoinedUserArray.count) + " out of " + String(item.numberOfpeople)
        
        let times = Int64((item.timePlay as? TimeInterval)!) / 1000
        let todays = (Int64(Date().timeIntervalSince1970))
        
        
        
        
         let Url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("Information").child("Joined_User")
        
        Url.child(userUID).observeSingleEvent(of: .value, with: { (snap) in
            
            if snap.exists() {
                
                
                if times <= todays {
                    
                    
                    
                    self.joinNowBtn.isHidden = true
                    self.inviteAndLeaveView.isHidden = true
                    
                    
                } else {
                    let changes = Double(times - todays)
                    let day = Double(3600 * 3)
                    if changes <= day {
                        
                        self.joinNowBtn.isHidden = true
                        self.inviteAndLeaveView.isHidden = true
                        
                        
                        
                    } else {
                        
                        self.joinNowBtn.isHidden = true
                        self.inviteAndLeaveView.isHidden = false
                        
                        if self.localLocation != nil, self.destinationLocation != nil {
                            
                            var far = self.calculateDistanceBetweenTwoCoordinator(baseLocation: self.localLocation, destinationLocation: self.destinationLocation)
                            far = far * 0.000621371192
                            
                            
                            if far > 95.000 {
                                
                                self.joinNowBtn.isHidden = true
                                self.inviteAndLeaveView.isHidden = true
                                
                            } else {
                                
                                
                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Requested").child(ManagedGameKey).observeSingleEvent(of: .value, with: { (snap) in
                                    
                                    
                                    if snap.exists() {
                                        
                                        self.joinNowBtn.setTitle("Requested", for: .normal)
                                        
                                    } else {
                                        
                                        self.joinNowBtn.setTitle("Join now", for: .normal)
                                        
                                    }
                                    
                                    
                                    
                                    
                                })
                                
                                
                            }
                        } else {
                            
                            self.joinNowBtn.isHidden = true
                            self.inviteAndLeaveView.isHidden = true
                            
                        }
                         
                    }
                    
                }
                
                
                
            } else {
                if times <= todays {
                    
                    
                    
                    self.joinNowBtn.isHidden = true
                    self.inviteAndLeaveView.isHidden = true
                    
                    
                } else {
                    let changes = Double(times - todays)
                    let day = Double(3600 * 3)
                    if changes <= day {
                        
                        self.joinNowBtn.isHidden = true
                        self.inviteAndLeaveView.isHidden = true
                        
                        
                        
                    } else {
                        
                        self.joinNowBtn.isHidden = false
                        self.inviteAndLeaveView.isHidden = true
                        
                        if self.localLocation != nil, self.destinationLocation != nil {
                            
                            var far = self.calculateDistanceBetweenTwoCoordinator(baseLocation: self.localLocation, destinationLocation: self.destinationLocation)
                            far = far * 0.000621371192
                            
                            
                            if far > 95.00 {
                                
                               self.joinNowBtn.isHidden = true
                               self.inviteAndLeaveView.isHidden = true
                                
                            } else {
                                
                                DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Requested").child(ManagedGameKey).observeSingleEvent(of: .value, with: { (snap) in
                                    
                                    
                                    if snap.exists() {
                                        
                                        self.joinNowBtn.setTitle("Requested", for: .normal)
                                        
                                    } else {
                                        
                                        self.joinNowBtn.setTitle("Join now", for: .normal)
                                        
                                    }
                                    
                                    
                                    
                                    
                                })
                                
                                
                            }
                        } else {
                            
                           self.joinNowBtn.isHidden = true
                           self.inviteAndLeaveView.isHidden = true
                            
                        }
                        
                        
                    }
                    
                }
                
                
            }
            
            
        })
 
        // process timestamp
        
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        timeFormatter.timeStyle = DateFormatter.Style.short
        let time = (item.timePlay as? TimeInterval)! / 1000
        let date = Date(timeIntervalSince1970: time)
        let Dateresult = dateFormatter.string(from: date)
        let Timeresult = timeFormatter.string(from: date)
        DateGameView.text = Dateresult
        timeGameView.text = Timeresult
        
        
        
        
        
        highTempLblWeatherView.text = String(item.highTemp)
        lowTempLblWeatherView.text = String(item.lowTemp)
        averageTempLblWeatherView.text = String(item.temperature) + "°" + "F"
        imageWeatherView.image = UIImage(named: item.weatherDescription)
        
        
        
        
        let warm = 68..<86
        let cool = 44.6 ..< 68.0
        if item.temperature > 86 {
            
            weatherView.backgroundColor = HotTemperatureColor
            
        } else if warm.contains(item.temperature) {
            
            weatherView.backgroundColor = WarmTemperatureColor
            
            
            
        } else if cool.contains(Double(item.temperature)) {
            weatherView.backgroundColor = CoolTemperatureColor
        } else {
            
            weatherView.backgroundColor = ColdTemperatureColor
            
        }
        
        if item.VideoUrl != "nil" {
            
            playVideoBtn.isHidden = false
            DoneUrl = URL(string: item.VideoUrl)
            
            if try! InformationStorage?.existsObject(ofType: String.self, forKey: item.VideoUrl) != false {
                
                
            } else {
                
                
                let time = Int64((item.timePlay as? TimeInterval)!) / 1000
                let today = (Int64(Date().timeIntervalSince1970))
                
                let change = Double(time - today)
                
                
                try! InformationStorage?.setObject(item.VideoUrl, forKey: item.VideoUrl, expiry: .date(Date().addingTimeInterval(change)))
                
                WatchVideoAgain()
                
                
                
                
            }
            
           
            
            
            
            
            
            
        } else {
            
            playVideoBtn.isHidden = true
            
        }
        
        avatarLoader.startAnimating()
        
        if item.avatarUrl != "nil" {
            
            if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: item.avatarUrl).image {
                
                
                
                avatarGameView.image = ownerImageCached
                
                
            } else {
                
                
                Alamofire.request(item.avatarUrl!).responseImage { response in
                    
                    if let image = response.result.value {
                        
                        let wrapper = ImageWrapper(image: image)
                        try? InformationStorage?.setObject(wrapper, forKey: item.avatarUrl)
                        self.avatarGameView.image = image
                        
                    }
                    
                }
                
                
                
                
                
            }
            
            
        } else {
            
            self.avatarGameView.image = UIImage(named: "CRACC")
            
        }
        avatarLoader.stopAnimating()
        
        
        
        if item.JoinedUserArray.isEmpty != true {
            
            numberOfPeople = item.JoinedUserArray.count
            
        } else {
            
            numberOfPeople = 0
        }
        
        
        
        
        
        
        
        
        
 
        
        numberOfPeople = Int(item.numberOfpeople)
        keyChat = item.chatKey
        nameGroupChat = item.gameName
        hosterUID = item.OwnerUID
        hosterType = item.HosterType
        timePLay = item.timePlay
        typeChosen = item.type
        countryOfGameViewed = item.country
        gameKeyJoined = item.key
        locationJoined = item.locationName
        JoinedhosterUID = item.OwnerUID
        placeName = item.locationName
        
        
        
        
    
    }
    
    
    func getlistChat() {
        
        
        let time = (Int64(Date().timeIntervalSince1970 * 1000))
        
        if  userType != "", userUID != "" {
        
            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Chat_List").queryOrdered(byChild: "time").queryStarting(atValue: time).observeSingleEvent(of: .value, with: { (snapFriend) in
                
                
                if snapFriend.exists() {
                    
                    
                    if let snap = snapFriend.children.allObjects as? [DataSnapshot] {
                        for item in snap {
                            
                            
                            if let postFriend = item.value as? Dictionary<String, Any> {
                                
                                let key = snapFriend.key
                                let FriendData = chatModel(postKey: key, ChatList: postFriend)
                                self.chatList.append(FriendData)
                                
                                
                            }
                            
                            
                        }
                        
                        
                        self.chatTableView.reloadData()
                        
                    }
                    
                } else {
                    
                    
                    
                }
                
                
                
                
                
                
            })
        
        } else {
        
            
            self.showErrorAlert("Opps !!!", msg: "Error occured, please try again")
        
        
        }
        
        
        // rate function
        
        
        
        
        
        
    }
    
    
    func getAddChat(completed: @escaping DownloadComplete) {
        self.chatList.removeAll()
        self.chatTableView.reloadData()
        
        
        if  userType != "", userUID != "" {
            
            DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID).child("Add_Chat").queryOrdered(byChild: "time").observeSingleEvent(of: .value, with: { (snapFriend) in
                
                
                if snapFriend.exists() {
                    
                    
                    if let snap = snapFriend.children.allObjects as? [DataSnapshot] {
                        for item in snap {
                            
                            
                            if let postFriend = item.value as? Dictionary<String, Any> {
                                
                                let key = snapFriend.key
                                let FriendData = chatModel(postKey: key, ChatList: postFriend)
                                self.chatList.insert(FriendData, at: 0)
                                
                                
                            }
                            
                            self.chatTableView.reloadData()
                        }
                        
                        
                        
                        
                        completed()
                        
                    }
                    
                } else {
                    
                    completed()
                    
                }
                
                
                
                
                
                
            })
            
        } else {
            
            
            self.showErrorAlert("Opps !!!", msg: "Error occured, please try again")
            
            
        }
        
    }

    
}

extension MapVC  {
    func centerMapOnUserLocation() {
        
        destinationSearchBar.isHidden = true
        destinationLbl.text = ""
        
        // get coordinate
        guard let coordinate = locationManager.location?.coordinate else { return }
        listMakrer.removeAll()
        
        originalLon = coordinate.longitude
        originalLat = coordinate.latitude
        
        localLocation = CLLocation(latitude: coordinate.latitude, longitude:coordinate.longitude)
        
        let cordinated = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        // get MapView
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 9)
        

        
        marker.position = cordinated
        marker.title = "My Location"
        myLocationLbl.text = "My Location"
        marker.icon = nil
        
        
        
        mapView.clear()
        
        
        
        
        
        marker.map = mapView
        mapView.camera = camera
        mapView.animate(to: camera)
        marker.appearAnimation = GMSMarkerAnimation.pop
        
        
        marker.isTappable = false
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        myView.backgroundColor = UIColor.clear
        marker.iconView = myView
        
        
        let pulsator = Pulsator()
        pulsator.radius = 35
        pulsator.backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 1).cgColor
        //pulsator.backgroundColor = UIColor.black.cgColor
        pulsator.position =  (marker.iconView!.center)
        marker.iconView?.layer.addSublayer(pulsator)
        marker.iconView?.backgroundColor = UIColor.clear
        pulsator.start()
        
        
        
        myView.backgroundColor = UIColor.clear
        let IconImage = resizeImage(image: UIImage(named: "loc")!, targetSize: CGSize(width: 20.0, height: 20.0))
        let markerView = UIImageView(image: IconImage)
        markerView.center = myView.center
        myView.addSubview(markerView)
        
        //let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
       let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(coordinate.latitude),\(coordinate.longitude)&language=en&key=\(GoogleMap_key)"
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            
            switch response.result {
            case .success:
        
                if let result = response.result.value as? [String: Any] {
                    
                    for i in result {
                        
                        if i.key == "results" {
                            
                            
                            if let results = i.value as? [Dictionary<String, AnyObject>] {
                                for x in results {
                                    
                                    if let add = x["address_components"] as? [Dictionary<String, AnyObject>] {
                                        
                                        for y in add {
                                            
                                            if let coun = y["types"] as? [String] {
                                                
                                                if coun.contains("country") {
                                                    
                                                    if let country = y["long_name"] as? String {
                                                        
                                                        self.countryRequested = country
                                                        break
                                                    }
                                                    
                                                }
                                                
                                            } else {
                                                
                                                print("err casting")
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                            } else {
                                print("Cannot cast")
                                
                            }
                            
                        }
            
                    }
                    
                }
                
                
            case .failure:
                print("Cannot retrieve infomation")
            }
            
            
        }
        
        
       
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        

        switch ControllCollection {
        case .requestGame:
            if collectionView == self.collectionView {
                return ListGame.count
            }
            return 0
        case .CreateGame:
            if collectionView == self.chooseGameTypeCollectionView {
                return ListGame.count
            }
            return 0

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let gameLabel = ListGame[indexPath.row]
        let Cellimage = listImage[indexPath.row]
        
        //ChooseGameTypeCell
        
        switch ControllCollection {
        case .requestGame:
            if collectionView == self.collectionView {
                if let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as? GameCell {
                    
                    cell.configureCell(image: Cellimage!, gameText: gameLabel)
                    
                    
                    
                    return cell
                } else {
                    
                    return UICollectionViewCell()
                    
                }
            }
            

            
            
            
            
        case .CreateGame:
            if collectionView == self.chooseGameTypeCollectionView {
                
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseGameTypeCell", for: indexPath) as? ChooseGameTypeCell {
                    
                    cell.configureCell(image: Cellimage!, gameText: gameLabel)
                    
                    
                    
                    return cell
                }   else {
                    
                    return UICollectionViewCell()
                    
                }
                
                
            }
            
            
        
        }

        
        return UICollectionViewCell()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = listImage[indexPath.row]
        let game = ListGame[indexPath.row]
        
        
        switch(ControllCollection) {
        
        case .CreateGame :
            imageType.image = item
            type = game
            self.ChooseGameTypeView.isHidden = true
            self.blurView.isHidden = true
        case .requestGame:
            
            CloseGameView()
            

            
            gameKey.removeAll()
            
            if countryRequested != nil {
                gameKey.removeAll()
                getLocation(lat: originalLat!, lon: originalLon!)
                let url = DataService.instance.GameCoordinateRef.child(countryRequested!).child(game)
                let geofireRef = url
                let geoFire = GeoFire(firebaseRef: geofireRef)
                let loc = CLLocation(latitude: originalLat!, longitude: originalLon!)
                let query = geoFire.query(at: loc, withRadius: 95)
                
                
                self.getGameRadius(game: game, query: query)
            
            
            } else {
            
                print("Can't retrieve information")
            }
            
            
            
            
            
        }

        
        
        
    }
    
    
    
    
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
        return 1.0
    }

    
    
    
    
    
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}



    
    
extension MapVC: CLLocationManagerDelegate {
    
    // check if auth is not nil then request auth
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // get my location with zoom 30
        centerMapOnUserLocation()
    }
    
    
    func getLocation(lat: CLLocationDegrees, lon: CLLocationDegrees) {
    
        mapView.clear()
        
        
        // get MapView
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 9)
        let cordinated = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        
        marker.position = cordinated
        marker.title = "My Location"
        marker.map = mapView
        mapView.animate(to: camera)
        marker.appearAnimation = GMSMarkerAnimation.pop
        
        mapView.camera = camera
        
        
        
        
    
    
    }
    
    
    func createDayPicker() {
        
        
        let dayPicker = UIPickerView()
        dayPicker.delegate = self

        //Customizations
        
        
        
        switch (pickerViewController){
            
            case .numberOfPeople:
                if inSettingMode {
                    
                    settingGameNumberOfPeople.inputView = dayPicker
                    
                } else {
                    
                    numberPeopleLbl.inputView = dayPicker
                    
                }
            
            case .age:
                ageLbl.inputView = dayPicker
            case .gender:
                genderLbl.inputView = dayPicker
            
        }
        
        
        
        
        
    }
    
    
    
    
    
    
}

extension MapVC: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        let placed = place.name

        
        
       
        let lat = place.coordinate.latitude
        let lon = place.coordinate.longitude
        
        
        self.lat = lat
        self.lon = lon
        
        
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(place.coordinate.latitude),\(place.coordinate.longitude)&language=en&key=\(GoogleMap_key)"
        
       
        
        
        
        Alamofire.request(url).responseJSON { (response) in
            
            
            switch response.result {
            case .success:
                
                if let result = response.result.value as? [String: Any] {
                    
                    for i in result {
                        
                        if i.key == "results" {
                            
                            
                            if let results = i.value as? [Dictionary<String, AnyObject>] {
                                for x in results {
                                    
                                    if let add = x["address_components"] as? [Dictionary<String, AnyObject>] {
                                        
                                        for y in add {
                                            
                                            if let coun = y["types"] as? [String] {
                                                
                                                if coun.contains("country") {
                                                    
                                                    if let country = y["long_name"] as? String {
                                                        
                                                        self.countryRequested = country
                                                        self.countryCreated = country
                                                        break
                                                    }
                                                    
                                                }
                                                
                                            } else {
                                                
                                                print("err casting")
                                                
                                            }
                                            
                                        }
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                            } else {
                                print("Cannot cast")
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
                
            case .failure:
                print("Cannot retrieve infomation")
            }
            
            
        }

        switch controlSearch {
        case .normalSearch:

            myLocationLbl.text = placed
            originalLat = lat
            originalLon = lon
            getLocation(lat: lat, lon: lon)

            
        case .CreateSearch:
            
            createLocation = CLLocation(latitude: lat, longitude: lon)
           
            if dateLbl.text != "" {
                self.forecasts.removeAll()
                self.downloadForecastData(latitude: lat, longitude: lon) {
                    self.getWeather(time: self.timeSelected!)
                    
                }
                
            }
            
            LocationLbl.text = placed
            
        case .settingSearch:
            
            
            if settingGameTime.text != "" {
                self.forecasts.removeAll()
                self.downloadForecastData(latitude: lat, longitude: lon) {
                    self.getWeather(time: self.timeSetting!)
                    
                }
                
            }
            
                settingLat = lat
                settingLon = lon
            
                settingGameLocation.text = placed

        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}


extension MapVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch (pickerViewController){
            
        case .numberOfPeople:
            return 1
        case .age:
            return 2
        case .gender:
            return 1
            
        }

    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch (pickerViewController){
            
        case .numberOfPeople:
            return NumberOfPeople.count
        case .age:
            if component == 0 {
                return MaxAge.count
            }
                
            else {
                return MinAge.count
            }
        case .gender:
            return Gender.count
            
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        
        switch (pickerViewController){
            
        case .numberOfPeople:
            return NumberOfPeople[row]
        case .age:
            if component == 0 {
                return MaxAge[row]
            }
                
            else {
                return MinAge[row]
            }
        case .gender:
            return Gender[row]
            
        }
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
        
        switch (pickerViewController){
            
        case .numberOfPeople:
            selectedPicker = NumberOfPeople[row]
            if inSettingMode {
                
                settingGameNumberOfPeople.text = selectedPicker
                
            } else {
                
                numberPeopleLbl.text = selectedPicker
            }
            
        case .age:
            //selectedPicker = NumberOfPeople[row]
            if component == 0 {
                let min = MinAge[row]
                MinAgeSelected = min
            }
                
            else {
                let max = MaxAge[row]
                MaxAgeSelected = max
                
            }
            
            if MinAgeSelected == nil {
                
                ageLbl.text = " - " + MaxAgeSelected!
                
            } else if MaxAgeSelected == nil {
                
                ageLbl.text = MinAgeSelected! + " - "
                
            } else {
                if let min = Int(MinAgeSelected!), let max = Int(MaxAgeSelected!) {
                    
                    if min > max {
                        
                        self.showErrorAlert("Opps !!!", msg: "CRACC: The max age should be larger than or equal the min age")
                        
                        ageLbl.text = ""
                        MinAgeSelected = nil
                        MaxAgeSelected = nil
                        return
                        
                        
                    }
                    
                    ageLbl.text = MinAgeSelected! + " - " + MaxAgeSelected!
                }
            
            }
        case .gender:
            genderLbl.text = Gender[row]
            GenderSelected = genderLbl.text
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel!
        
        
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        switch (pickerViewController){
            
        case .numberOfPeople:
            label.text = NumberOfPeople[row]
        case .age:
            if component == 0 {
            label.text = MaxAge[row]
            }
                
            else {
            label.text = MinAge[row]
            }
        case .gender:
            label.text = Gender[row]
            
        }
        label.textAlignment = .center
        return label

        

        

    }
}

extension String {
    var byWords: [String] {
        var byWords:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            guard let word = $0 else { return }
            print($1,$2,$3)
            byWords.append(word)
        }
        return byWords
    }
    func firstWords(_ max: Int) -> [String] {
        return Array(byWords.prefix(max))
    }
    var firstWord: String {
        return byWords.first ?? ""
    }
    func lastWords(_ max: Int) -> [String] {
        return Array(byWords.suffix(max))
    }
    var lastWord: String {
        return byWords.last ?? ""
    }
}

extension MapVC {



    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableControl {
        case .chatList:
            if tableView == self.chatTableView {
                return 1
            }
            return 0
        case .controlGameList:
            if tableView == self.tableGameList {
                return 1
            }
            return 0
        case .MVPlist:
            if tableView == self.MVPtableView {
                return 1
            }
            return 0
            
            
        case .commentList:
            if tableView == self.informationTableView {
                if commentUserArr.isEmpty != true {
                    
                    informationTableView.restore()
                    return 1
                }
                
                informationTableView.setEmptyMessage("No recently comment about this player")
                return 0
                }
            
            
            return 0
            
        case .addChat:
            if tableView == self.addChatTableView {
                if FriendListArray.isEmpty != true || filterList.isEmpty != true {
                    
                    self.addChatTableView.restore()
                    return 1
                }
                
                self.addChatTableView.setEmptyMessage("Can't find any friend to add")
                return 0
            }
            
            
            return 0
            
        case .controlPeople:
            if tableView == self.controlPeopleTableView {
                if joinedUserArr.isEmpty != true {
                    
                    controlPeopleTableView.restore()
                    return 1
                }
                
                self.controlPeopleTableView.setEmptyMessage("No recently joined player")
                return 1
            }
            
            
            return 0
            
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableControl {
        case .chatList:
            if tableView == self.chatTableView {
                
                return chatList.count
                
            }
            return 0
        case .controlGameList:
            if tableView == self.tableGameList {
                return GameList.count
            }
            return 0
        case .MVPlist:
            if tableView == self.MVPtableView {
                return ChooseMVPPlayerArr.count
            }
            return 0
            
            
        case .commentList:
            if tableView == self.informationTableView {
                return commentUserArr.count
            }
            return 0
            
        case .addChat:
            if tableView == self.addChatTableView {
                if insearchMode {
                    return filterList.count
                } else {
                    return FriendListArray.count
                }
                
            }
            
            return 0
            
            
        case .controlPeople:
            
            if tableView == self.controlPeopleTableView {
                
                return joinedUserArr.count
                
            }
            return 0
            
            
            
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        switch tableControl {
        case .chatList:
            
            if tableView == self.chatTableView {
                let nickName: chatModel
                nickName = chatList[indexPath.row]
                
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatViewCell") as? ChatViewCell {
                    
                    cell.delegate = self
                    cell.configureCell(nickName)
                    return cell
                } else {
                    return ChatViewCell()
                }
                
            } else {
                return ChatViewCell()
            }
            
        case .controlGameList:
            if tableView == self.tableGameList {
                let nickName: requestModel
                nickName = GameList[indexPath.row]
                
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "GameListCell") as? GameListCell {
                    
                    
                    cell.configureCell(nickName)
                    return cell
                } else {
                    return ChatViewCell()
                }
            } else {
                
                
                return GameListCell()
                
            }
            
        case .MVPlist:
            if tableView == self.MVPtableView {
                let mvp: RecentlyPlayedModel
                mvp = ChooseMVPPlayerArr[indexPath.row]
                
                if let cell = tableView.dequeueReusableCell(withIdentifier: "mvpCell") as? mvpCell {
                    
                    
                    cell.configureCell(mvp)
                    return cell
                } else {
                    return mvpCell()
                }
            } else {
                
                return UITableViewCell()
            }

            case .commentList:

                if tableView == self.informationTableView {
                    
                    let cmt: CommentModel
                    cmt = commentUserArr[indexPath.row]
                
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell") as? commentCell {
                        cell.configureCell(cmt)
                        return cell
                    } else {
                        return commentCell()
                    }
                
                } else {
                    
                    return UITableViewCell()
                    
                    
                }
            
            case .addChat:
            
                if tableView == self.addChatTableView {
                    
                    let fr: FriendModel!
                    
                    if insearchMode {
                        fr = filterList[indexPath.row]
                    } else {
                        fr = FriendListArray[indexPath.row]
                    }
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "AddChatCell") as? AddChatCell {
                        
                        
                        cell.addChatBtn.imageView?.image = nil
                        cell.addChatBtn.setImage(nil, for: .normal)
                        cell.addChatBtn.tag = indexPath.row
                        cell.addChatBtn.addTarget(self, action: #selector(MapVC.handleSelectPeople), for: .touchUpInside)
                        cell.configureCell(fr)
                        return cell
                    } else {
                        return AddChatCell()
                    }
                    
                } else {
                    
                    return UITableViewCell()
                    
                    
            }
            
            case .controlPeople:
                if tableView == self.controlPeopleTableView {
                    
                    let fr: RecentlyPlayedModel
                    fr = joinedUserArr[indexPath.row]
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ControlPeopleCell") as? ControlPeopleCell {
                        cell.delegate = self
                        
                        cell.configureCell(fr)
                        return cell
                    } else {
                        return ControlPeopleCell()
                    }
                } else {
                    
                    return UITableViewCell()
                }
            
        }
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        switch tableControl {
        case .chatList:
            if tableView == self.chatTableView {
                
                
                let item = chatList[indexPath.row]
                
                if item.isGroup == 1 {
                    
                    groupKeyChat = item.key
                    GroupName = item.name
                    hosterUID = item.HosterUID
                    isGroup = true
                    
                } else {
                    
                    frUID = item.FruserUID
                    frName = item.Frname
                    frType = item.FrType
                    frAvatarUrl = item.FrAvatarUrl
                    isGroup = false
                    
                }
                
                
                
                
                
                self.performSegue(withIdentifier: "moveToChatVC", sender: nil)
                
                
            }
            
            
        case .controlGameList:
           
            let item = GameList[indexPath.item]
            let key = item.key

            if tableView == self.tableGameList {
                
                var index = 0
                for check in listGameRequest {

                    index += 1
                    if check.key == key {
                        
                        break
                        
                    }
                    
                }
                
            index -= 1
                
                
                
                gameListView.isHidden = true
             
                if item.OwnerUID != userUID {
                    
                    ControltMode = .GameView
                    self.openNormalGameView(index: index, markers: marker)
                    
                    
                } else {
                    
                    ControltMode = .hosterController
                    self.openHosterControl(index: index , marker: marker)
                    
                    
                    
                }
             
            }
            
        case .MVPlist:
            
            
            let mvpColor = UIColor(red: 243/255, green: 189/255, blue: 85/255, alpha: 1.0)
            
            let item = ChooseMVPPlayerArr[indexPath.row]
            
            MVPIndex = indexPath.row
            
            self.MVPView.isHidden = true
            self.blurView.isHidden = true
            
            
            MVPBtn.layer.masksToBounds = true
            MVPBtn.layer.borderColor = mvpColor.cgColor
            MVPBtn.layer.borderWidth = 4
            MVPBtn.setTitle("", for: .normal)
            
            
            if item.JoinedAvatarUrl != "nil" {
                
                if let ownerImageCached = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: item.JoinedAvatarUrl).image {
                    
                    
                   
                    
                    MVPBtn.setImage(ownerImageCached?.withRenderingMode(.alwaysOriginal), for: .normal)
                   // MVPBtn.setImage(ownerImageCached, for: .normal)
                    
                    
                    
                    
                } else {
                    
                    
                    Alamofire.request(item.JoinedAvatarUrl!).responseImage { response in
                        
                        if let image = response.result.value {
                            
                            let wrapper = ImageWrapper(image: image)
                            try? InformationStorage?.setObject(wrapper, forKey: item.JoinedAvatarUrl)
                            self.MVPBtn.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                            
                        }
                        
                    }
                    
                    
                    
                    
                    
                }
                
            } else {
                
                
                
                MVPBtn.setImage(UIImage(named: "CRACC")?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
            
            case .commentList:
            
            
            
                if tableView == self.informationTableView {
                    
                    
                    
                }
            
            case .addChat:
            
                if tableView == self.addChatTableView {
                    
                    
                    
                    if let cell = addChatTableView.cellForRow(at: indexPath) as? AddChatCell {
                        
                        if cell.addChatBtn.imageView?.image != nil {
                            
                            let item = indexPath.row
                            if let indexes = index.index(of: item) {
                                index.remove(at: indexes)
                            }
                            
                            cell.addChatBtn.imageView?.image = nil
                            cell.addChatBtn.setImage(nil, for: .normal)
                            
                        } else {
                            
                            let item = indexPath.row
                            
                            cell.addChatBtn.setImage(UIImage(named: "ticksss"), for: .normal)
                            
                            index.append(item)
                            
                            
                        }
                        
                    }
                    
    
                    
                    
                   
                    
                }
            
            case .controlPeople:
            
                let item = joinedUserArr[indexPath.row]
                
                InfoUID = item.JoineduserUID
                InfoType = item.JoineduserType
            
            
                openInformation()
            
            
            
        }

    }
    
    
    // swipe table view
    
    
   
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        
        switch tableControl {
        case .chatList:
            return true
        case .addChat:
            return false
        case .controlGameList:
            return false
        case .MVPlist:
            return false
        case .commentList:
            return false
        case .controlPeople:
            
            let todays = (Int64(Date().timeIntervalSince1970))

            if ManageTimePlayed <= todays {
               return false
            } else {
                let changes = Double(ManageTimePlayed - todays)
                let day = Double(3600 * 3)
                if changes <= day {
                    
                    return false
                    
                } else {
                    
                    return true
                    
                }
            }
            
        }
    }
    
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        
        switch tableControl {
        case .chatList:
            swipeSettings.transition = MGSwipeTransition.border
            expansionSettings.buttonIndex = 0
            let Deletedcolor = UIColor.init(red:1.0, green:59/255.0, blue:50/255.0, alpha:1.0)
            let padding = 15
            if direction == MGSwipeDirection.leftToRight {
                
                return nil
                
                
            } else {
                expansionSettings.fillOnTrigger = true
                expansionSettings.threshold = 1.1
                
                
                let delete = MGSwipeButton(title: "Delete", backgroundColor: Deletedcolor, padding: padding,  callback: { (cell) -> Bool in
                    
                    
                    self.deleteAtIndexPath(self.chatTableView.indexPath(for: cell)!)
                    
                    return false; //don't autohide to improve delete animation
                });

                return [delete]
            }
        case .addChat:
            return nil
        case .controlGameList:
            return nil
        case .MVPlist:
            return nil
        case .commentList:
            return nil
        case .controlPeople:
            swipeSettings.transition = MGSwipeTransition.border
            expansionSettings.buttonIndex = 0
            //let Deletedcolor = UIColor.init(red:1.0, green:59/255.0, blue:50/255.0, alpha:1.0)
            let padding = 8
            if direction == MGSwipeDirection.leftToRight {
                
                expansionSettings.fillOnTrigger = true
                expansionSettings.threshold = 1.1
                
                
                let delete = MGSwipeButton(title: "Kick Out", backgroundColor: UIColor.lightGray, padding: padding,  callback: { (cell) -> Bool in
                    
                    
                    self.removeJoinedUser(self.controlPeopleTableView.indexPath(for: cell)!)
                    
                    return false; //don't autohide to improve delete animation
                });
                
                
                
                
                return [delete]
                
                
            } else {
                return nil
            }
        
        }
        
        
        
        
        
        
        
        
        
    }
    
    
    func deleteAtIndexPath(_ path: IndexPath) {
        
        let nickName: chatModel!
        
        nickName = chatList[path.row]
        
        
        
        if nickName.Frname != "" {
            // setup Information
            let Url = DataService.instance.mainDataBaseRef.child("User").child(userType).child(userUID)
            
            Url.child("Add_Chat").child(nickName.FruserUID).removeValue()
            
            chatList.remove(at: (path as NSIndexPath).row)
            chatTableView.deleteRows(at: [path], with: .left)
        } else {
            
            
            
            
            
            let alert = SCLAlertView()
            
            
            _ = alert.showError("Oops!!!", subTitle: "CRACC: Cannot leave game chat until you leave the game")
        }
        
        
       
        
        
        
        
        
    }
    
    func removeJoinedUser(_ path: IndexPath) {
        
        let nickName: RecentlyPlayedModel!
        
        nickName = joinedUserArr[path.row]
        
        
        
        if nickName.Joinedname != "" {
            // setup Information
            let Url = DataService.instance.GamePostRef.child(ManagedGameCountry).child(ManagedGameType).child(ManagedGameKey).child("Information").child("Joined_User")
            let BanUrl = DataService.instance.mainDataBaseRef.child("Kicked_Game").child(ManagedGameKey).child(nickName.JoineduserUID)
            let userUrl = DataService.instance.mainDataBaseRef.child("User").child(nickName.JoineduserType).child(nickName.JoineduserUID)
            
            let chatUrl = DataService.instance.GameChatRef.child(ManageKeyChat)
            BanUrl.setValue(1)
            Url.child(nickName.JoineduserUID).removeValue()
            userUrl.child("Game_Joined").child(ManagedGameKey).removeValue()
            userUrl.child("Cached_Game").child(ManagedGameKey).removeValue()
            userUrl.child("Chat_List").child(ManageKeyChat).removeValue()
            chatUrl.child("user").child(nickName.JoineduserUID).removeValue()
            chatUrl.child("online").child(nickName.JoineduserUID).removeValue()
            
            joinedUserArr.remove(at: (path as NSIndexPath).row)
            controlPeopleTableView.deleteRows(at: [path], with: .right)
        } else {
            
            
            
            
            let alert = SCLAlertView()
            
            
            _ = alert.showError("Oops!!!", subTitle: "CRACC: cannot remove this user, please try again later")
        }
        
        
        
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch tableControl {
        case .chatList:
            
            return 48
            
            
        case .controlGameList:

            return tableView.rowHeight
            
        case .MVPlist:
            
            return tableView.rowHeight

        case .commentList:
            

            return tableView.rowHeight
            
        case .addChat:
            
            return tableView.rowHeight
            
        case .controlPeople:
            
            return tableView.rowHeight

        }
    
    }
    
    @objc func handleSelectPeople(sender: UIButton) {
        
        
        
        if sender.imageView?.image != nil {
            
            sender.imageView?.image = nil
            sender.setImage(nil, for: .normal)
            
            
            let item = sender.tag
            if let indexes = index.index(of: item) {
                index.remove(at: indexes)
            }
            
        } else {
            
            let item = sender.tag
            index.append(item)
            sender.setImage(UIImage(named: "ticksss"), for: .normal)
            
            
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "moveToChatVC") {
            
            
            
            
            let navigationView = segue.destination as! UINavigationController
            let ChatController = navigationView.topViewController as? chatVC
            
            
            if isGroup == true {
                
                ChatController?.GroupKey = groupKeyChat
                ChatController?.GroupName = GroupName
                ChatController?.isGroup = isGroup
                ChatController?.hosterUID = hosterUID
                
            } else {
                
                ChatController?.isGroup = isGroup
                ChatController?.FriendUID = frUID
                ChatController?.FriendName = frName
                ChatController?.FriendType = frType
                ChatController?.FriendAvatarUrl = frAvatarUrl
                
            }
            
            
            
            
            
            
        }
    }
    





}
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension Array where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { return reduce(0, +) }
}

extension Array where Element: BinaryInteger {
    /// Returns the average of all elements in the array
    var average: Double {
        return isEmpty ? 0 : Double(Int(total)) / Double(count)
    }
}

extension Array where Element: FloatingPoint {
    /// Returns the average of all elements in the array
    var average: Element {
        return isEmpty ? 0 : total / Element(count)
    }
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        
    }
}



