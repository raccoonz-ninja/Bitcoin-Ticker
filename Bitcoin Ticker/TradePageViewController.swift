//
//  TradePageViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class TradePageViewController: UIViewController {

    private var tradeTableViewController = TradeTableViewController()
    private var addButton = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tradeTableViewController.tradePageViewController = self
        let view = self.tradeTableViewController.view
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        self.addButton.text = "  +  "
        self.addButton.textColor = UIConfig.tradeAddButtonColor
        self.addButton.font = UIConfig.tradeAddButtonFontSize
        self.addButton.layer.borderColor = Color.primaryColorLight.CGColor
        self.addButton.layer.borderWidth = 1
        self.addButton.userInteractionEnabled = true
        self.addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onAddButtonTap"))
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.addButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 50))
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.addButton, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: -UIConfig.tradeCellHPadding))
        self.view.addConstraint(NSLayoutConstraint(item: self.addButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: UIConfig.tradeCellHPadding))
    }
    
    func disableInteraction(view: UIView) {
        view.userInteractionEnabled = false
        for v in view.subviews {
            disableInteraction(v)
        }
    }
    
    func onAddButtonTap() {
        self.presentViewController(TradeFormViewController(), animated: true) {
            
        }
    }

}
