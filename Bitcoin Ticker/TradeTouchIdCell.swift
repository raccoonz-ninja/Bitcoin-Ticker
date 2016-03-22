//
//  TradeTouchIdCell.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/21/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class TradeTouchIdCell: UITableViewCell {
    
    private let switchView = UISwitch()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIConfig.appBackgroundColor
        self.selectionStyle = .None
        
        self.textLabel?.text = "Touch ID protection"
        self.textLabel?.textColor = UIConfig.appTextColor
        
        self.switchView.tintColor = UIConfig.switchColor
        self.switchView.onTintColor = UIConfig.switchColor
        self.switchView.on = Config.touchIdProtection
        self.switchView.addTarget(self, action: "onSwitchChange:", forControlEvents: .ValueChanged)
        self.accessoryView = switchView
    }
    
    func onSwitchChange(sender: AnyObject) {
        Config.touchIdProtection = !Config.touchIdProtection
        TradePageViewController.locked = Config.touchIdProtection
    }

}
