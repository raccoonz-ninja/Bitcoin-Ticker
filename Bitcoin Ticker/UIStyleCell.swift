//
//  UIStyleCell.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/22/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class UIStyleCell: UITableViewCell {
    
    private let switchView = UISwitch()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .None
        
        self.textLabel?.text = "Light style"
        
        self.switchView.on = Config.uiType == UIConfigType.Light
        self.switchView.addTarget(self, action: "onSwitchChange:", forControlEvents: .ValueChanged)
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
        Config.uiType = self.switchView.on ? UIConfigType.Light : UIConfigType.Dark
        Dispatcher.trigger(Dispatcher.Event.StyleUpdated, payload: nil)
    }

}
