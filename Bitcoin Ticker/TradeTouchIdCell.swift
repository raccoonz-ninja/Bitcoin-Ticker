//
//  TradeTouchIdCell.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/21/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import SVProgressHUD
import LocalAuthentication

class TradeTouchIdCell: UITableViewCell {
    
    private let switchView = UISwitch()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        self.textLabel?.text = "Touch ID protection"
        
        self.switchView.on = Config.touchIdProtection
        self.switchView.addTarget(self, action: #selector(TradeTouchIdCell.onSwitchChange(_:)), forControlEvents: .ValueChanged)
        self.accessoryView = switchView
        
        self.updateStyle()
        Dispatcher.on(Dispatcher.Event.StyleUpdated) {
            self.updateStyle()
        }
    }
    
    func updateStyle() {
        self.backgroundColor = UI.current.appBackgroundColor
        self.textLabel?.textColor = UI.current.appTextColor
        self.switchView.tintColor = UI.current.switchColor
        self.switchView.onTintColor = UI.current.switchColor
    }
    
    func onSwitchChangeError(error: String) {
        dispatch_async(dispatch_get_main_queue()) {
            // Display an error message
            SVProgressHUD.showErrorWithStatus(error)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                // Revert the switch value
                self.switchView.setOn(!self.switchView.on, animated: true)
                // Dismiss error message
                SVProgressHUD.dismiss()
            })
        }
    }

    func onSwitchChange(sender: AnyObject) {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let verb = self.switchView.on ? "Enable" : "Disable"
            let message = "\(verb) Touch ID protection"
            context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: message, reply: { (success: Bool, error: NSError?) -> Void in
                if error != nil {
                    self.onSwitchChangeError("Authentication required to update this setting.")
                } else {
                    Config.touchIdProtection = !Config.touchIdProtection
                    TradePageViewController.locked = Config.touchIdProtection
                }
            })
        } else {
            self.onSwitchChangeError("Touch ID not enable on this device.")
        }
    }

}
