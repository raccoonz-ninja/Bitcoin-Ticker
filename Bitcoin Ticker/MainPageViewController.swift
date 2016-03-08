//
//  MainPageViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class MainPageViewController: UIViewController {

    private var currentPriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPriceLabel = UILabel()
        self.currentPriceLabel.text = ""
        self.currentPriceLabel.font = UIConfig.currentPriceFont
        self.currentPriceLabel.textColor = UIColor(white: 1, alpha: 0.5)
        self.currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.currentPriceLabel)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))

        self.updatePrice()
        Dispatcher.on(Dispatcher.Event.NewPriceReceived) { () -> Void in
            self.updatePrice()
        }
    }
    
    func updatePrice() {
        let last = BitcoinPrice.last.last
        self.currentPriceLabel.text = last > 0 ? "$\(last)" : ""
    }

}
