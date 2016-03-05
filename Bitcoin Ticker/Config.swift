//
//  Config.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/5/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class ConfigData: NSObject, NSCoding {
    var deviceToken: String?
    required init?(coder aDecoder: NSCoder) {
        self.deviceToken = aDecoder.decodeObjectForKey("deviceToken") as? String
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.deviceToken, forKey: "deviceToken")
    }
}

class Config: NSObject {

    private static var _loaded: Bool = false
    private static var _configDataKey = "configData"
    private static var _configData: ConfigData!

    static var deviceToken: String? {
        get {
            loadIfNeeded()
            return _configData.deviceToken
        }
        set(token) {
            loadIfNeeded()
            _configData.deviceToken = token
            syncToDisk()
        }
    }

    private static func loadIfNeeded() {
        if !_loaded {
            loadFromDisk()
        }
    }
    static func loadFromDisk() {
        _loaded = true
        guard let data = NSUserDefaults.standardUserDefaults().objectForKey(_configDataKey) as? NSData else {
            return
        }
        guard let configData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ConfigData else {
            return
        }
        self._configData = configData
    }
    static func syncToDisk() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(_configData)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: _configDataKey)
    }

}
