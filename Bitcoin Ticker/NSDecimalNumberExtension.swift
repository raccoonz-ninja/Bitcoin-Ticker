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
            btcFormatter.maximumFractionDigits = 8
            btcFormatter.minimumFractionDigits = 0
            return btcFormatter.stringFromNumber(self) ?? "0"
        }
    }
    
    var usdValue: String {
        get {
            let usdFormatter = NSNumberFormatter()
            usdFormatter.maximumFractionDigits = 2
            usdFormatter.minimumFractionDigits = 2
            return usdFormatter.stringFromNumber(self) ?? "0"
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