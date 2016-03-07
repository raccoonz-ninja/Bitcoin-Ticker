//
//  BitcoinPrice.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class PriceData: NSObject, NSCoding {
    let bid: Float
    let mid: Float
    let ask: Float
    let last: Float
    let low: Float // last 24h low
    let high: Float // last 24h high
    let volume: Float // last 24h volume
    let timestamp: NSTimeInterval
    override init() {
        self.bid = 0
        self.mid = 0
        self.ask = 0
        self.last = 0
        self.low = 0
        self.high = 0
        self.volume = 0
        self.timestamp = 0
    }
    init(dictionary: NSDictionary) {
        self.bid = Float((dictionary["bid"] as? String) ?? "0") ?? 0
        self.mid = Float((dictionary["mid"] as? String) ?? "0") ?? 0
        self.ask = Float((dictionary["ask"] as? String) ?? "0") ?? 0
        self.last = Float((dictionary["last_price"] as? String) ?? "0") ?? 0
        self.low = Float((dictionary["low"] as? String) ?? "0") ?? 0
        self.high = Float((dictionary["high"] as? String) ?? "0") ?? 0
        self.volume = Float((dictionary["volume"] as? String) ?? "0") ?? 0
        self.timestamp = Double((dictionary["timestamp"] as? String) ?? "0") ?? 0
    }
    required init?(coder aDecoder: NSCoder) {
        self.bid = aDecoder.decodeFloatForKey("bid")
        self.mid = aDecoder.decodeFloatForKey("mid")
        self.ask = aDecoder.decodeFloatForKey("ask")
        self.last = aDecoder.decodeFloatForKey("last")
        self.low = aDecoder.decodeFloatForKey("low")
        self.high = aDecoder.decodeFloatForKey("high")
        self.volume = aDecoder.decodeFloatForKey("volume")
        self.timestamp = aDecoder.decodeDoubleForKey("timestamp")
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeFloat(self.bid, forKey: "bid")
        aCoder.encodeFloat(self.mid, forKey: "mid")
        aCoder.encodeFloat(self.ask, forKey: "ask")
        aCoder.encodeFloat(self.last, forKey: "last")
        aCoder.encodeFloat(self.low, forKey: "low")
        aCoder.encodeFloat(self.high, forKey: "high")
        aCoder.encodeFloat(self.volume, forKey: "volume")
        aCoder.encodeDouble(self.timestamp, forKey: "timestamp")
    }
    override var description: String {
        return "BitcoinPrice:" +
            "\n\tbid: \(self.bid)" +
            "\n\tmid: \(self.mid)" +
            "\n\task: \(self.ask)" +
            "\n\tlast: \(self.last)" +
            "\n\tlow: \(self.low)" +
            "\n\thigh: \(self.high)" +
            "\n\tvolume: \(self.volume)" +
            "\n\ttimestamp: \(self.timestamp)"
    }
}

class BitcoinPrice: NSObject {
    
    private static var _loaded: Bool = false
    private static var _priceDataFile = "price-data"
    private static var _priceData: PriceData!
    
    
    // Public API
    static var last: PriceData {
        get {
            loadIfNeeded()
            return _priceData
        }
        set(newPrice) {
            _priceData = newPrice
            syncToDisk()
        }
    }
    
    
    // Private utilities
    private static func loadIfNeeded() {
        if !_loaded {
            loadFromDisk()
        }
    }
    private static func getPersistenceFile() -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        if paths.isEmpty {
            return nil
        }
        let path = (paths[0] as NSString).stringByAppendingPathComponent(_priceDataFile)
        return path
    }
    private static func loadFromDisk() {
        _loaded = true

        // Try to build the file path
        guard let path = getPersistenceFile() else {
            self._priceData = PriceData()
            return
        }
        // Try to read the price data
        guard let data = NSData(contentsOfFile: path) else {
            self._priceData = PriceData()
            return
        }
        // Try to parse the price data
        guard let priceData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? PriceData else {
            self._priceData = PriceData()
            return
        }
        
        self._priceData = priceData
    }
    private static func syncToDisk() {
        // Try to build the file path
        guard let path = getPersistenceFile() else {
            return
        }
        // Write the price data
        let data = NSKeyedArchiver.archivedDataWithRootObject(_priceData)
        data.writeToFile(path, atomically: true)
    }
    
    
}
