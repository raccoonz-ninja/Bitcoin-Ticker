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
    
    private var trades: [Trade] = [
        Trade(type: Trade.TradeType.Buy,  amount: 1,          price: 421.32,  date: NSDate(timeIntervalSinceNow: -60 * 60 * 24 * 3)),
        Trade(type: Trade.TradeType.Sell, amount: 0.00000001, price: 100,     date: NSDate(timeIntervalSinceNow: -60 * 60 * 24 * 1)),
        Trade(type: Trade.TradeType.Buy,  amount: 1.23,       price: 20,      date: NSDate(timeIntervalSinceNow: -60 * 60 * 2)),
        Trade(type: Trade.TradeType.Sell, amount: 200,        price: 1034.56, date: NSDate(timeIntervalSinceNow: -60 * 10)),
        Trade(type: Trade.TradeType.Buy,  amount: 4.21,       price: 345,     date: NSDate(timeIntervalSinceNow: -60 * 60 * 24 * 365 * 2.6))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped)
        self.tableView.dataSource = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = UIColor.clearColor()
//        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.registerClass(TradeTableViewCell.self, forCellReuseIdentifier: tradeCellIdentifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44
        
        self.view.addSubview(self.tableView)
        
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.tableView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trades.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(tradeCellIdentifier) as? TradeTableViewCell {
            let trade = self.trades[indexPath.row]
            cell.setTrade(trade)
            return cell
        }
        return UITableViewCell()
    }

}
