//
//  AppDelegate.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 2/29/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import SVProgressHUD
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var application: UIApplication?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.application = application
        Fabric.with([Crashlytics.self])
        self.window = UIWindow.init(frame: UIScreen.mainScreen().bounds)
        self.updateStyle()
        Dispatcher.on(Dispatcher.Event.StyleUpdated) {
            self.updateStyle()
        }
        if let window = self.window {
            window.rootViewController = RootViewController()
            window.makeKeyAndVisible()
        }
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Black)
        BitcoinPriceService.start()
        return true
    }
    
    func updateStyle() {
        if let application = self.application {
            application.setStatusBarStyle(UI.current.statusBarStyle, animated: false)
        }
        if let window = self.window {
            window.backgroundColor = UI.current.appBackgroundColor
        }
    }

    // Callback from the system to get the push notification device token
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(deviceToken.bytes), count: deviceToken.length)
        let hexBytes = bytes.map { String(format: "%02hhx", $0) }
        let deviceTokenString = hexBytes.joinWithSeparator("")
        Dispatcher.trigger(Dispatcher.Event.DeviceTokenReceived, payload: deviceTokenString)
    }

    // Callback from the system when getting the push notification device token failed
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        Dispatcher.trigger(Dispatcher.Event.DeviceTokenFailure, payload: error)
    }
    
    // Called when a push notification is received while the app is running
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if let info = userInfo["aps"] as? NSDictionary {
            if let badge = info["badge"] as? Int {
                UIApplication.sharedApplication().applicationIconBadgeNumber = badge
            }
        }
    }

}
