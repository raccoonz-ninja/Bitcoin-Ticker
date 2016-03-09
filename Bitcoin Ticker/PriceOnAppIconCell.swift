//
//  PriceOnAppIconCell.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/7/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import SVProgressHUD

class PriceOnAppIconCell: UITableViewCell {
    
    private let switchView = UISwitch()
    private let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIConfig.appBackgroundColor
        self.selectionStyle = .None

        self.textLabel?.text = "Price on app icon"
        self.textLabel?.textColor = UIConfig.appTextColor
        
        self.switchView.tintColor = UIConfig.switchColor
        self.switchView.onTintColor = UIConfig.switchColor
        self.switchView.on = Config.priceOnAppIcon
        self.switchView.addTarget(self, action: "onSwitchChange:", forControlEvents: .ValueChanged)
        self.accessoryView = switchView
    }
    
    func onSwitchChange(sender: AnyObject) {
        self.activityIndicatorView.startAnimating()
        self.accessoryView = self.activityIndicatorView
        NotificationService.setPriceOnAppIconSetting(self.switchView.on) { (priceOnAppIcon, error) -> Void in
            if let error = error {
                self.switchView.on = !self.switchView.on // Revert on failure
                let verb = self.switchView.on ? "enable" : "disable"
                SVProgressHUD.showErrorWithStatus("Couldn't \(verb) setting. Internet problem?")
                NSLog("\(error.debugDescription)")
            }
            self.activityIndicatorView.stopAnimating()
            self.accessoryView = self.switchView
        }
    }

}
