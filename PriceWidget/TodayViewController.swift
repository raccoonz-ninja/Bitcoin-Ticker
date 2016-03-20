//
//  TodayViewController.swift
//  PriceWidget
//
//  Created by Matthis Perrin on 3/19/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    override func loadView() {
        print(1)
//        self.preferredContentSize = CGSizeMake(100, 100)
//        self.view = UIView(frame: CGRectMake(0, 0, 100, 100))
    }
    
    override func viewDidLoad() {
        print(1)
        super.viewDidLoad()
        let label = UILabel()
        label.text = "Hello there!"
        self.view.addSubview(label)
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0))
    }
    
}
