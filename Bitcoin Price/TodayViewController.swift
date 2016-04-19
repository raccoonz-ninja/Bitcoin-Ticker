//
//  TodayViewController.swift
//  Bitcoin Price
//
//  Created by Matthis Perrin on 3/19/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private static let notificationCenter = NSNotificationCenter.defaultCenter()
    
    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var lastUpdateLabel: LiveLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0, 120)
        self.bitcoinPrice.translatesAutoresizingMaskIntoConstraints = false
        self.bitcoinPrice.text = ""
        self.lastUpdateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.lastUpdateLabel.textColor = UIColor(white: 1, alpha: 0.4)
        self.lastUpdateLabel.font = UIFont.systemFontOfSize(14.0)
        self.lastUpdateLabel.template = ""
        BitcoinPriceService.start()
        TodayViewController.notificationCenter.addObserver(self, selector: #selector(TodayViewController.updatePrice(_:)), name: "price_update", object: nil)
    }
    
    func updatePrice(notification: NSNotification) {
        dispatch_async(dispatch_get_main_queue()) {
            if let price = notification.object as? NSDecimalNumber {
                self.bitcoinPrice.text = price.usdValue
                self.lastUpdateLabel.date = NSDate()
                self.lastUpdateLabel.template = "Updated %time%"
            }
        }
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
