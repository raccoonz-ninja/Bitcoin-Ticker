//
//  Trade.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import Foundation

class Trade: NSObject {
    enum TradeType {
        case Buy
        case Sell
    }

    var type: TradeType
    var amount: NSDecimalNumber
    var price: NSDecimalNumber
    var date: NSDate
    var creationDate: NSDate
    var updateDate: NSDate?

    init(type: TradeType, amount: NSDecimalNumber, price: NSDecimalNumber, date: NSDate) {
        self.type = type
        self.amount = amount
        self.price = price
        self.date = date
        self.creationDate = NSDate()
        self.updateDate = nil
    }
}
