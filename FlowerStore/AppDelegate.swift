//
//  AppDelegate.swift
//  FlowerStore
//
//  Created by Ivan Borinschi on 10.02.2022.
//

import UIKit
import DSKit
import BranchSDK
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        DSAppearance.shared.main = PeachAppearance()
        DSAppearance.shared.userInterfaceStyle = .light
        
      // if you are using the TEST key
      //Branch.setUseTestBranchKey(false)
      // listener for Branch Deep Link data

      let branch = Branch.getInstance()
        branch.enableLogging()
        branch.checkPasteboardOnInstall()
        //SetMetadataKey
        branch.setRequestMetadataKey("$marketing_cloud_visitor_id", value: "123456789")
        
        //Tracking User Id
        let userID = branch.setIdentity("User Zain")
        print(userID)
        
        
        branch.initSession(launchOptions: launchOptions) { (params, error) in
           // do stuff with deep link data (nav to page, display content, etc)
          print(params as? [String: AnyObject] ?? {})
          
          //store deeplink data to data
          guard let data = params as? [String: AnyObject] else { return }

          //Store deeplink path if presents

          guard let options = data["$deeplink_path"] as? String else { return }
        
            
          //Printing $deeplink_path
          print("This is the deep link data presents", options)
            
          //Store metadata key
          guard let adobe = data["$marketing_cloud_visitor_id"] as? String else { return }

          //Print Metadata key
          print(adobe)
          
      }
      return true
    }
    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        DSAppearance.shared.main = PeachAppearance()
//        DSAppearance.shared.userInterfaceStyle = .light
//        return true
//    }

    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        Branch.getInstance().application(app, open: url, options: options)
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
      // handler for Universal Links
        Branch.getInstance().continue(userActivity)
        return true
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // handler for Push Notifications
      Branch.getInstance().handlePushNotification(userInfo)
    }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

