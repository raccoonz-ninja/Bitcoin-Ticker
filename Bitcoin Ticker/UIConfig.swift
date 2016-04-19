//
//  UIConfig.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/6/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class UI: NSObject {
    static var current: UIConfig {
        get {
            let configType = Config.uiType
            if configType == UIConfigType.Dark {
                return DarkUI()
            } else if configType == UIConfigType.Light {
                return LightUI()
            } else {
                return UIConfig()
            }
        }
    }
}

class UIConfig: NSObject {

    // Global
    // ------
    var statusBarStyle = UIStatusBarStyle.LightContent
    var appBackgroundColor = Color.primaryColor
    var appTextColor = Color.primaryColorLight
    var pageControlColor = Color.primaryColorLight
    
    
    // Settings Page
    // -------------
    var switchColor = Color.primaryColorLight
    
    
    // Main Page
    // ---------
    var currentPriceFont = UIFont.systemFontOfSize(60, weight: UIFontWeightUltraLight)
    var currentPriceColor = Color.primaryColorLight
    var lastUpdateFont = UIFont.systemFontOfSize(15, weight: UIFontWeightRegular)
    var lastUpdateColor = Color.primaryColorMediumLight
    
    
    // Trade Page
    // ----------
    var lockScreenFadeOutDuration = 0.6
    
    var tradeTableVOffset = CGFloat(80)
    var tradeAddButtonColor = Color.primaryColorLight
    var tradeAddButtonFontSize = UIFont.systemFontOfSize(30, weight: UIFontWeightThin)
    var tradePlaceholderFont = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    var tradePlaceholderColor = Color.primaryColorLight
    
    var tradeCellVPadding = CGFloat(10)
    var tradeCellHPadding = CGFloat(20)
    var tradeCellFont = UIFont.systemFontOfSize(16, weight: UIFontWeightRegular)
    var tradeCellSmallFont = UIFont.systemFontOfSize(12, weight: UIFontWeightRegular)
    var tradeCellColor = Color.primaryColorLight
    var tradeCellSubtitleColor = Color.primaryColorMediumLight
    var tradeCellDeleteColor = Color.redColor
    var tradeCellEditColor = Color.primaryColorLight
    
    var tradeFormHMargin = CGFloat(50)
    var tradeFormTitleVMargin = CGFloat(10)
    var tradeFormLabelLeftMargin = CGFloat(20)
    var tradeFormTextfieldVMargin = CGFloat(20)
    var tradeFormTextfieldRightMargin = CGFloat(20)
    var tradeFormTextColor = Color.primaryColor
    var tradeFormTextFieldBorderColor = Color.primaryColor
    var tradeFormButtonTextColor = Color.primaryColor
    var tradeFormButtonBorderColor = Color.primaryColor
    var tradeFormBackground = Color.primaryColorLight
    var tradeFormBorderColor = UIColor.clearColor()
    var tradeFormDatePickerColor = Color.primaryColorLight
    var tradeFormCornerRadius = CGFloat(4)
    var tradeFormTextFieldCornerRadius = CGFloat(3)
    var tradeFormButtonCornerRadius = CGFloat(3)

}

class DarkUI: UIConfig {
}

class LightUI: UIConfig {
    
    override init() {
        super.init()

        // Global
        // ------
        self.statusBarStyle = UIStatusBarStyle.Default
        self.appBackgroundColor = Color.lightGray
        self.appTextColor = Color.primaryColor
        self.pageControlColor = Color.primaryColor
        
        
        // Settings Page
        // -------------
        self.switchColor = Color.mediumGray
        
        
        // Main Page
        // ---------
        self.currentPriceColor = Color.primaryColor
        self.lastUpdateColor = Color.primaryColorMediumLight
        
        
        // Trade Page
        // ----------
        self.tradeAddButtonColor = Color.primaryColor
        self.tradePlaceholderColor = Color.primaryColor
        
        self.tradeCellColor = Color.primaryColor
        self.tradeCellSubtitleColor = Color.primaryColorMediumLight
        self.tradeCellDeleteColor = Color.redColor
        self.tradeCellEditColor = Color.mediumGray
        
        self.tradeFormBackground = Color.lightGray
        self.tradeFormBorderColor = Color.primaryColor
        self.tradeFormDatePickerColor = UIColor.clearColor()
    }

}
