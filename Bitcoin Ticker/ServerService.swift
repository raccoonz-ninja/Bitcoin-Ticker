//
//  ServerService.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/1/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import AFNetworking

class ServerService: NSObject {
    
    private static let _baseUrl = NSURL(string: "http://172.20.10.5:5567")
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
    
    static func subscribe(completion: (error: NSError?) -> Void) {
        let params: NSDictionary = ["deviceToken": Config.deviceToken ?? "", "provider": "bitfinex"]
        client.POST("/subscribe", parameters: params, success: { (req: AFHTTPRequestOperation, res: AnyObject) -> Void in
            completion(error: nil)
        }) { (req: AFHTTPRequestOperation?, error: NSError) -> Void in
            completion(error: error)
        }
    }
    
    static func unsubscribe(completion: (error: NSError?) -> Void) {
        let params: NSDictionary = ["deviceToken": Config.deviceToken ?? ""]
        client.POST("/unsubscribe", parameters: params, success: { (req: AFHTTPRequestOperation, res: AnyObject) -> Void in
            completion(error: nil)
        }) { (req: AFHTTPRequestOperation?, error: NSError) -> Void in
            completion(error: error)
        }
    }
    
}
