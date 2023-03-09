//
//  StoreViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 28.01.2021.
//

import UIKit
import DSKit
import DSKitFakery
import BranchSDK
import AppTrackingTransparency
import AdSupport

open class ContactsViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    let buo = BranchUniversalObject()
    let lp = BranchLinkProperties()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contacts"
        show(content: [getContactsSection()])
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: - Contacts
extension ContactsViewController {
    
    /// Contacts section
    /// - Returns: DSSection
    func getContactsSection() -> DSSection {
        
        let phone = textRow(title: "Phone: ", details: faker.phoneNumber, icon: "phone.fill")
        let address = textRow(title: "Address: ", details: faker.streetAddress, icon: "map.fill")
        let workingHours = textRow(title: "Working Hours: ", details: "Open ⋅ Closes 5PM", icon: "calendar.badge.clock")
        let health = textRow(title: "Health and safety: ", details: "Mask required · Temperature check required · Staff wear masks · Staff get temperature checks", icon: "info.circle.fill")
        let map = DSMapVM(coordinate: faker.address.coordinate)
        let button = DSButtonVM(title: "Get directions", icon: UIImage(systemName: "map.fill"))

        //Toggle User Tracking
        let userTracking = DSButtonVM(title: "Toggle User Tracking") { (tap) in
            switch Branch.trackingDisabled() {
            case false:
                Branch.setTrackingDisabled(true)
                print("Tracking Disabled")
            case true:
                Branch.setTrackingDisabled(false)
                print("Tracking Enabled")
            }
        }
        
        //Set BUO
        buo.canonicalIdentifier = "item/12345"
        buo.title = "Title"
        buo.contentDescription = description
        buo.imageUrl = "https://branch.io/img/logo-dark.svg"
        buo.publiclyIndex = true
        buo.locallyIndex = true
        buo.canonicalUrl = "https://help.branch.io"
        
        print (buo)
        
        //Set Link Properties
        lp.channel = "In-app"
        lp.feature = "sharing"
        lp.campaign = "Buy Flowers"
        lp.stage = "new user"
//            lp.alias = product.title
        lp.tags = [description]
        lp.addControlParam("$desktop_url", withValue: "http://example.com/desktop")
        lp.addControlParam("$ios_url", withValue: "http://example.com/ios")
        lp.addControlParam("$ipad_url", withValue: "http://example.com/ios")
        lp.addControlParam("$android_url", withValue: "http://example.com/android")
        lp.addControlParam("custom_data", withValue: "yes")
        lp.addControlParam("look_at", withValue: "this")
        lp.addControlParam("nav_to", withValue: "over here")
        
        print (lp)
        
        let qrCode = BranchQRCode()
        qrCode.codeColor = UIColor.white
        qrCode.backgroundColor = UIColor.blue
        qrCode.centerLogo = "https://cdn.branch.io/branch-assets/1598575682753-og_image.png"
        qrCode.width = 1024
        qrCode.margin = 1
        qrCode.imageFormat = .JPEG
        
    
        //Genereate QR Code Button
        let generateQRCode = DSButtonVM(title: "Generate QR Code") { (tap) in
            qrCode.showShareSheetWithQRCode(from: self, anchor: nil, universalObject: self.buo, linkProperties: self.lp) { error in
                //Showing a share sheet with the QR code
            }
        }
        
        //Create Deep Link
        let createDeepLink = DSButtonVM(title: "Create Deep Link") { (tap) in
            self.buo.getShortUrl(with: self.lp) { url, error in
                    print(url ?? "")
                }
        }
        
        let shareDeepLink = DSButtonVM(title: "Share Deep Link") { (tap) in
            let message = "Check out this link with amazing flowers"
            self.buo.showShareSheet(with: self.lp, andShareText: message, from: self) { (activityType, completed) in
                print(activityType ?? "")
            }
        }
        
        let attPrompt = DSButtonVM(title: "ATT Prompt"){ (tap) in
            
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: {
                    status in
                    if (status == .authorized) {
                        let idfa = ASIdentifierManager.shared().advertisingIdentifier
                        print("IDFA: " + idfa.uuidString)
                    } else {
                        print("Failed to get IDFA")
                    }
                })
            }
        }
        return [phone, address, workingHours, health, map, button, userTracking, generateQRCode, createDeepLink, shareDeepLink, attPrompt].list()
    }
    
    /// Text row
    /// - Parameters:
    ///   - title: String
    ///   - details: String
    ///   - icon: String
    /// - Returns: DSActionVM
    func textRow(title: String, details: String, icon: String) -> DSActionVM {
        
        let text = DSTextComposer()
        text.add(type: .headline, text: title)
        text.add(type: .subheadline, text: details, newLine: false)
        var row = DSActionVM(composer: text)
        row.leftIcon(sfSymbolName: icon, size: CGSize(width: 18, height: 18))
        row.leftViewPosition = .top
        row.style.displayStyle = .grouped(inSection: false)
        return row
    }
}
