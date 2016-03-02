//
//  AppDelegate.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 2/29/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        print("Register")
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge], categories: Set()))
        print("Wait for callback")
        return true
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Registered")
        let bytes = UnsafeBufferPointer<UInt8>(start: UnsafePointer(deviceToken.bytes), count: deviceToken.length)
        let hexBytes = bytes.map { String(format: "%02hhx", $0) }
        let deviceTokenString = hexBytes.joinWithSeparator("")
        print(deviceTokenString)
    }

    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Not registered")
        print(error)
    }

}
