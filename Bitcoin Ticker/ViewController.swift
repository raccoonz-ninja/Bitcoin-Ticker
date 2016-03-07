//
//  ViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 2/29/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet weak var priceOnAppIconSwitch: UISwitch!
    @IBOutlet weak var currentPrice: UILabel!
    
    @IBAction func onPriceOnAppIconChanged(sender: AnyObject) {
        self.priceOnAppIconSwitch.enabled = false
        NotificationService.setPriceOnAppIconSetting(self.priceOnAppIconSwitch.on) { (priceOnAppIcon, error) -> Void in
            if let value = priceOnAppIcon {
                print("Set to \(value ? "true" : "false")")
            } else if let error = error {
                self.priceOnAppIconSwitch.on = !self.priceOnAppIconSwitch.on // Revert on failure
                let verb = self.priceOnAppIconSwitch.on ? "enable" : "disable"
                SVProgressHUD.showErrorWithStatus("Couldn't \(verb) setting. Internet problem?")
                NSLog("\(error.debugDescription)")
            }
            self.priceOnAppIconSwitch.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceOnAppIconSwitch.on = Config.priceOnAppIcon
        updatePrice()
        Dispatcher.on(Dispatcher.Event.NewPriceReceived) { () -> Void in
            self.updatePrice()
        }
    }
    
    func updatePrice() {
        let last = BitcoinPrice.last.last
        currentPrice.text = last > 0 ? "$\(last)" : ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

