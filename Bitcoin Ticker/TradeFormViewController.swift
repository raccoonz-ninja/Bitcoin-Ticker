//
//  TradeFormViewController.swift
//  Bitcoin Ticker
//
//  Created by Matthis Perrin on 3/13/16.
//  Copyright © 2016 Raccoonz Ninja. All rights reserved.
//

import UIKit

class TradeFormViewController: UIViewController, UITextFieldDelegate {

    private var tradeToEdit: Trade?
    
    private let backgroundViewTag = 1
    private let contentViewTag = 2
    private let priceTextfieldTag = 3
    private let dateTextfieldTag = 4
    private let currentDateFormatter = NSDateFormatter()
    private let dateFormatter = NSDateFormatter()

    private var date: NSDate?
    private var priceSet = false
    
    let contentView = UIView()
    var contentViewVConstraint_noKeyboard: NSLayoutConstraint!
    var contentViewVConstraint_withKeyboard: NSLayoutConstraint!
    
    var datePickerShown = false
    var datePickerBottomConstraint_shown: NSLayoutConstraint!
    var datePickerBottomConstraint_hidden: NSLayoutConstraint!
    
    let titleLabel = UILabel()
    
    let amountLabel = UILabel()
    let amountTextfield = UITextField()
    let priceLabel = UILabel()
    let priceTextfield = UITextField()
    let datelabel = UILabel()
    let dateTextfield = UITextField()
    let dateDatePicker = UIDatePicker()
    
    let buyButton = UIButton()
    let sellButton = UIButton()
    
    func setTradeToEdit(trade: Trade) {
        self.tradeToEdit = trade
        
        self.priceSet = true
        self.date = trade.date
        
        self.amountTextfield.text = trade.amount.btcValueWithoutSymbol
        self.priceTextfield.text = trade.price.usdValue
        self.dateDatePicker.date = trade.date
        self.updateDateTextField()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentDateFormatter.dateFormat = "'Today at 'HH:mm:ss"
        self.dateFormatter.dateFormat = "MMMM dd' at 'HH:mm"
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.userInteractionEnabled = true
        self.view.tag = backgroundViewTag
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TradeFormViewController.onBackgroundTap(_:))))
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.userInteractionEnabled = true
        self.contentView.tag = contentViewTag
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TradeFormViewController.onBackgroundTap(_:))))
        self.view.addSubview(self.contentView)
        
        self.titleLabel.text = self.tradeToEdit != nil ? "Update trade" : "Add a trade"
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.titleLabel)
        
        self.amountLabel.text = "Amount"
        self.amountLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.amountLabel)
        
        self.amountTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.amountTextfield.borderStyle = .Line
        self.amountTextfield.layer.borderWidth = 1
        self.amountTextfield.textAlignment = .Right
        self.amountTextfield.keyboardType = .DecimalPad
        self.amountTextfield.delegate = self
        self.contentView.addSubview(self.amountTextfield)
        
        self.priceLabel.text = "Price"
        self.priceLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.priceLabel)
        
        self.priceTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.priceTextfield.borderStyle = .Line
        self.priceTextfield.layer.borderWidth = 1
        self.priceTextfield.textAlignment = .Right
        self.priceTextfield.tag = priceTextfieldTag
        self.priceTextfield.keyboardType = .DecimalPad
        self.priceTextfield.delegate = self
        self.contentView.addSubview(self.priceTextfield)
        
        self.datelabel.text = "When"
        self.datelabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.datelabel)
        
        self.dateTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.dateTextfield.borderStyle = .Line
        self.dateTextfield.layer.borderWidth = 1
        self.dateTextfield.layer.cornerRadius = 3
        self.dateTextfield.textAlignment = .Right
        self.dateTextfield.tag = self.dateTextfieldTag
        self.dateTextfield.delegate = self
        self.dateTextfield.addTarget(self, action: Selector("onDateTextfieldTap"), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(self.dateTextfield)
        
        self.dateDatePicker.translatesAutoresizingMaskIntoConstraints = false
        self.dateDatePicker.addTarget(self, action: #selector(TradeFormViewController.onDatePickerChange), forControlEvents: .ValueChanged)
        self.view.addSubview(self.dateDatePicker)
        
        self.buyButton.setTitle("Buy", forState: .Normal)
        self.buyButton.translatesAutoresizingMaskIntoConstraints = false
        self.buyButton.layer.borderWidth = 1
        self.buyButton.addTarget(self, action: #selector(TradeFormViewController.onBuyTap), forControlEvents: .TouchUpInside)
        self.buyButton.enabled = true
        self.contentView.addSubview(self.buyButton)
        
        self.sellButton.setTitle("Sell", forState: .Normal)
        self.sellButton.translatesAutoresizingMaskIntoConstraints = false
        self.sellButton.layer.borderWidth = 1
        self.sellButton.addTarget(self, action: #selector(TradeFormViewController.onSellTap), forControlEvents: .TouchUpInside)
        self.sellButton.enabled = true
        self.contentView.addSubview(self.sellButton)
        
        
        self.view.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: -UI.current.tradeFormHMargin))
        self.view.addConstraint(NSLayoutConstraint(item: self.contentView, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: UI.current.tradeFormHMargin))
        self.contentViewVConstraint_noKeyboard = NSLayoutConstraint(item: self.contentView, attribute: .CenterY, relatedBy: .Equal, toItem: self.view, attribute: .CenterY, multiplier: 1, constant: 0)
        self.contentViewVConstraint_withKeyboard = NSLayoutConstraint(item: self.contentView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 0.5, constant: 0)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: UI.current.tradeFormTitleVMargin))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1, constant: 0))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1, constant: UI.current.tradeFormLabelLeftMargin))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.amountLabel, attribute: .Top, relatedBy: .Equal, toItem: self.titleLabel, attribute: .Bottom, multiplier: 1, constant: UI.current.tradeFormTitleVMargin + UI.current.tradeFormTextfieldVMargin))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.amountTextfield, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1, constant: -UI.current.tradeFormTextfieldRightMargin))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.amountTextfield, attribute: .CenterY, relatedBy: .Equal, toItem: self.amountLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.amountTextfield, attribute: .Width, relatedBy: .Equal, toItem: self.contentView, attribute: .Width, multiplier: 1, constant: -125))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.priceLabel, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1, constant: UI.current.tradeFormLabelLeftMargin))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.priceLabel, attribute: .Top, relatedBy: .Equal, toItem: self.amountLabel, attribute: .Bottom, multiplier: 1, constant: UI.current.tradeFormTextfieldVMargin))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.priceTextfield, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1, constant: -UI.current.tradeFormTextfieldRightMargin))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.priceTextfield, attribute: .CenterY, relatedBy: .Equal, toItem: self.priceLabel, attribute: .CenterY, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.priceTextfield, attribute: .Width, relatedBy: .Equal, toItem: self.contentView, attribute: .Width, multiplier: 1, constant: -125))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.datelabel, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .Left, multiplier: 1, constant: UI.current.tradeFormLabelLeftMargin))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.datelabel, attribute: .Top, relatedBy: .Equal, toItem: self.priceLabel, attribute: .Bottom, multiplier: 1, constant: UI.current.tradeFormTextfieldVMargin))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.dateTextfield, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .Right, multiplier: 1, constant: -UI.current.tradeFormTextfieldRightMargin))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.dateTextfield, attribute: .CenterY, relatedBy: .Equal, toItem: self.datelabel, attribute: .CenterY, multiplier: 1, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.dateTextfield, attribute: .Width, relatedBy: .Equal, toItem: self.contentView, attribute: .Width, multiplier: 1, constant: -125))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.buyButton, attribute: .Top, relatedBy: .Equal, toItem: self.datelabel, attribute: .Bottom, multiplier: 1, constant: 20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.buyButton, attribute: .Right, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1, constant: -10))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.buyButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.buyButton, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .Width, multiplier: 1, constant: 100))
        
        self.contentView.addConstraint(NSLayoutConstraint(item: self.sellButton, attribute: .Top, relatedBy: .Equal, toItem: self.datelabel, attribute: .Bottom, multiplier: 1, constant: 20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.sellButton, attribute: .Left, relatedBy: .Equal, toItem: self.contentView, attribute: .CenterX, multiplier: 1, constant: 10))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.sellButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.contentView, attribute: .Bottom, multiplier: 1, constant: -20))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.sellButton, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .Width, multiplier: 1, constant: 100))
        
        self.view.addConstraint(NSLayoutConstraint(item: self.dateDatePicker, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(item: self.dateDatePicker, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0))
        self.datePickerBottomConstraint_shown = NSLayoutConstraint(item: self.dateDatePicker, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -0)
        self.datePickerBottomConstraint_hidden = NSLayoutConstraint(item: self.dateDatePicker, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 220)
        
        self.updateContentViewConstraint(false)
        self.updateDatePickerConstraint(false)
        self.updateDateTextField()
        
        // Refresh date field
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(TradeFormViewController.updateDateTextField), userInfo: nil, repeats: true)
        
        // Refresh the price field
        Dispatcher.on(Dispatcher.Event.NewPriceFetched) {
            self.updatePriceTextField()
        }
        self.updatePriceTextField()
        if self.tradeToEdit == nil {
            self.amountTextfield.text = "0.1"
        }
        self.updateStyle()
        Dispatcher.on(Dispatcher.Event.StyleUpdated) {
            self.updateStyle()
        }
    }
    
    func updateStyle() {
        self.contentView.layer.cornerRadius = UI.current.tradeFormCornerRadius
        self.contentView.backgroundColor = UI.current.tradeFormBackground
        self.contentView.layer.borderColor = UI.current.tradeFormBorderColor.CGColor
        self.contentView.layer.borderWidth = 1
        self.titleLabel.textColor = UI.current.tradeFormTextColor
        self.amountLabel.textColor = UI.current.tradeFormTextColor
        self.amountTextfield.layer.borderColor = UI.current.tradeFormTextFieldBorderColor.CGColor
        self.amountTextfield.layer.cornerRadius = UI.current.tradeFormTextFieldCornerRadius
        self.amountTextfield.tintColor = UI.current.tradeFormTextFieldBorderColor
        self.priceLabel.textColor = UI.current.tradeFormTextColor
        self.priceTextfield.layer.borderColor = UI.current.tradeFormTextFieldBorderColor.CGColor
        self.priceTextfield.layer.cornerRadius = UI.current.tradeFormTextFieldCornerRadius
        self.priceTextfield.tintColor = UI.current.tradeFormTextFieldBorderColor
        self.datelabel.textColor = UI.current.tradeFormTextColor
        self.dateTextfield.layer.borderColor = UI.current.tradeFormTextFieldBorderColor.CGColor
//        self.dateDatePicker.setValue(UI.current.tradeFormDatePickerColor, forKey: "textColor") // Not working :(
        self.dateDatePicker.backgroundColor = UI.current.tradeFormDatePickerColor
        self.buyButton.layer.borderColor = UI.current.tradeFormButtonBorderColor.CGColor
        self.buyButton.layer.cornerRadius = UI.current.tradeFormButtonCornerRadius
        self.buyButton.setTitleColor(UI.current.tradeFormButtonTextColor, forState: .Normal)
        self.sellButton.layer.borderColor = UI.current.tradeFormButtonBorderColor.CGColor
        self.sellButton.layer.cornerRadius = UI.current.tradeFormButtonCornerRadius
        self.sellButton.setTitleColor(UI.current.tradeFormButtonTextColor, forState: .Normal)
    }
    
    func closeKeyboard() -> Bool {
        for textfield in [self.amountTextfield, self.priceTextfield] {
            if textfield.isFirstResponder() {
                textfield.resignFirstResponder()
                return true
            }
        }
        return false
    }
    
    func onBackgroundTap(gesture: UITapGestureRecognizer) {
        if datePickerShown {
            closeKeyboard()
            self.updateDatePickerConstraint(false)
            self.updateContentViewConstraint(false)
            return
        } else if closeKeyboard() {
            self.updateDatePickerConstraint(false)
            self.updateContentViewConstraint(false)
            return
        }
        if gesture.view?.tag == backgroundViewTag {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if gesture.view?.tag == contentViewTag {
            // Don't do anything (eat touch event)
        }
    }
    
    func updateContentViewConstraint(keyboardOpened: Bool) {
        if keyboardOpened {
            self.contentViewVConstraint_noKeyboard.active = false
            self.contentViewVConstraint_withKeyboard.active = true
        } else {
            self.contentViewVConstraint_withKeyboard.active = false
            self.contentViewVConstraint_noKeyboard.active = true
        }
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateDatePickerConstraint(shown: Bool) {
        self.datePickerShown = shown
        if shown {
            self.datePickerBottomConstraint_hidden.active = false
            self.datePickerBottomConstraint_shown.active = true
        } else {
            self.datePickerBottomConstraint_shown.active = false
            self.datePickerBottomConstraint_hidden.active = true
        }
        UIView.animateWithDuration(0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateDateTextField() {
        if let date = self.date {
            self.dateTextfield.text = self.dateFormatter.stringFromDate(date)
        } else {
            self.dateTextfield.text = self.currentDateFormatter.stringFromDate(NSDate(timeIntervalSinceNow: 0))
        }
    }
    
    func updatePriceTextField() {
        if !self.priceSet {
            self.priceTextfield.text = BitcoinPrice.last.last.usdValue
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let isDateTextfield = textField.tag == dateTextfieldTag
        if isDateTextfield {
            self.closeKeyboard()
            self.updateContentViewConstraint(true)
            self.updateDatePickerConstraint(true)
        }
        return !isDateTextfield
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.updateContentViewConstraint(true)
        self.updateDatePickerConstraint(false)
        if textField.tag == self.priceTextfieldTag {
            self.priceSet = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.updateContentViewConstraint(false)
        self.updateDatePickerConstraint(false)
    }
    
    func onDatePickerChange() {
        self.date = self.dateDatePicker.date
    }
    
    func matchesForRegexInText(regex: String, text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: NSRegularExpressionOptions.CaseInsensitive)
            let nsString = text as NSString
            let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length))
            print(results)
            return results.map() { nsString.substringWithRange($0.range)}
        } catch {
            return []
        }
    }
    
    func parseNumber(value: String) -> NSDecimalNumber? {
        do {
            let valueNSString = value as NSString
            let numberRegex = try NSRegularExpression(pattern: "[0-9]*(\\.[0-9]*)?", options: NSRegularExpressionOptions.CaseInsensitive)
            let matches = numberRegex.matchesInString(value, options: [], range: NSMakeRange(0, valueNSString.length))
            for match in matches {
                let numberString = valueNSString.substringWithRange(match.range)
                let number = NSDecimalNumber(string: numberString)
                if number != NSDecimalNumber.notANumber() {
                    return number
                }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func createTrade(tradeType: Trade.TradeType) {
        if let amount = parseNumber(self.amountTextfield.text ?? "0"), let price = parseNumber(self.priceTextfield.text ?? "0") {
            let date = self.date ?? NSDate(timeIntervalSinceNow: 0)
            if let trade = self.tradeToEdit {
                trade.type = tradeType
                trade.amount = amount
                trade.price = price
                trade.date = date
                TradeList.update(trade)
            } else {
                let trade = Trade(type: tradeType, amount: amount, price: price, date: date)
                TradeList.add(trade)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func onBuyTap() {
        self.createTrade(Trade.TradeType.Buy)
    }
    
    func onSellTap() {
        self.createTrade(Trade.TradeType.Sell)
    }
    
}
