//
//  MSTextField.swift
//  MortgageQualifyingCalculator
//
//  Created by Mitch Stewart on 1/29/17.
//  Copyright © 2017 Mitch Stewart. All rights reserved.
//

import UIKit

@IBDesignable
class MSTextField: UITextField {
    
    @IBInspectable
    var borderColor: UIColor = UIColor.black { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var borderWidth: CGFloat = 1 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var maxLength: Int = 6 { didSet { setNeedsDisplay() } }
    
    var input: Double {
        get {
            if let input = Double(text!)  {
                return input
            } else {
                return 0.00
            }
        }
        set {
            text = String(newValue)
        }
    }
    
    override func draw(_ rect: CGRect) {
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }
}

extension String {
    var isNumeric: Bool {
        return !isEmpty && range(of: "[0-9]", options: .regularExpression) == nil
    }
}
