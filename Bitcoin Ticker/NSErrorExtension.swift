//
//  NSErrorExtension.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

extension NSError {
    
    static func error(domain: String, message: String) -> NSError {
        return NSError(domain: domain, code: 1, userInfo: [
            NSLocalizedDescriptionKey: message
        ])
    }

}
