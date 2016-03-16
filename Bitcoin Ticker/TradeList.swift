//
//  TradeList.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/16/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class TradeList: NSObject {

    private static var _loaded: Bool = false
    private static var _tradesDataFile = "trades-data"
    private static var _trades: [Trade]!
    
    
    // Public API
    static var trades: [Trade] {
        get {
            loadIfNeeded()
            return _trades
        }
        set(newTrades) {
            _trades = newTrades
            Dispatcher.trigger(Dispatcher.Event.TradesUpdated, payload: nil)
            syncToDisk()
        }
    }
    
    static func add(trade: Trade) {
        var newTrades = self._trades
        newTrades.append(trade)
        newTrades.sortInPlace { (t1, t2) -> Bool in
            t1.date.compare(t2.date) == NSComparisonResult.OrderedDescending
        }
        TradeList.trades = newTrades
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
        let path = (paths[0] as NSString).stringByAppendingPathComponent(_tradesDataFile)
        return path
    }
    private static func loadFromDisk() {
        _loaded = true
        
        // Try to build the file path
        guard let path = getPersistenceFile() else {
            self._trades = [Trade]()
            return
        }
        // Try to read the price data
        guard let data = NSData(contentsOfFile: path) else {
            self._trades = [Trade]()
            return
        }
        // Try to parse the price data
        guard let trades = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Trade] else {
            self._trades = [Trade]()
            return
        }
        
        self._trades = trades
    }
    private static func syncToDisk() {
        // Try to build the file path
        guard let path = getPersistenceFile() else {
            return
        }
        // Write the price data
        let data = NSKeyedArchiver.archivedDataWithRootObject(_trades)
        data.writeToFile(path, atomically: true)
    }
    
}