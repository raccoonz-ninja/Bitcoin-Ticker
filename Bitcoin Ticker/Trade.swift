//
//  Trade.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import Foundation

class Trade: NSObject, NSCoding {
    enum TradeType: String {
        case Buy = "Buy"
        case Sell = "Sell"
    }

    var id: Int
    var type: TradeType
    var amount: NSDecimalNumber
    var price: NSDecimalNumber
    var date: NSDate
    var creationDate: NSDate
    var updateDate: NSDate?

    init(type: TradeType, amount: NSDecimalNumber, price: NSDecimalNumber, date: NSDate) {
        self.id = random()
        self.type = type
        self.amount = amount
        self.price = price
        self.date = date
        self.creationDate = NSDate()
        self.updateDate = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        let now = NSDate(timeIntervalSinceNow: 0)
        self.id = aDecoder.decodeIntegerForKey("id")
        self.type = TradeType(rawValue: (aDecoder.decodeObjectForKey("type") as? String) ?? "Buy") ?? TradeType.Buy
        self.amount = (aDecoder.decodeObjectForKey("amount") as? NSDecimalNumber) ?? 0
        self.price = (aDecoder.decodeObjectForKey("price") as? NSDecimalNumber) ?? 0
        self.date = (aDecoder.decodeObjectForKey("date") as? NSDate) ?? now
        self.creationDate = (aDecoder.decodeObjectForKey("creationDate") as? NSDate) ?? now
        self.updateDate = (aDecoder.decodeObjectForKey("updateDate") as? NSDate) ?? now
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(self.id, forKey: "id")
        aCoder.encodeObject(self.type.rawValue, forKey: "type")
        aCoder.encodeObject(self.amount, forKey: "amount")
        aCoder.encodeObject(self.price, forKey: "price")
        aCoder.encodeObject(self.date, forKey: "date")
        aCoder.encodeObject(self.creationDate, forKey: "creationDate")
        aCoder.encodeObject(self.updateDate, forKey: "updateDate")
    }
}
