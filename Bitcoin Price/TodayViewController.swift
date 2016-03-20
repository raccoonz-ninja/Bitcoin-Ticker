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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSizeMake(0, 100)
        self.bitcoinPrice.translatesAutoresizingMaskIntoConstraints = false
        self.bitcoinPrice.text = ""
        BitcoinPriceService.start()
        TodayViewController.notificationCenter.addObserver(self, selector: "updatePrice:", name: "price_update", object: nil)
    }
    
    func updatePrice(notification: NSNotification) {
        if let price = notification.object as? NSDecimalNumber {
            self.bitcoinPrice.text = price.usdValue
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
        print(defaultMarginInsets)
        return UIEdgeInsetsZero
    }
    
}
