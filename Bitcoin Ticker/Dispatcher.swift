//
//  Dispatcher.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/1/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import Foundation
import UIKit

class Dispatcher: NSObject {

    private static let app = UIApplication.sharedApplication()
    private static let notificationCenter = NSNotificationCenter.defaultCenter()
    private static let debug = true // If true, logs every events
    
    // List all events supported by the dispatcher
    enum Event: String {
        case DeviceTokenReceived = "DeviceTokenReceived"
        case DeviceTokenFailure = "DeviceTokenFailure"
    }
    
    
    // Utils
    // -----
    
    // Trigger an event with a payload
    static func trigger(event: Event, payload: AnyObject?) {
        if debug {
            if let payload = payload {
                NSLog("\(event.rawValue)(\(payload))")
            } else {
                NSLog("\(event.rawValue)()")
            }
        }
        Dispatcher.notificationCenter.postNotificationName(event.rawValue, object: payload)
    }
    
    // Wait for an event to be dispatched (once and only once)
    static func waitFor(event: Event, completion: (event: Event, notification: NSNotification) -> Void) {
        Dispatcher.waitFor([event], completion: completion)
    }
    // Wait for one of the events to be dispatched (once and only once)
    static func waitFor(events: [Event], completion: (event: Event, notification: NSNotification) -> Void) {
        var observers = [NSObjectProtocol]()
        for event in events {
            observers.append(Dispatcher.notificationCenter.addObserverForName(event.rawValue, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification: NSNotification) -> Void in
                for observer in observers {
                    Dispatcher.notificationCenter.removeObserver(observer)
                }
                if let event = Dispatcher.Event(rawValue: notification.name) {
                    completion(event: event, notification: notification)
                }
            }))
        }
    }
    

    // Actions
    // -------
    
    static func setPriceOnAppIconSetting(priceOnAppIcon: Bool, completion: (priceOnAppIcon: Bool?, error: NSError?) -> Void) -> Void {
        // Turning setting on
        if priceOnAppIcon {
            // Wait to receive the device token (or failure)
            Dispatcher.waitFor([Dispatcher.Event.DeviceTokenFailure, Dispatcher.Event.DeviceTokenReceived], completion: { (event: Event, notification: NSNotification) -> Void in
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
                                completion(priceOnAppIcon: true, error: nil)
                            }
                        })
                    } else {
                        completion(priceOnAppIcon: nil, error: error("Unexpected device token \(notification.object)"))
                    }
                }
            })
            // Register for push notifications
            Dispatcher.app.registerForRemoteNotifications()
            Dispatcher.app.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge], categories: Set()))
        }
        // Turning setting off
        else {
            if Config.deviceToken != nil {
                Server.unsubscribe({ (error) -> Void in
                    if let error = error {
                        completion(priceOnAppIcon: nil, error: error)
                    } else {
                        completion(priceOnAppIcon: false, error: nil)
                    }
                })
            } else {
                completion(priceOnAppIcon: false, error: nil)
            }
        }
    }
    
    
    static private func error(message: String) -> NSError {
        return NSError(domain: "Dispatcher", code: 1, userInfo: [
            NSLocalizedDescriptionKey: message
        ])
    }
    
}
