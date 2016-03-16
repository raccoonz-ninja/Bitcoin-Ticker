//
//  TradeTableViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/10/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class TradeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var tableView: UITableView!
    private let tradeCellIdentifier = "tradeCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: .Plain)
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = UIColor.clearColor()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.registerClass(TradeTableViewCell.self, forCellReuseIdentifier: tradeCellIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 85
        
        self.view.addSubview(self.tableView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
        
        Dispatcher.on(Dispatcher.Event.TradesUpdated) {
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TradeList.trades.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(tradeCellIdentifier) as? TradeTableViewCell {
            let trade = TradeList.trades[indexPath.row]
            cell.setTrade(trade)
            return cell
        }
        return UITableViewCell()
    }

}
