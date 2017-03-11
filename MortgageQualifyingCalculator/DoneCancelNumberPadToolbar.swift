//
//  DoneCancelNumberPadToolbar.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/29/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

@objc protocol DoneCancelNumberPadToolbarDelegate {
    func didClickDone(controller: DoneCancelNumberPadToolbar, textField: UITextField)
    func didClickCancel(controller: DoneCancelNumberPadToolbar, textField: UITextField)
}

class DoneCancelNumberPadToolbar: UIToolbar {
    
    var textField: UITextField!
    var padDelegate: DoneCancelNumberPadToolbarDelegate!

    func initWith(textField initTextField: UITextField,
                  withPadDelegate padDelegate: DoneCancelNumberPadToolbarDelegate) -> DoneCancelNumberPadToolbar {
        return initWith(textField: initTextField, withKeyboardType: .decimalPad, withPadDelegate: padDelegate)
    }
    
    func initWith(textField initTextField: UITextField, withKeyboardType keyboardType: UIKeyboardType, withPadDelegate padDelegate: DoneCancelNumberPadToolbarDelegate) -> DoneCancelNumberPadToolbar {
        frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        textField = initTextField
        textField.keyboardType = keyboardType
        barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace,
                                        target: self,
                                        action: nil)
        
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: UIBarButtonItemStyle.done,
                                         target: self,
                                         action: #selector(DoneCancelNumberPadToolbar.doneWithNumberPad))
        
        doneButton.setTitleTextAttributes(
            [
                NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 20)!,
                NSForegroundColorAttributeName: UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
            ],
            for: .normal)
        
        self.items = [flexSpace, doneButton]
        
        self.sizeToFit()
        self.padDelegate = padDelegate
        return self
    }
    
    func cancelNumberPad() {
        textField.resignFirstResponder()
        textField.text = ""
        self.padDelegate.didClickDone(controller: self, textField: textField)
    }
    
    func doneWithNumberPad() {
        textField.resignFirstResponder()
        self.padDelegate.didClickCancel(controller: self, textField: textField)
    }
    
}
