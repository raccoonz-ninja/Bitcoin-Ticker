//
//  MainPageViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    private let currentPriceLabel = UILabel()
    private let lastUpdateLabel = LiveLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPriceLabel.text = ""
        self.currentPriceLabel.font = UIConfig.currentPriceFont
        self.currentPriceLabel.textColor = UIConfig.currentPriceColor
        self.currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.currentPriceLabel)
        
        self.lastUpdateLabel.template = ""
        self.lastUpdateLabel.font = UIConfig.lastUpdateFont
        self.lastUpdateLabel.textColor = UIConfig.lastUpdateColor
        self.lastUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lastUpdateLabel)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.lastUpdateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.lastUpdateLabel, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))

        self.updatePrice()
        Dispatcher.on(Dispatcher.Event.NewPriceFetched) { () -> Void in
            self.updatePrice()
        }
    }
    
    func updatePrice() {
        dispatch_async(dispatch_get_main_queue()) {
            let last = BitcoinPrice.last
            self.currentPriceLabel.text = last.last.strictPositive ? last.last.usdValue : ""
            self.lastUpdateLabel.date = last.creationDate
            self.lastUpdateLabel.template = "Updated %time%"
        }
    }

}
