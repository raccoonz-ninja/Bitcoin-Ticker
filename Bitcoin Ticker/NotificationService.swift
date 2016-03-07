//
//  NotificationService.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class NotificationService: NSObject {
    
    private static let app = UIApplication.sharedApplication()
    
    static func setPriceOnAppIconSetting(priceOnAppIcon: Bool, completion: (priceOnAppIcon: Bool?, error: NSError?) -> Void) -> Void {
        // Turning setting on
        if priceOnAppIcon {
            // Wait to receive the device token (or failure)
            Dispatcher.waitFor([Dispatcher.Event.DeviceTokenFailure, Dispatcher.Event.DeviceTokenReceived], completion: { (event: Dispatcher.Event, notification: NSNotification) -> Void in
                if event == Dispatcher.Event.DeviceTokenFailure {
                    completion(priceOnAppIcon: nil, error: notification.object as? NSError)
                }
                else if event == Dispatcher.Event.DeviceTokenReceived {
                    if let token = notification.object as? String {
                        Config.deviceToken = token
                        Server.subscribe({ (error) -> Void in
                            if let error = error {
                                completion(priceOnAppIcon: nil, error: error)
                            } else {
                                Config.priceOnAppIcon = true
                                completion(priceOnAppIcon: true, error: nil)
                            }
                        })
                    } else {
                        completion(priceOnAppIcon: nil, error: NSError.error("NotificationService", message: "Unexpected device token \(notification.object)"))
                    }
                }
            })
            // Register for push notifications
            NotificationService.app.registerForRemoteNotifications()
            NotificationService.app.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge], categories: Set()))
        }
            // Turning setting off
        else {
            if Config.deviceToken != nil {
                Server.unsubscribe({ (error) -> Void in
                    if let error = error {
                        completion(priceOnAppIcon: nil, error: error)
                    } else {
                        Config.priceOnAppIcon = false
                        completion(priceOnAppIcon: false, error: nil)
                    }
                })
            } else {
                Config.priceOnAppIcon = false
                completion(priceOnAppIcon: false, error: nil)
            }
        }
    }

}
