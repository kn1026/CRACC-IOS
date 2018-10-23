
//
//  AppDelegate.swift
//  CRACC
//
//  Created by Khoi Nguyen on 9/30/17.
//  Copyright © 2017 Cracc LLC. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import FBSDKLoginKit
import GoogleSignIn
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    

    var window: UIWindow?
    
    
    
    

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        
        
        GMSServices.provideAPIKey(GoogleMap_key)
        
        GMSPlacesClient.provideAPIKey(GoogleMap_key)
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        attemptRegisterForNotifications(application: application)
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "hasRunBefore") == false {
            print("The app is launching for the first time. Setting UserDefaults...")
            
            do {
                try Auth.auth().signOut()
            } catch {
                
            }
            
            // Update the flag indicator
            userDefaults.set(true, forKey: "hasRunBefore")
            userDefaults.synchronize() // This forces the app to update userDefaults
            
            // Run code here for the first launch
            
        } else {
            print("The app has been launched before. Loading UserDefaults...")
            // Run code here for every other launch but the first
        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Registered for notifications:", deviceToken)
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Registered with FCM with token:", fcmToken)
    }
    
    
    
    
    
    // listen for user notifications
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
        
        
        
        
        
    }
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        
    }
    
    
   
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo

        
        if let followerId = userInfo["followerId"] as? String {
            print(followerId)
            
            // I want to push the UserProfileController for followerId somehow
            /*
            let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
            userProfileController.userId = followerId
            
            // how do we access our main UI from AppDelegate?
            if let mainTabBarController = window?.rootViewController as? MainTabBarController {
                
                mainTabBarController.selectedIndex = 0
                
                mainTabBarController.presentedViewController?.dismiss(animated: true, completion: nil) 
                
                if let homeNavigationController = mainTabBarController.viewControllers?.first as? UINavigationController {
                    
                    homeNavigationController.pushViewController(userProfileController, animated: true)
                    
                }
                
            }
            
            */
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        
        
        badgeNumber += 1
        let app = UIApplication.shared
        app.applicationIconBadgeNumber = badgeNumber
        
    }
    
    
    
    private func attemptRegisterForNotifications(application: UIApplication) {
        print("Attempting to register APNS...")
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            // user notifications auth
            // all of this works for iOS 10+
            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
                if let err = err {
                    print("Failed to request auth:", err)
                    return
                }
                
                if granted {
                    print("Auth granted.")
                } else {
                    print("Auth denied")
                }
            }
        } else {
            
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
            
            
        }
        
       
        
        application.registerForRemoteNotifications()
    }
    
    
    private func application(application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL?, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    
    func incrementBadgeNumberBy(badgeNumberIncrement: Int) {
        let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
        let updatedBadgeNumber = currentBadgeNumber + badgeNumberIncrement
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
        }
    }
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        if userUID != "" {
            
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "getRecentlyPlayed")), object: nil)
            
            
        }
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
        FBSDKAppEvents.activateApp()
        
        let app = UIApplication.shared
        badgeNumber = 0
        app.applicationIconBadgeNumber = badgeNumber
        
        
        if (try? InformationStorage?.object(ofType: String.self, forKey: "type")) != nil{
            
            
            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "ResetRecentlyPlay")), object: nil)
            
        }
        
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        
    }
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }

    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
 
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, openURL url: URL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    @available(iOS, introduced: 8.0, deprecated: 9.0)
    func application(application: UIApplication,openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application,
                                                                     open: url as URL?,
                                                                     sourceApplication: sourceApplication!,
                                                                     annotation: annotation)
    }
    

    

    

}

