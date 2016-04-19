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
    
    func onSwitchChange(sender: AnyObject) {
        Config.touchIdProtection = !Config.touchIdProtection
        TradePageViewController.locked = Config.touchIdProtection
    }

}
