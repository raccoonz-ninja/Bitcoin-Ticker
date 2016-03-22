//
//  Config.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/5/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class Config: NSObject {

    // Internal data structure used to persist the config
    private class ConfigData: NSObject, NSCoding {
        var deviceToken: String?
        var priceOnAppIcon: Bool
        var touchIdProtection: Bool
        override init() {
            self.deviceToken = nil
            self.priceOnAppIcon = false
            self.touchIdProtection = false
        }
        @objc required init?(coder aDecoder: NSCoder) {
            self.deviceToken = aDecoder.decodeObjectForKey("deviceToken") as? String
            self.priceOnAppIcon = aDecoder.decodeBoolForKey("priceOnAppIcon")
            self.touchIdProtection = aDecoder.decodeBoolForKey("touchIdProtection")
        }
        @objc func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(self.deviceToken, forKey: "deviceToken")
            aCoder.encodeBool(self.priceOnAppIcon, forKey: "priceOnAppIcon")
            aCoder.encodeBool(self.touchIdProtection, forKey: "touchIdProtection")
        }
    }


    private static var _loaded: Bool = false
    private static var _configDataKey = "configData"
    private static var _configData: ConfigData!
    
    
    // Public API
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
    static var priceOnAppIcon: Bool {
        get {
            loadIfNeeded()
            return _configData.priceOnAppIcon
        }
        set(priceOnAppIcon) {
            loadIfNeeded()
            _configData.priceOnAppIcon = priceOnAppIcon
            syncToDisk()
        }
    }
    static var touchIdProtection: Bool {
        get {
        loadIfNeeded()
        return _configData.touchIdProtection
        }
        set(touchIdProtection) {
            loadIfNeeded()
            _configData.touchIdProtection = touchIdProtection
            syncToDisk()
        }
    }

    
    // Private utilities
    private static func loadIfNeeded() {
        if !_loaded {
            loadFromDisk()
        }
    }
    private static func loadFromDisk() {
        _loaded = true
        guard let data = NSUserDefaults.standardUserDefaults().objectForKey(_configDataKey) as? NSData else {
            self._configData = ConfigData()
            return
        }
        guard let configData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? ConfigData else {
            self._configData = ConfigData()
            return
        }
        self._configData = configData
    }
    private static func syncToDisk() {
        let data = NSKeyedArchiver.archivedDataWithRootObject(_configData)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: _configDataKey)
    }

}
