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

    private static let notificationCenter = NSNotificationCenter.defaultCenter()
    private static let debug = false // If true, logs every events
    
    // List all events supported by the dispatcher
    enum Event: String {
        case DeviceTokenReceived = "DeviceTokenReceived"
        case DeviceTokenFailure = "DeviceTokenFailure"
        case NewPriceReceived = "NewPriceReceived"
        case TradesUpdated = "TradesUpdated"
    }
    
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
    static func on(event: Event, completion: () -> Void) {
        Dispatcher.notificationCenter.addObserverForName(event.rawValue, object: nil, queue: NSOperationQueue.mainQueue()) { _ in
            completion()
        }
    }
    
}
