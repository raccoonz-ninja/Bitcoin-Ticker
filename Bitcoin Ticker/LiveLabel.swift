//
//  LiveLabel.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/19/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class LiveLabel: UILabel {

    private var _template: String
    private var _date: NSDate
    
    var template: String {
        get {
            return self._template
        }
        set(newTemplate) {
            self._template = newTemplate
            self.updateText()
        }
    }
    
    var date: NSDate {
        get {
            return self._date
        }
        set(newDate) {
            self._date = newDate
            self.updateText()
        }
    }
    
    init(template: String, date: NSDate) {
        self._template = template
        self._date = date
        super.init(frame: CGRectZero)
        self.updateText()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateText", userInfo: nil, repeats: true)
    }
    
    convenience init(template: String) {
        self.init(template: template, date: NSDate(timeIntervalSinceNow: 0))
    }
    
    convenience init() {
        self.init(template: "%TIME%", date: NSDate(timeIntervalSinceNow: 0))
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    func updateText() {
        let fromNow = self._date.fromNow()
        let newText = self._template.stringByReplacingOccurrencesOfString("%TIME%", withString: fromNow)
        self.text = newText.lowercaseString
    }

}
