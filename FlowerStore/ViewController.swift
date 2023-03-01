//
//  ViewController.swift
//  FlowerStore
//
//  Created by Ivan Borinschi on 10.02.2022.
//

import UIKit
import DSKit
//import AdSupport
//import AppTrackingTransparency

open class ViewController: DSTabBarViewController {
    
    let store = StoreViewController()
    let aboutUs = AboutUsViewController()
    let contacts = ContactsViewController()
    let history = HistoryViewController()
    
    open override func viewDidLoad() {
        
        
        super.viewDidLoad()
        store.tabBarItem.title = "Store"
        store.tabBarItem.image = UIImage(systemName: "bag.fill")
        
        aboutUs.tabBarItem.title = "About Us"
        aboutUs.tabBarItem.image = UIImage(systemName: "info.circle.fill")
        
        contacts.tabBarItem.title = "Contacts"
        contacts.tabBarItem.image = UIImage(systemName: "map.fill")
        
        history.tabBarItem.title = "History"
        history.tabBarItem.image = UIImage(systemName: "clock.fill")
        
        setViewControllers([DSNavigationViewController(rootViewController: store),
                            DSNavigationViewController(rootViewController: history),
                            DSNavigationViewController(rootViewController: aboutUs),
                            DSNavigationViewController(rootViewController: contacts)], animated: true)
    }
    
//    func requestPermission() {
//        ATTrackingManager.requestTrackingAuthorization { status in
//            switch status {
//            case .authorized:
//                // Tracking authorization dialog was shown
//                // and we are authorized
//                print("Authorized")
//
//                // Now that we are authorized we can get the IDFA
//            print(ASIdentifierManager.shared().advertisingIdentifier)
//            case .denied:
//               // Tracking authorization dialog was
//               // shown and permission is denied
//                 print("Denied")
//            case .notDetermined:
//                    // Tracking authorization dialog has not been shown
//                    print("Not Determined")
//            case .restricted:
//                    print("Restricted")
//            @unknown default:
//                    print("Unknown")
//            }
//        }
//    }
    
    
    func gotoItemOneDetailVC() {
           self.push(DSNavigationViewController(rootViewController: contacts))
       }
       
       func gotoItemSecondDetailVC() {
           self.push(DSNavigationViewController(rootViewController: aboutUs))
       }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
