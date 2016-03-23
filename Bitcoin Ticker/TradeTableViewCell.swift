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
    private let timeLabel = LiveLabel()
    private let btcAmountLabel = UILabel()
    private let usdAmountLabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        self.contentView.addSubview(self.titleLabel)
        
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.timeLabel)
        
        self.btcAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.btcAmountLabel)
        
        self.usdAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.usdAmountLabel)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1, constant: UI.current.tradeCellHPadding))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: UI.current.tradeCellVPadding))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.btcAmountLabel, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1, constant: -UI.current.tradeCellHPadding))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.btcAmountLabel, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: UI.current.tradeCellVPadding))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1, constant: UI.current.tradeCellHPadding))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Top, relatedBy: .Equal, toItem: self.titleLabel, attribute: .Bottom, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.timeLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -UI.current.tradeCellVPadding))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.usdAmountLabel, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1, constant: -UI.current.tradeCellHPadding))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.usdAmountLabel, attribute: .Top, relatedBy: .Equal, toItem: self.btcAmountLabel, attribute: .Bottom, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.usdAmountLabel, attribute: .Bottom, relatedBy: .LessThanOrEqual, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -UI.current.tradeCellVPadding))
        
        self.updateStyle()
        Dispatcher.on(Dispatcher.Event.StyleUpdated) {
            self.updateStyle()
        }
    }
    
    func updateStyle() {
        self.backgroundColor = UI.current.appBackgroundColor
        self.titleLabel.textColor = UI.current.tradeCellColor
        self.titleLabel.font = UI.current.tradeCellFont
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeLabel.textColor = UI.current.tradeCellSubtitleColor
        self.timeLabel.font = UI.current.tradeCellSmallFont
        self.btcAmountLabel.textColor = UI.current.tradeCellColor
        self.btcAmountLabel.font = UI.current.tradeCellFont
        self.usdAmountLabel.textColor = UI.current.tradeCellSubtitleColor
        self.usdAmountLabel.font = UI.current.tradeCellSmallFont
    }
    
    func setTrade(trade: Trade) {
        self.trade = trade
        let verb = trade.type == Trade.TradeType.Buy ? "Buy" : trade.type == Trade.TradeType.Sell ? "Sell" : "?"
        let price = "\(trade.price.usdValue)"
        let sign = trade.type == Trade.TradeType.Buy ? "+" : "-"
        var usdAmount = trade.amount.decimalNumberByMultiplyingBy(trade.price)
        if usdAmount.compare(0.01) == .OrderedAscending {
            usdAmount = NSDecimalNumber(string: "0.01")
        }
        
        self.titleLabel.text = "\(verb) at \(price)"
        self.timeLabel.date = trade.date
        self.btcAmountLabel.text = sign + trade.amount.btcValue
        self.usdAmountLabel.text = usdAmount.usdValue
    }

}
