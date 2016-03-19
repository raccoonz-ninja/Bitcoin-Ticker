//
//  NSDecimalNumberExtension.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/13/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

extension NSDecimalNumber {

    private static var btcFormatter = NSNumberFormatter()
    
    var btcValue: String {
        get {
            let btcFormatter = NSNumberFormatter()
            btcFormatter.minimumIntegerDigits = 1
            btcFormatter.maximumFractionDigits = 8
            btcFormatter.minimumFractionDigits = 0
            return "\(self.btcValueWithoutSymbol) BTC"
        }
    }
    
    var btcValueWithoutSymbol: String {
        get {
            let btcFormatter = NSNumberFormatter()
            btcFormatter.minimumIntegerDigits = 1
            btcFormatter.maximumFractionDigits = 8
            btcFormatter.minimumFractionDigits = 0
            return btcFormatter.stringFromNumber(self) ?? "0"
        }
    }
    
    var usdValue: String {
        get {
            let usdFormatter = NSNumberFormatter()
            usdFormatter.minimumIntegerDigits = 1
            usdFormatter.maximumFractionDigits = 2
            usdFormatter.minimumFractionDigits = 2
            usdFormatter.usesGroupingSeparator = true
            return "$\(usdFormatter.stringFromNumber(self) ?? "0")"
        }
    }
    
    var positive: Bool {
        get {
            return self.compare(NSDecimalNumber.zero()) != NSComparisonResult.OrderedAscending
        }
    }
    
    var strictPositive: Bool {
        get {
            return self.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedDescending
        }
    }
    
    var negative: Bool {
        get {
            return self.compare(NSDecimalNumber.zero()) == NSComparisonResult.OrderedAscending
        }
    }
    
}