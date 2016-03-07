//
//  ViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 2/29/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var priceOnAppIconSwitch: UISwitch!
    
    @IBAction func onPriceOnAppIconChanged(sender: AnyObject) {
        self.priceOnAppIconSwitch.enabled = false
        NotificationService.setPriceOnAppIconSetting(self.priceOnAppIconSwitch.on) { (priceOnAppIcon, error) -> Void in
            if let value = priceOnAppIcon {
                print("Set to \(value ? "true" : "false")")
            } else if let error = error {
                self.priceOnAppIconSwitch.on = !self.priceOnAppIconSwitch.on // Revert on failure
                NSLog("\(error.debugDescription)")
            }
            self.priceOnAppIconSwitch.enabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

