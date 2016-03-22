//
//  UIConfig.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class UIConfig: NSObject {

    // Global
    // ------
    static let appBackgroundColor = Color.primaryColor
    static let appTextColor = Color.primaryColorLight
    static let pageControlColor = Color.primaryColorLight
    
    
    // Settings Page
    // -------------
    static let switchColor = Color.primaryColorLight
    
    
    // Main Page
    // ---------
    static let currentPriceFont = UIFont.systemFontOfSize(60, weight: UIFontWeightUltraLight)
    static let currentPriceColor = Color.primaryColorLight
    static let lastUpdateFont = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
    static let lastUpdateColor = Color.primaryColorMediumLight
    
    
    // Trade Page
    // ----------
    static let lockScreenFadeOutDuration = 0.6
    
    static let tradeTableVOffset = CGFloat(80)
    static let tradeAddButtonColor = Color.primaryColorLight
    static let tradeAddButtonFontSize = UIFont.systemFontOfSize(30, weight: UIFontWeightThin)
    static let tradePlaceholderFont = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    static let tradePlaceholderColor = Color.primaryColorLight
    
    static let tradeCellVPadding = CGFloat(10)
    static let tradeCellHPadding = CGFloat(20)
    static let tradeCellFont = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    static let tradeCellSmallFont = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    static let tradeCellColor = Color.primaryColorLight
    static let tradeCellSubtitleColor = Color.primaryColorMediumLight
    static let tradeCellDeleteColor = Color.redColor
    static let tradeCellEditColor = Color.primaryColorLight
    
    static let tradeFormTextColor = Color.primaryColor
    static let tradeFormTextFieldBorderColor = Color.primaryColor
    static let tradeFormButtonTextColor = Color.primaryColor
    static let tradeFormButtonBorderColor = Color.primaryColor
    static let tradeFormBackground = Color.primaryColorLight
    static let tradeFormDatePickerColor = Color.primaryColorLight

}
