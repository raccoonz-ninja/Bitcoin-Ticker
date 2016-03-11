//
//  Trade.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class Trade: NSObject {
    enum Type {
        case Buy
        case Sell
    }

    var type: Type
    var amount: Float
    var price: Float
    var date: NSDate
    var creationDate: NSDate
    var updateDate: NSDate?

    init(type: Type, amount: Float, price: Float, date: NSDate) {
        self.type = type
        self.amount = amount
        self.price = price
        self.date = date
        self.creationDate = NSDate()
        self.updateDate = nil
    }
}
