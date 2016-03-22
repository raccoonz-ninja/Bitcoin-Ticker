//
//  TradePageViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import LocalAuthentication

class TradePageViewController: UIViewController {

    private var tradeTableViewController = TradeTableViewController()
    private var addButton = UILabel()
    private var lockScreen = UIView()
    static var locked = Config.touchIdProtection
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tradeTableViewController.tradePageViewController = self
        let view = self.tradeTableViewController.view
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        
        self.addButton.text = "  +  "
        self.addButton.textColor = UIConfig.tradeAddButtonColor
        self.addButton.font = UIConfig.tradeAddButtonFontSize
        self.addButton.userInteractionEnabled = true
        self.addButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onAddButtonTap"))
        self.addButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.addButton)
        
        self.lockScreen.backgroundColor = UIConfig.appBackgroundColor
        self.lockScreen.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lockScreen)
        
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: UIConfig.tradeTableVOffset))
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.addButton, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: -7))
        self.view.addConstraint(NSLayoutConstraint(item: self.addButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 25))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.lockScreen, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.lockScreen, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.lockScreen, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.lockScreen, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        
        self.view.bringSubviewToFront(self.lockScreen)
        self.setLocked(TradePageViewController.locked)
    }
    
    func isShown() {
        setLocked(TradePageViewController.locked)
        if TradePageViewController.locked {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
                context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Access to your trades", reply: { (success: Bool, error: NSError?) -> Void in
                    if error != nil {
                        self.setLocked(true)
                    } else {
                        self.setLocked(false)
                    }
                })
            }
        }
    }
    
    func setLocked(locked: Bool) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            TradePageViewController.locked = locked
            if TradePageViewController.locked {
                self.lockScreen.layer.opacity = 1
            } else {
                UIView.animateWithDuration(UIConfig.lockScreenFadeOutDuration, animations: { () -> Void in
                    self.lockScreen.layer.opacity = 0
                })
            }
        }
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
