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
    private var preventNextReload = false
    
    var tradePageViewController: TradePageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: .Plain)
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
            self.reloadTable()
        }
    }
    
    func reloadTable() {
        if self.preventNextReload {
            self.preventNextReload = false
        } else {
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
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Normal, title: "Delete", handler: self.handleDelete)
        deleteAction.backgroundColor = UIConfig.tradeCellDeleteColor
        
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit", handler: self.handleEdit)
        editAction.backgroundColor = UIConfig.tradeCellEditColor
        
        return [deleteAction, editAction]
    }
    
    func handleDelete(action: UITableViewRowAction, forRowAtIndexPath indexPath: NSIndexPath) {
        self.preventNextReload = true
        TradeList.remove(TradeList.trades[indexPath.row].id)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    func handleEdit(action: UITableViewRowAction, forRowAtIndexPath indexPath: NSIndexPath) {
        let tradeForm = TradeFormViewController()
        tradeForm.setTradeToEdit(TradeList.trades[indexPath.row])
        if let vc = self.tradePageViewController {
            vc.presentViewController(tradeForm, animated: true, completion: nil)
        }
    }

}
