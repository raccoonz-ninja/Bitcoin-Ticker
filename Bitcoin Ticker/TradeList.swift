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
            syncToDisk()
            Dispatcher.trigger(Dispatcher.Event.TradesUpdated, payload: nil)
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
    
    static func update(trade: Trade) {
        var newTrades = self._trades
        if let index = newTrades.indexOf({ (t: Trade) in
            return t.id == trade.id
        }) {
            newTrades[index] = trade
            TradeList.trades = newTrades
        }
    }
    
    static func remove(tradeId: Int) {
        var newTrades = self._trades
        if let index = newTrades.indexOf({ (t: Trade) in
            return t.id == tradeId
        }) {
            newTrades.removeAtIndex(index)
            TradeList.trades = newTrades
        }
    }
    
//    static func average() -> Trade {
//        var totalBTCBought = NSDecimalNumber.zero()
//        var totalSpentBuying = NSDecimalNumber.zero()
//        var totalBTCSold = NSDecimalNumber.zero()
//        var totalEarnedSelling = NSDecimalNumber.zero()
//        for trade in TradeList.trades {
//            if trade.type == Trade.TradeType.Buy {
//                totalBTCBought = totalBTCBought.decimalNumberByAdding(trade.amount)
//                totalSpentBuying = totalSpentBuying.decimalNumberByAdding(trade.amount.decimalNumberByMultiplyingBy(trade.price))
//            } else if trade.type == Trade.TradeType.Sell {
//                totalBTCSold = totalBTCSold.decimalNumberByAdding(trade.amount)
//                totalEarnedSelling = totalEarnedSelling.decimalNumberByAdding(trade.amount.decimalNumberByMultiplyingBy(trade.price))
//            }
//        }
//    }
    
    
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
