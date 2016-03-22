//
//  BitcoinPrice.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class PriceData: NSObject, NSCoding {
    let bid: NSDecimalNumber
    let mid: NSDecimalNumber
    let ask: NSDecimalNumber
    let last: NSDecimalNumber
    let low: NSDecimalNumber // last 24h low
    let high: NSDecimalNumber // last 24h high
    let volume: NSDecimalNumber // last 24h volume
    let timestamp: NSTimeInterval
    let creationDate: NSDate
    override init() {
        self.bid = 0
        self.mid = 0
        self.ask = 0
        self.last = 0
        self.low = 0
        self.high = 0
        self.volume = 0
        self.timestamp = 0
        self.creationDate = NSDate(timeIntervalSinceNow: 0)
    }
    init(dictionary: NSDictionary) {
        self.bid = NSDecimalNumber(string: (dictionary["bid"] as? String) ?? "0") ?? 0
        self.mid = NSDecimalNumber(string: (dictionary["mid"] as? String) ?? "0") ?? 0
        self.ask = NSDecimalNumber(string: (dictionary["ask"] as? String) ?? "0") ?? 0
        self.last = NSDecimalNumber(string: (dictionary["last_price"] as? String) ?? "0") ?? 0
        self.low = NSDecimalNumber(string: (dictionary["low"] as? String) ?? "0") ?? 0
        self.high = NSDecimalNumber(string: (dictionary["high"] as? String) ?? "0") ?? 0
        self.volume = NSDecimalNumber(string: (dictionary["volume"] as? String) ?? "0") ?? 0
        self.timestamp = Double((dictionary["timestamp"] as? String) ?? "0") ?? 0
        self.creationDate = NSDate(timeIntervalSinceNow: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        self.bid = (aDecoder.decodeObjectForKey("bid") as? NSDecimalNumber) ?? 0
        self.mid = (aDecoder.decodeObjectForKey("mid") as? NSDecimalNumber) ?? 0
        self.ask = (aDecoder.decodeObjectForKey("ask") as? NSDecimalNumber) ?? 0
        self.last = (aDecoder.decodeObjectForKey("last") as? NSDecimalNumber) ?? 0
        self.low = (aDecoder.decodeObjectForKey("low") as? NSDecimalNumber) ?? 0
        self.high = (aDecoder.decodeObjectForKey("high") as? NSDecimalNumber) ?? 0
        self.volume = (aDecoder.decodeObjectForKey("volume") as? NSDecimalNumber) ?? 0
        self.timestamp = aDecoder.decodeDoubleForKey("timestamp")
        self.creationDate = (aDecoder.decodeObjectForKey("creationDate") as? NSDate) ?? NSDate(timeIntervalSinceNow: 0)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.bid, forKey: "bid")
        aCoder.encodeObject(self.mid, forKey: "mid")
        aCoder.encodeObject(self.ask, forKey: "ask")
        aCoder.encodeObject(self.last, forKey: "last")
        aCoder.encodeObject(self.low, forKey: "low")
        aCoder.encodeObject(self.high, forKey: "high")
        aCoder.encodeObject(self.volume, forKey: "volume")
        aCoder.encodeDouble(self.timestamp, forKey: "timestamp")
        aCoder.encodeObject(self.creationDate, forKey: "creationDate")
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
            "\n\ttimestamp: \(self.timestamp)" +
            "\n\tcreationDate: \(self.creationDate)"
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
