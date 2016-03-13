//
//  TradeTableViewCell.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class TradeTableViewCell: UITableViewCell {

    private var trade: Trade!
    
    private let titleLabel = UILabel()
    private let timeLabel = UILabel()
    private let btcAmountLabel = UILabel()
    private let usdAmountLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIConfig.appBackgroundColor
        self.selectionStyle = .None
        
        self.titleLabel.textColor = UIConfig.appTextColor
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        
        self.timeLabel.textColor = UIConfig.appTextColor
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.timeLabel)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1, constant: UIConfig.tradeCellPadding))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: UIConfig.tradeCellPadding))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1, constant: UIConfig.tradeCellPadding))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Top, relatedBy: .Equal, toItem: self.titleLabel, attribute: .Bottom, multiplier: 1, constant: 5))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -UIConfig.tradeCellPadding))
    }
    
    func setTrade(trade: Trade) {
        self.trade = trade
        let verb = trade.type == Trade.TradeType.Buy ? "Buy" : trade.type == Trade.TradeType.Sell ? "Sell" : "?"
        let price = "$\(trade.price.usdValue)"

        self.titleLabel.text = "\(verb) at \(price)"
        print(trade.amount.btcValue)
        self.timeLabel.text = trade.date.fromNow()
    }

}
