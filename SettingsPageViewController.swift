//
//  SettingsPageViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class SettingsPageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView(frame: CGRectZero, style: .Grouped)
    private let priceOnAppIconCellIdentifier = "priceOnAppIconCell"
    private let tradeTouchIdCellIdentifier = "tradeTouchIdCell"
    private let uiConfigSelectorCellIdentifier = "uiConfigSelectorCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.registerClass(PriceOnAppIconCell.self, forCellReuseIdentifier: priceOnAppIconCellIdentifier)
        self.tableView.registerClass(TradeTouchIdCell.self, forCellReuseIdentifier: tradeTouchIdCellIdentifier)
        self.tableView.registerClass(UIStyleCell.self, forCellReuseIdentifier: uiConfigSelectorCellIdentifier)

        self.view.addSubview(self.tableView)

        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0, let cell = tableView.dequeueReusableCellWithIdentifier(tradeTouchIdCellIdentifier) {
            return cell
        } else if row == 1, let cell = tableView.dequeueReusableCellWithIdentifier(uiConfigSelectorCellIdentifier) {
            return cell
        } else if row == 2, let cell = tableView.dequeueReusableCellWithIdentifier(priceOnAppIconCellIdentifier) {
            return cell
        }
        return UITableViewCell()
    }

}
