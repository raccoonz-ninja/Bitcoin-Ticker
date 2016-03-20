//
//  BitcoinPriceService.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/19/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

import UIKit
import AFNetworking

class BitcoinPriceService: NSObject {
    
    private static let notificationCenter = NSNotificationCenter.defaultCenter()
    private static let _baseUrl = NSURL(string: "https://api.bitfinex.com")
    
    private static var _client: AFHTTPRequestOperationManager?
    private static var client: AFHTTPRequestOperationManager {
        get {
            if let client = _client {
                return client
            } else {
                let om = AFHTTPRequestOperationManager(baseURL: _baseUrl)
                let requestSerializer = AFJSONRequestSerializer()
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                om.requestSerializer = requestSerializer
                _client = om
                return om
            }
        }
    }
    
    static func start() {
        fetchPriceOnce()
        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "fetchPriceOnce", userInfo: nil, repeats: true)
    }
    
    static func fetchPriceOnce() {
        client.GET("/v1/pubticker/BTCUSD", parameters: nil, success: { (req: AFHTTPRequestOperation, res) -> Void in
            if let dict = res as? NSDictionary {
                let last = NSDecimalNumber(string: (dict["last_price"] as? String) ?? "0") ?? 0
                BitcoinPriceService.notificationCenter.postNotificationName("price_update", object: last)
            }
        }, failure: nil)
    }
    
}
