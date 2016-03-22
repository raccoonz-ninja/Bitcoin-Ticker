//
//  MainPageViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import JTNumberScrollAnimatedView

class MainPageViewController: UIViewController {

    private var currentPriceLabel: UILabel!
    private var lastUpdateLabel: LiveLabel!
//    private var currentPriceAnimationView: JTNumberScrollAnimatedView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentPriceLabel = UILabel()
        self.currentPriceLabel.text = ""
        self.currentPriceLabel.font = UIConfig.currentPriceFont
        self.currentPriceLabel.textColor = UIConfig.currentPriceColor
        self.currentPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.currentPriceLabel)
        
        self.lastUpdateLabel = LiveLabel()
        self.lastUpdateLabel.font = UIConfig.lastUpdateFont
        self.lastUpdateLabel.textColor = UIConfig.lastUpdateColor
        self.lastUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lastUpdateLabel)
        
//        self.currentPriceAnimationView = JTNumberScrollAnimatedView()
//        self.currentPriceAnimationView.layer.borderWidth = 1
//        self.currentPriceAnimationView.layer.borderColor = UIColor.redColor().CGColor
//        self.currentPriceAnimationView.translatesAutoresizingMaskIntoConstraints = false
//        self.view.addSubview(self.currentPriceAnimationView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceLabel, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.lastUpdateLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.lastUpdateLabel, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
        
//        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceAnimationView, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceAnimationView, attribute: .Top, relatedBy: .Equal, toItem: self.lastUpdateLabel, attribute: .Bottom, multiplier: 1, constant: 0))
//        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceAnimationView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 200))
//        self.view.addConstraint(NSLayoutConstraint(item: self.currentPriceAnimationView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 200))

        self.updatePrice()
        Dispatcher.on(Dispatcher.Event.NewPriceFetched) { () -> Void in
            self.updatePrice()
        }
    }
    
    func updatePrice() {
        let last = BitcoinPrice.last
        self.currentPriceLabel.text = last.last.strictPositive ? last.last.usdValue : ""
        self.lastUpdateLabel.date = last.creationDate
//        let newValue = Int(round(last.last.floatValue)) + Int(arc4random() % 10)
//        if self.currentPriceAnimationView.value != newValue {
//            self.currentPriceAnimationView.value = newValue
//            self.currentPriceAnimationView.startAnimation()
//        }
    }

}
